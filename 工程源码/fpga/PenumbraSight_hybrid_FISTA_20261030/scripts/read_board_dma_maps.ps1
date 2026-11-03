$ErrorActionPreference='Stop';$root=Split-Path -Parent $PSScriptRoot
$p=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$p.DtrEnable=$false;$p.RtsEnable=$false;$p.NewLine="`r"
try{$p.Open();$p.Write("`r");Start-Sleep -Milliseconds 200;$s=$p.ReadExisting()
$cmd=@'
printf '\nHYBRID_DMA_MAPS_BEGIN\n'; cat /sys/kernel/debug/dri/1/framebuffer; for d in /sys/class/uio/uio*; do echo "$d"; cat "$d/name" "$d/maps/map0/addr" "$d/maps/map0/size"; done; printf '\nHYBRID_DMA_MAPS_END\n'
'@
$p.WriteLine($cmd);$end=[DateTime]::UtcNow.AddSeconds(6)
while([DateTime]::UtcNow -lt $end){Start-Sleep -Milliseconds 200;$s+=$p.ReadExisting();if($s -match "HYBRID_DMA_MAPS_END\r?\n"){break}}
[IO.File]::WriteAllText((Join-Path $root 'reports\board_readonly_dma_maps.txt'),$s,[Text.UTF8Encoding]::new($false));$s
}finally{if($p.IsOpen){$p.Close()};$p.Dispose()}
