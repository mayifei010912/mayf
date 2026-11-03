param([switch]$Full)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot;$bin='F:\Xilinx\Vivado\2020.2\bin'
$tag=if($Full){'full'}else{'small'};$work=Join-Path $root "build\sim_$tag"
New-Item -ItemType Directory -Force -Path $work | Out-Null
$env:TEMP=Join-Path $root 'build\temp';$env:TMP=$env:TEMP
New-Item -ItemType Directory -Force -Path $env:TEMP | Out-Null
Push-Location $work
try {
 $src=@(Get-ChildItem -LiteralPath "$root\rtl" -Filter '*.v' | ForEach-Object FullName)
 $src+="$root\sim\tb_hybrid_axil.sv"
 $opts=@('-sv');if(-not $Full){$opts+=@('-d','SMALL')};$opts+=$src
 & "$bin\xvlog.bat" @opts *> "$root\reports\xvlog_$tag.log";if($LASTEXITCODE -ne 0){throw 'xvlog failed'}
 & "$bin\xelab.bat" tb_hybrid_axil -s "hybrid_$tag" *> "$root\reports\xelab_$tag.log";if($LASTEXITCODE -ne 0){throw 'xelab failed'}
 & "$bin\xsim.bat" "hybrid_$tag" -runall -log "$root\reports\xsim_$tag.log" *> "$root\reports\xsim_console_$tag.log";if($LASTEXITCODE -ne 0){throw 'xsim failed'}
 $log=Get-Content -LiteralPath "$root\reports\xsim_$tag.log" -Raw
 if($log -notmatch '\[PASS HYBRID AXIL\]' -or $log -match 'Fatal:|cannot be opened'){throw 'No valid simulation PASS'}
 Get-Content -LiteralPath "$root\reports\xsim_$tag.log" -Tail 12
}finally{Pop-Location}
