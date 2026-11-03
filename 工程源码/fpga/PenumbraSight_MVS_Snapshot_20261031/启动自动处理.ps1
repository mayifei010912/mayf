$ErrorActionPreference='Stop'
$programRoot='F:\fpga\PenumbraSight_MVS_Snapshot_20261031'
Set-Location -LiteralPath $programRoot
$env:PYTHONUTF8='1'
$pythonw=Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\pythonw.exe'
Start-Process -FilePath $pythonw -ArgumentList @('"'+(Join-Path $programRoot 'auto_gui.py')+'"') -WorkingDirectory $programRoot -WindowStyle Normal
