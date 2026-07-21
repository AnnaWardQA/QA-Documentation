<#
.SYNOPSIS
    Creates Azure DevOps Test Cases from a JSON file and adds them to a Test Suite.

.DESCRIPTION
    - Auto-refreshes the Azure AD bearer token via Azure CLI
    - Derives the JSON file path from the PBI number (e.g. pbi-26041-testcases.json)
    - Hardcoded org, project, plan and suite defaults (override via parameters)
    - Creates each test case as a work item with steps XML
    - Adds each created test case to the specified Test Suite

.PARAMETER PbiId
    The PBI number (e.g. 26041). Used to locate the JSON file automatically.

.PARAMETER JsonPath
    Optional. Full path to the JSON file. If not supplied, derived from PbiId.

.PARAMETER OrgUrl
    Azure DevOps organisation URL. Defaults to https://pgltravel.visualstudio.com

.PARAMETER Project
    Azure DevOps project name. Defaults to Apps

.PARAMETER PlanId
    Test Plan ID. Defaults to 8202

.PARAMETER SuiteId
    Test Suite ID. Defaults to 26043

.EXAMPLE
    .\scripts\azure_create_testcases_from_json.ps1 -PbiId 26041
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$PbiId,

    [Parameter(Mandatory = $false)]
    [string]$JsonPath,

    [string]$OrgUrl  = "https://pgltravel.visualstudio.com",
    [string]$Project = "Apps",
    [int]   $PlanId  = 8202,
    [int]   $SuiteId = 26043
)

# ---------------------------------------------------------------------------
# 1. Resolve JSON path
# ---------------------------------------------------------------------------
if (-not $JsonPath) {
    if (-not $PbiId) {
        $PbiId = Read-Host "Enter the PBI number (e.g. 26041)"
    }
    $JsonPath = ".\TestCases\pbi-$PbiId-testcases.json"
}

if (-not (Test-Path $JsonPath)) {
    Write-Error "JSON file not found: $JsonPath"
    exit 1
}

Write-Host "Reading test cases from: $JsonPath" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# 2. Obtain bearer token automatically via Azure CLI
# ---------------------------------------------------------------------------
Write-Host "Obtaining Azure AD token via Azure CLI..." -ForegroundColor Cyan
try {
    $token = (az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv 2>$null)
    if (-not $token) { throw "Empty token" }
    Write-Host "Token obtained successfully. ✅" -ForegroundColor Green
} catch {
    Write-Error "Failed to obtain token. Make sure you are signed in with 'az login'."
    exit 1
}

$headers = @{
    Authorization  = "Bearer $token"
    "Content-Type" = "application/json"
    "Accept"       = "application/json; api-version=5.0"
}

# ---------------------------------------------------------------------------
# 3. Load test cases
# ---------------------------------------------------------------------------
$cases = Get-Content $JsonPath -Raw | ConvertFrom-Json

# ---------------------------------------------------------------------------
# 4. Helper: build steps XML
# ---------------------------------------------------------------------------
function Build-StepsXml([array]$steps) {
    $last = $steps.Count
    $xml  = '<steps id="0" last="' + $last + '">'
    $i    = 1
    foreach ($s in $steps) {
        $action   = [System.Security.SecurityElement]::Escape($s.action)
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

# ---------------------------------------------------------------------------
# 5. Create test cases and add to suite
# ---------------------------------------------------------------------------
$created = @()

foreach ($c in $cases) {
    $title    = $c.title
    $stepsXml = Build-StepsXml $c.steps

    $body = @(
        @{ op = 'add'; path = '/fields/System.Title';                  value = $title },
        @{ op = 'add'; path = '/fields/Microsoft.VSTS.TCM.Steps';      value = $stepsXml }
    ) | ConvertTo-Json -Depth 6

    # --- Create the work item ---
    $createUrl = "$OrgUrl/$Project/_apis/wit/workitems/`$Test Case"
    try {
        $wi = Invoke-RestMethod -Uri $createUrl -Method Post -Headers @{
            Authorization  = "Bearer $token"
            "Content-Type" = "application/json-patch+json"
            "Accept"       = "application/json; api-version=5.0"
        } -Body $body

        $wiId = $wi.id
        Write-Host "Created Test Case: $title -> ID $wiId" -ForegroundColor Green

        # --- Add to suite ---
        $suiteUrl = "$OrgUrl/$Project/_apis/test/Plans/$PlanId/suites/$SuiteId/testcases/$wiId"
        Invoke-RestMethod -Uri $suiteUrl -Method Post -Headers $headers | Out-Null
        Write-Host "Added to Suite $SuiteId ✅" -ForegroundColor Green

        $created += [PSCustomObject]@{ Id = $wiId; Title = $title }

    } catch {
        Write-Host "Failed to create or add: $title ❌ $_" -ForegroundColor Red
    }
}

# ---------------------------------------------------------------------------
# 6. Summary
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "Done. Created $($created.Count) test cases." -ForegroundColor Cyan

$csvPath = "TestCases/pbi-$PbiId-created-testcases.csv"
$created | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "Created test case list saved to $csvPath" -ForegroundColor Cyan
