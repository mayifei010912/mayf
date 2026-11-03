$ErrorActionPreference='Stop';$root=Split-Path -Parent $PSScriptRoot
$p=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$p.DtrEnable=$false;$p.RtsEnable=$false;$p.NewLine="`r"
try{$p.Open();$p.Write("`r");Start-Sleep -Milliseconds 200;$s=$p.ReadExisting()
$cmd=@'
printf '\nHYBRID_DMA_API_BEGIN\n'; grep -n -i -E 'dma|ioctl|phys|\.so' /root/nlos_tools/drm_rgb.py /root/nlos_tools/show_fpga_rgb.py /root/nlos_tools/camera_session.py; modinfo dmaproxy 2>/dev/null; printf '\nHYBRID_DMA_API_END\n'
'@
$p.WriteLine($cmd);$end=[DateTime]::UtcNow.AddSeconds(8)
while([DateTime]::UtcNow -lt $end){Start-Sleep -Milliseconds 200;$s+=$p.ReadExisting();if($s -match "HYBRID_DMA_API_END\r?\n"){break}}
[IO.File]::WriteAllText((Join-Path $root 'reports\board_readonly_dma_api.txt'),$s,[Text.UTF8Encoding]::new($false));$s
}finally{if($p.IsOpen){$p.Close()};$p.Dispose()}
