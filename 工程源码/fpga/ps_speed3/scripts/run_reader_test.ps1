$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$bin='F:\Xilinx\Vivado\2020.2\bin'
$work=Join-Path $root 'build\reader_test'
New-Item -ItemType Directory -Force -Path $work | Out-Null
$env:TEMP=Join-Path $root 'build\temp';$env:TMP=$env:TEMP
Push-Location $work
try {
 & "$bin\xvlog.bat" -sv "$root\rtl\fixed_g_axi_reader_queued.v" "$root\sim\tb_reader_queued.sv" *> "$root\reports\xvlog_reader.log"
 if($LASTEXITCODE -ne 0){throw 'xvlog failed'}
 & "$bin\xelab.bat" tb_reader_queued -s queued *> "$root\reports\xelab_reader.log"
 if($LASTEXITCODE -ne 0){throw 'xelab failed'}
 & "$bin\xsim.bat" queued -runall -log "$root\reports\xsim_reader.log" *> "$root\reports\xsim_reader_console.log"
 if($LASTEXITCODE -ne 0){throw 'xsim failed'}
 $log=Get-Content -LiteralPath "$root\reports\xsim_reader.log" -Raw
 if($log -notmatch 'PASS QUEUED_READER:' -or $log -match 'Fatal:'){throw 'Reader test failed'}
 Get-Content -LiteralPath "$root\reports\xsim_reader.log" -Tail 8
}finally{Pop-Location}
