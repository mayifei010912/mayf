param([switch]$Full,[switch]$Unit,[switch]$Streaming,[switch]$Queued)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$bin='F:\Xilinx\Vivado\2020.2\bin'
$tag=if($Unit){'gpipe'}elseif($Full){'full'}else{'small'}
if($Streaming){$tag+='_stream'};if($Queued){$tag+='_queued'}
$work=Join-Path $root "build\sim_$tag"
New-Item -ItemType Directory -Force -Path $work | Out-Null
$env:TEMP=Join-Path $root 'build\temp';$env:TMP=$env:TEMP
Push-Location $work
try {
 $src=@(Get-ChildItem -LiteralPath "$root\rtl" -Filter '*.v' | ForEach-Object FullName)
 $test=if($Unit){'tb_gpipe'}else{'tb_hybrid_axil'}
 $testFile=if($Queued){'tb_hybrid_queued'}elseif($Streaming){'tb_hybrid_stream'}else{$test}
 $src+="$root\sim\$testFile.sv"
 $opts=@('-sv');if(-not $Full -and -not $Unit){$opts+=@('-d','SMALL')};$opts+=$src
 & "$bin\xvlog.bat" @opts *> "$root\reports\xvlog_$tag.log"
 if($LASTEXITCODE -ne 0){throw 'xvlog failed'}
 & "$bin\xelab.bat" $test -s "speed_$tag" *> "$root\reports\xelab_$tag.log"
 if($LASTEXITCODE -ne 0){throw 'xelab failed'}
 & "$bin\xsim.bat" "speed_$tag" -runall -log "$root\reports\xsim_$tag.log" *> "$root\reports\xsim_console_$tag.log"
 if($LASTEXITCODE -ne 0){throw 'xsim failed'}
 $log=Get-Content -LiteralPath "$root\reports\xsim_$tag.log" -Raw
 $pass=if($Unit){'PASS GPIPE:'}else{'\[PASS HYBRID AXIL\]'}
 if($log -notmatch $pass -or $log -match 'Fatal:|cannot be opened'){throw 'No valid simulation PASS'}
 Get-Content -LiteralPath "$root\reports\xsim_$tag.log" -Tail 10
}finally{Pop-Location}
