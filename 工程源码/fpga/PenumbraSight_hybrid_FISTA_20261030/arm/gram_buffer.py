"""Keep a driver-owned, DMA-coherent G allocation open during a hardware job."""
import fcntl,mmap,os,struct,pathlib,hashlib

class GramBuffer:
    def __init__(self,path,device='/dev/penumbra_gram',expected_sha256=None):
        data=pathlib.Path(path).read_bytes()
        if expected_sha256 and hashlib.sha256(data).hexdigest()!=expected_sha256:
            raise ValueError('G file hash mismatch')
        self.fd=os.open(device,os.O_RDWR|os.O_SYNC)
        try:
            info=bytearray(16);fcntl.ioctl(self.fd,0x80104801,info,True)
            self.address,self.size=struct.unpack('<QQ',info)
            if self.size<len(data) or self.address%8 or self.address+self.size>2**32:
                raise ValueError('DMA allocation too small or outside 32-bit address space')
            self.mm=mmap.mmap(self.fd,self.size,flags=mmap.MAP_SHARED,prot=mmap.PROT_READ|mmap.PROT_WRITE)
            self.mm[:len(data)]=data
            if self.mm[:len(data)]!=data:raise RuntimeError('DMA buffer readback differs')
            fcntl.ioctl(self.fd,0x4802) # dma_wmb() before issuing device commands
        except Exception:
            if hasattr(self,'mm'):self.mm.close()
            os.close(self.fd);raise
    def close(self):self.mm.close();os.close(self.fd)
