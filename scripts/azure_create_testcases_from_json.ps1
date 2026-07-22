<#
Creates Test Case work items in Azure DevOps from a JSON file and adds them to a Test Suite.
Run locally to keep your PAT secret. Usage:

1. Open PowerShell locally (not in this chat).
2. Set execution policy if required: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` (optional).
3. Run: `.	ools\azure_create_testcases_from_json.ps1 -JsonPath "TestCases/pbi-26041-testcases.json" -OrgUrl "https://dev.azure.com/pgltravel" -Project "Apps" -PlanId 8202 -SuiteId 26043`

The script prompts for a PAT securely and will create Test Case work items and attach them to the suite.
#>
param(
    [Parameter(Mandatory=$true)] [string]$JsonPath,
    [Parameter(Mandatory=$true)] [string]$OrgUrl,
    [Parameter(Mandatory=$true)] [string]$Project,
    [Parameter(Mandatory=$true)] [int]$PlanId,
    [Parameter(Mandatory=$true)] [int]$SuiteId
)

function Read-Pat {
    Write-Host "Enter Azure DevOps Personal Access Token (scopes: Work Items (Read & write), Test Management (Read & write))." -ForegroundColor Yellow
    $secure = Read-Host -AsSecureString "PAT (input will be hidden)"
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $unsecure = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    return $unsecure
}

function Get-AzureAdTokenFromAzCli {
    try {
        $res = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 2>$null | ConvertFrom-Json
        return $res.accessToken
    }
    catch {
        return $null
    }
}

if (-not (Test-Path $JsonPath)) {
    Write-Error "JSON file not found: $JsonPath"
    exit 1
}

# Prefer an existing AZDO_BEARER_TOKEN env var (set this from your session), else try to obtain via 'az' if available, otherwise prompt for PAT.
$bearer = $env:AZDO_BEARER_TOKEN
if (-not $bearer) {
    Write-Host "No AZDO_BEARER_TOKEN env var found. Attempting to obtain Azure AD token via Azure CLI (if you're signed in)..." -ForegroundColor Yellow
    $bearer = Get-AzureAdTokenFromAzCli
}

if ($bearer) {
    $headers = @{ Authorization = "Bearer $bearer" }
}
else {
    $pat = Read-Pat
    $pair = ":$pat"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
    $base64 = [Convert]::ToBase64String($bytes)
    $headers = @{ Authorization = "Basic $base64" }
}

$cases = Get-Content $JsonPath -Raw | ConvertFrom-Json

# Helper to build steps XML expected by Azure Test Case work item field
function Build-StepsXml([array]$steps) {
    $last = $steps.Count
    $xml = '<steps id="0" last="' + $last + '">'
    $i = 1
    foreach ($s in $steps) {
        $action = [System.Security.SecurityElement]::Escape($s.action)
        $expected = [System.Security.SecurityElement]::Escape($s.expected)
        $xml += '<step id="' + $i + '" type="Action">'
        $xml += "<actions><text>$action</text></actions>"
        $xml += "<expected><text>$expected</text></expected>"
        $xml += "</step>"
        $i++
    }
    $xml += "</steps>"
    return $xml
}

$created = @()

foreach ($c in $cases) {
    $title = $c.title
    $stepsXml = Build-StepsXml $c.steps

    $body = @(
        @{ op = 'add'; path = '/fields/System.Title'; value = $title },
        @{ op = 'add'; path = '/fields/Microsoft.VSTS.TCM.Steps'; value = $stepsXml }
    ) | ConvertTo-Json -Depth 6

    $createUrl = "$OrgUrl/$Project/_apis/wit/workitems/`$Test%20Case?api-version=6.0"

    try {
        $resp = Invoke-RestMethod -Method Patch -Uri $createUrl -Headers $headers -ContentType 'application/json-patch+json' -Body $body
        $id = $resp.id
        Write-Host "Created Test Case: $title -> ID $id" -ForegroundColor Green

        # Add to test suite
        $addUrl = "$OrgUrl/$Project/_apis/test/Plans/$PlanId/suites/$SuiteId/testcases/$id?api-version=6.0"
        Invoke-RestMethod -Method Post -Uri $addUrl -Headers $headers
        Write-Host "Added Test Case ID $id to Plan $PlanId Suite $SuiteId" -ForegroundColor Cyan
        $created += @{ id = $id; title = $title }
    }
    catch {
        Write-Host "Failed to create or add test case: $title" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

Write-Host "Done. Created $($created.Count) test cases." -ForegroundColor White

# Output created IDs to a CSV for traceability
$outPath = "TestCases/pbi-26041-created-testcases.csv"
$created | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $outPath -Encoding UTF8
Write-Host "Created test case list saved to $outPath" -ForegroundColor Yellow
