$ErrorActionPreference='Stop';$root=Split-Path -Parent $PSScriptRoot
$p=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$p.DtrEnable=$false;$p.RtsEnable=$false;$p.NewLine="`r"
try{$p.Open();$p.Write("`r");Start-Sleep -Milliseconds 200;$s=$p.ReadExisting()
$cmd=@'
printf '\nHYBRID_CMA_BEGIN\n'; python3 -c 'import os,fcntl,struct,mmap,ctypes,json; f=os.open("/dev/dri/card0",os.O_RDWR); b=bytearray(struct.pack("<6IQ",2048,2048,32,0,0,0,0)); fcntl.ioctl(f,0xc02064b2,b,True); a=struct.unpack("<6IQ",b); h,sz=a[4],a[6]; q=bytearray(struct.pack("<IIQ",h,0,0)); fcntl.ioctl(f,0xc01064b3,q,True); m=mmap.mmap(f,sz,offset=struct.unpack("<IIQ",q)[2]); m[:]=b"\0"*sz; va=ctypes.addressof(ctypes.c_char.from_buffer(m)); pf=os.open("/proc/self/pagemap",os.O_RDONLY); es=struct.unpack("<"+"Q"*(sz//4096),os.pread(pf,sz//4096*8,va//4096*8)); ps=[x&((1<<55)-1) for x in es]; print(json.dumps(dict(size=sz,present=all(x>>63 for x in es),nonzero_pfn=all(ps),contiguous=all(x==ps[0]+i for i,x in enumerate(ps)),physical_start=hex(ps[0]*4096)))); m.close(); fcntl.ioctl(f,0xc00464b4,struct.pack("<I",h)); os.close(pf); os.close(f)'; readlink /sys/class/drm/card0/device/driver; find /sys/devices/platform/amba_pl@0 -maxdepth 3 -name iommu_group 2>/dev/null; printf '\nHYBRID_CMA_END\n'
'@
$p.WriteLine($cmd);$end=[DateTime]::UtcNow.AddSeconds(10)
while([DateTime]::UtcNow -lt $end){Start-Sleep -Milliseconds 200;$s+=$p.ReadExisting();if($s -match "HYBRID_CMA_END\r?\n"){break}}
[IO.File]::WriteAllText((Join-Path $root 'reports\board_cma_allocation_probe.txt'),$s,[Text.UTF8Encoding]::new($false));$s
}finally{if($p.IsOpen){$p.Close()};$p.Dispose()}
