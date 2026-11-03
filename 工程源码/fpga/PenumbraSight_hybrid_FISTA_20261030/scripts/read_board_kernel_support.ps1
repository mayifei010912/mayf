$ErrorActionPreference='Stop';$root=Split-Path -Parent $PSScriptRoot
$p=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$p.DtrEnable=$false;$p.RtsEnable=$false;$p.NewLine="`r"
try{$p.Open();$p.Write("`r");Start-Sleep -Milliseconds 200;$s=$p.ReadExisting()
$cmd=@'
printf '\nHYBRID_KERNEL_SUPPORT_BEGIN\n'; ls -1 /usr/src/debug; ls /sys/kernel/debug/dri/0 /sys/kernel/debug/dri/1 2>/dev/null; ls /sys/kernel/debug/cma /dev/uio* /dev/*mem* 2>/dev/null; strings /lib/modules/5.4.0/extra/dmaproxy/dmaproxy.ko | grep -E 'copy.*user|\.c|vermagic'; find /usr/src/debug -iname '*dmaproxy*' -o -iname '*dma-proxy*'; printf '\nHYBRID_KERNEL_SUPPORT_END\n'
'@
$p.WriteLine($cmd);$end=[DateTime]::UtcNow.AddSeconds(8)
while([DateTime]::UtcNow -lt $end){Start-Sleep -Milliseconds 200;$s+=$p.ReadExisting();if($s -match "HYBRID_KERNEL_SUPPORT_END\r?\n"){break}}
[IO.File]::WriteAllText((Join-Path $root 'reports\board_kernel_support.txt'),$s,[Text.UTF8Encoding]::new($false));$s
}finally{if($p.IsOpen){$p.Close()};$p.Dispose()}
