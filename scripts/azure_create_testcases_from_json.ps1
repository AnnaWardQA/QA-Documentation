<#
.SYNOPSIS
    Creates Azure DevOps Test Cases from a JSON file and adds them to a Test Suite.

.DESCRIPTION
    - Acquires an Azure AD token via environment variable or Azure CLI, or prompts for a PAT.
    - Builds Test Case steps using CDATA to preserve markup and special characters.
    - Logs request/response for debugging when needed.

USAGE
    From repo root:
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    .\scripts\azure_create_testcases_from_json.ps1 -JsonPath "TestCases\pbi-26041-testcases.json" -OrgUrl "https://dev.azure.com/pgltravel" -Project "Apps" -PlanId 8202 -SuiteId 26043
#>

param(
    [Parameter(Mandatory=$true)] [string]$JsonPath,
    [Parameter(Mandatory=$true)] [string]$OrgUrl,
    [Parameter(Mandatory=$true)] [string]$Project,
    [Parameter(Mandatory=$true)] [int]$PlanId,
    [Parameter(Mandatory=$true)] [int]$SuiteId
)

function Get-AzdoBearerToken {
    # Prefer explicit env var
    if ($env:AZDO_BEARER_TOKEN) { return $env:AZDO_BEARER_TOKEN }

    # Try Azure CLI
    if (Get-Command az -ErrorAction SilentlyContinue) {
        try {
            $tok = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv 2>$null
            if ($tok) { return $tok }
        } catch { }
    }

    return $null
}

function Read-Pat {
    Write-Host "Enter Azure DevOps Personal Access Token (scopes: Work Items & Test Management)" -ForegroundColor Yellow
    $secure = Read-Host -AsSecureString "PAT (input will be hidden)"
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $unsecure = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    return $unsecure
}

if (-not (Test-Path $JsonPath)) {
    Write-Error "JSON file not found: $JsonPath"
    exit 1
}

$cases = Get-Content $JsonPath -Raw | ConvertFrom-Json

function Build-StepsXml([array]$steps) {
    $last = $steps.Count
    $xml = '<steps id="0" last="' + $last + '">'    
    $i = 1
    foreach ($s in $steps) {
        $action = $s.action
        $expected = $s.expected
        $xml += '<step id="' + $i + '" type="Action">'
        $xml += '<actions><text><![CDATA[' + $action + ']]></text></actions>'
        $xml += '<expected><text><![CDATA[' + $expected + ']]></text></expected>'
        $xml += '</step>'
        $i++
    }
    $xml += '</steps>'
    return $xml
}

# Determine auth headers
$bearer = Get-AzdoBearerToken
if ($bearer) {
    $authHeaders = @{ Authorization = "Bearer $bearer" }
} else {
    $pat = Read-Pat
    $pair = ":$pat"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
    $base64 = [Convert]::ToBase64String($bytes)
    $authHeaders = @{ Authorization = "Basic $base64" }
}

$created = @()

foreach ($c in $cases) {
    $title = $c.title
    $stepsXml = Build-StepsXml $c.steps

    $body = @(
        @{ op = 'add'; path = '/fields/System.Title'; value = $title },
        @{ op = 'add'; path = '/fields/Microsoft.VSTS.TCM.Steps'; value = $stepsXml }
    ) | ConvertTo-Json -Depth 6

    $createUrl = $OrgUrl + '/' + $Project + '/_apis/wit/workitems/$Test%20Case?api-version=6.0'

    Write-Host "Creating: $title" -ForegroundColor Cyan
    Write-Host "Request body:" -ForegroundColor DarkYellow
    Write-Host $body

    try {
        $resp = Invoke-RestMethod -Method Patch -Uri $createUrl -Headers @{ Authorization = $authHeaders.Authorization } -ContentType 'application/json-patch+json' -Body $body
        Write-Host "Create response:" -ForegroundColor DarkGreen
        $resp | ConvertTo-Json -Depth 6 | Write-Host

        $id = $resp.id
        Write-Host "Created Test Case ID $id" -ForegroundColor Green

        $addUrl = $OrgUrl + '/' + $Project + "/_apis/test/Plans/$PlanId/suites/$SuiteId/testcases/$id?api-version=6.0"
        $addResp = Invoke-RestMethod -Method Post -Uri $addUrl -Headers @{ Authorization = $authHeaders.Authorization }
        Write-Host "Add-to-suite response:" -ForegroundColor DarkGreen
        $addResp | ConvertTo-Json -Depth 6 | Write-Host

        $created += [PSCustomObject]@{ Id = $id; Title = $title }
    }
    catch {
        Write-Host "Error creating test case: $title" -ForegroundColor Red
        if ($_.Exception.Response -ne $null) {
            try {
                $err = $_.Exception.Response.GetResponseStream() | Select-Object -First 1
                Write-Host $_.Exception.Response.StatusCode
            } catch { }
            Write-Host $_.Exception.Message
        } else { Write-Host $_.Exception.Message }
    }
}

# Save CSV
$csvPath = "TestCases/pbi-created-testcases.csv"
$created | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "Done. Created $($created.Count) test cases. CSV: $csvPath" -ForegroundColor Cyan
