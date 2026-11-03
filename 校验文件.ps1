$ErrorActionPreference='Stop'
$packageRoot=$PSScriptRoot
$entries=Get-Content -LiteralPath (Join-Path $packageRoot '文件校验清单.json') -Raw -Encoding UTF8 | ConvertFrom-Json
foreach($entry in $entries){
 $file=Join-Path $packageRoot $entry.path
 if(!(Test-Path -LiteralPath $file)){throw "Missing: $file"}
 if((Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.sha256){throw "Hash differs: $file"}
}
Write-Output ("PASS: "+$entries.Count+" original files verified; no hardware accessed.")
