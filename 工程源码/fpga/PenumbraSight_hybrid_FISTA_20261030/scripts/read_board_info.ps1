$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$port=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$port.DtrEnable=$false;$port.RtsEnable=$false;$port.ReadTimeout=500;$port.WriteTimeout=1000
$port.NewLine="`r"
try {
 $port.Open()
 $port.Write("`r")
 Start-Sleep -Milliseconds 500
 $initial=$port.ReadExisting()
 $probe=@'
printf '\nHYBRID_BOARD_INFO_BEGIN\n'; uname -a; cat /sys/devices/system/cpu/online; cat /proc/cmdline; ls -ld /lib/modules/*/build /usr/src/* 2>/dev/null; ls /dev/*dma* /dev/dri/* /sys/class/u-dma-buf/* 2>/dev/null; command -v gcc; command -v python3; printf '\nHYBRID_BOARD_INFO_END\n'
'@
 $port.WriteLine($probe)
 $answer=$initial
 $deadline=[DateTime]::UtcNow.AddSeconds(6)
 while([DateTime]::UtcNow -lt $deadline){
  Start-Sleep -Milliseconds 200
  $answer+=$port.ReadExisting()
  if($answer -match "HYBRID_BOARD_INFO_END\r?\n"){break}
 }
 [IO.File]::WriteAllText((Join-Path $root 'reports\board_readonly_info.txt'),$answer,[Text.UTF8Encoding]::new($false))
 $answer
} finally { if($port.IsOpen){$port.Close()};$port.Dispose() }
