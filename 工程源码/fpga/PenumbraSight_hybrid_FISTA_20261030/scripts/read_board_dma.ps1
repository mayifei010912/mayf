$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$port=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$port.DtrEnable=$false;$port.RtsEnable=$false;$port.NewLine="`r"
try {
 $port.Open();$port.Write("`r");Start-Sleep -Milliseconds 300;$answer=$port.ReadExisting()
 $probe=@'
printf '\nHYBRID_DMA_INFO_BEGIN\n'; lsmod; ls -l /sys/class/misc/dmaproxy /sys/class/dmaproxy /dev/dmaproxy 2>/dev/null; grep -E 'Cma|MemTotal|MemAvailable' /proc/meminfo; find /lib/modules -iname '*proxy*'; ls -1 /root/nlos_tools; printf '\nHYBRID_DMA_INFO_END\n'
'@
 $port.WriteLine($probe);$deadline=[DateTime]::UtcNow.AddSeconds(8)
 while([DateTime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 200;$answer+=$port.ReadExisting();if($answer -match "HYBRID_DMA_INFO_END\r?\n"){break}}
 [IO.File]::WriteAllText((Join-Path $root 'reports\board_readonly_dma.txt'),$answer,[Text.UTF8Encoding]::new($false));$answer
} finally {if($port.IsOpen){$port.Close()};$port.Dispose()}
