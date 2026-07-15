#<
#Read-only link checker with GET fallback.
#Behavior:
# - Try HEAD for each link.
# - If HEAD fails (HEAD_ERR/405/ERR/empty), perform a GET as a fallback (still read-only).
# - Append each result immediately to the CSV at repository root (..\link_report.csv).
# - This script only issues HTTP GET/HEAD requests and does not submit forms or modify remote sites; GETs are standard read-only requests but note servers may log requests.
#>

$base = 'http://familyadventures.qa.pgl.co.uk/'
try { $homePage = Invoke-WebRequest -Uri $base -UseBasicParsing -ErrorAction Stop } catch { Write-Error "Failed to fetch homepage: $_"; exit 1 }
Write-Output "Fetched homepage. Response code: $($homePage.BaseResponse.StatusCode.Value__)"
Write-Output "Anchor elements on page: $($homePage.Links.Count)"

$links = @()
foreach($a in $homePage.Links) {
	$href = $a.href
	if([string]::IsNullOrWhiteSpace($href)) { continue }
	if($href -match '^(mailto:|tel:|javascript:|#)') { continue }
	try {
		$uri = if([uri]::IsWellFormedUriString($href,[uriKind]::Absolute)) { [uri]$href } else { [uri]::new($href,$base) }
	} catch { continue }
	$links += [pscustomobject]@{Url=$uri.AbsoluteUri; Text = ($a.innerText -replace '\s+',' ').Trim()}
}

$csvPath = Join-Path -Path (Resolve-Path ..) -ChildPath 'link_report.csv'
# Write header (overwrite if exists)
'"URL","Status","FinalURL","LinkText","Page"' | Out-File -FilePath $csvPath -Encoding UTF8

$count = 0
foreach($l in $links | Sort-Object Url -Unique) {
	$count++
	$url = $l.Url
	$status = ''
	$final = $url

	# Try HEAD first
	try {
		$resp = Invoke-WebRequest -Uri $url -Method Head -MaximumRedirection 10 -UseBasicParsing -ErrorAction Stop
		$status = $resp.StatusCode.Value__
		$final = $resp.BaseResponse.ResponseUri.AbsoluteUri
		Write-Output "[$count/$($links.Count)] HEAD $url -> $status"
	} catch {
		$err = $_.Exception.Response
		if($err -ne $null) {
			try { $status = $err.StatusCode.value__ } catch { $status = 'HEAD_ERR' }
			try { $final = $err.ResponseUri.AbsoluteUri } catch {}
		} else {
			$status = 'HEAD_ERR'
		}
		Write-Output "[$count/$($links.Count)] HEAD failed for $url -> $status. Falling back to GET."

		# GET fallback (read-only)
		try {
			$respGet = Invoke-WebRequest -Uri $url -Method Get -MaximumRedirection 10 -UseBasicParsing -ErrorAction Stop
			$status = $respGet.StatusCode.Value__
			$final = $respGet.BaseResponse.ResponseUri.AbsoluteUri
			Write-Output "[$count/$($links.Count)] GET $url -> $status"
		} catch {
			$err2 = $_.Exception.Response
			if($err2 -ne $null) {
				try { $status = $err2.StatusCode.value__ } catch { $status = 'GET_ERR' }
				try { $final = $err2.ResponseUri.AbsoluteUri } catch {}
			} else {
				$status = 'GET_ERR'
			}
			Write-Output "[$count/$($links.Count)] GET failed for $url -> $status"
		}
	}

	$rec = [pscustomobject]@{URL=$url; Status=$status; FinalURL=$final; LinkText=$l.Text; Page='homepage'}
	$rec | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Add-Content -Path $csvPath -Encoding UTF8
}

Write-Output "Completed: wrote $($links.Count) entries to $csvPath"

