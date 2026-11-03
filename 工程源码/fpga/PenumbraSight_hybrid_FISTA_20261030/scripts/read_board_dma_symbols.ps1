$ErrorActionPreference='Stop';$root=Split-Path -Parent $PSScriptRoot
$p=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$p.DtrEnable=$false;$p.RtsEnable=$false;$p.NewLine="`r"
try{$p.Open();$p.Write("`r");Start-Sleep -Milliseconds 200;$s=$p.ReadExisting()
$cmd=@'
printf '\nHYBRID_DMA_SYMBOLS_BEGIN\n'; strings /lib/modules/5.4.0/extra/dmaproxy/dmaproxy.ko | grep -i -E 'ioctl|mmap|alloc|dma_|phys|\.c|cmd|size' | head -60; sed -n '124,140p' /root/nlos_tools/show_fpga_rgb.py; printf '\nHYBRID_DMA_SYMBOLS_END\n'
'@
$p.WriteLine($cmd);$end=[DateTime]::UtcNow.AddSeconds(6)
while([DateTime]::UtcNow -lt $end){Start-Sleep -Milliseconds 200;$s+=$p.ReadExisting();if($s -match "HYBRID_DMA_SYMBOLS_END\r?\n"){break}}
[IO.File]::WriteAllText((Join-Path $root 'reports\board_readonly_dma_symbols.txt'),$s,[Text.UTF8Encoding]::new($false));$s
}finally{if($p.IsOpen){$p.Close()};$p.Dispose()}
