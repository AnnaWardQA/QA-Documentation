$ErrorActionPreference = 'SilentlyContinue'
$base = 'http://familyadventures.qa.pgl.co.uk/'
try {
    $resp = Invoke-WebRequest -Uri $base -UseBasicParsing -TimeoutSec 30
} catch {
    Write-Output "Failed to fetch base page: $_"
    exit 1
}
$links = @()
if ($resp -and $resp.Links) { $links = $resp.Links } else { $links = @() }
$outLines = @('"url","status","final_url","link_text","location"')
foreach ($l in $links) {
    $href = $l.href
    if ([string]::IsNullOrWhiteSpace($href)) { continue }
    try {
        if (-not [uri]::IsWellFormedUriString($href,[uriKind]::Absolute)) { $u = [uri]::new($href,$base) } else { $u = [uri]$href }
    } catch { continue }
    $url = $u.AbsoluteUri
    $status = 'ERR'
    $final = $url
    try {
        $h = Invoke-WebRequest -Uri $url -Method Head -MaximumRedirection 10 -TimeoutSec 30 -UseBasicParsing -ErrorAction Stop
        if ($h.StatusCode) { $status = [string]$h.StatusCode.Value__ } else { $status = '200' }
        try { $final = $h.BaseResponse.ResponseUri.AbsoluteUri } catch { $final = $url }
    } catch {
        # fallback to curl.exe to get status and effective URL (read-only)
        try {
            $curlOut = & curl.exe -s -o NUL -w "%{http_code}|%{url_effective}" "$url"
            if ($curlOut) {
                $parts = $curlOut -split '\|',2
                $status = $parts[0]
                if ($parts.Count -ge 2) { $final = $parts[1] }
            }
        } catch { }
    }
    $text = ($l.innerText -replace '"','""' -replace '[\r\n]+',' ')
    $outLines += "`"$url`",`"$status`",`"$final`",`"$text`",`"homepage`""
}
$outLines -join "`n" | Out-File -FilePath c:\Users\annawa\source\repos\QA-Documentation\link_report.csv -Encoding utf8
Write-Output "Wrote link_report.csv with $($outLines.Count - 1) entries."