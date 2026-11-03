// DMA-coherent backing store for G. Build against the BOARD's exact kernel.
// This is a buffer provider, not an FPGA programming or reset driver.
// Requires direct DMA addressing on the PS HP0 path (no unmatched SMMU mapping).
#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/dma-mapping.h>
#include <linux/mm.h>
#include <linux/uaccess.h>
#include <linux/atomic.h>
#include <linux/ioctl.h>

struct gram_info { __u64 dma_address; __u64 allocated_bytes; };
#define GRAM_GET_INFO _IOR('H', 1, struct gram_info)
#define GRAM_COMMIT _IO('H', 2)
static unsigned long buffer_bytes=16UL*1024*1024;
module_param(buffer_bytes,ulong,0444);
static void *cpu_buffer;
static dma_addr_t dma_buffer;
static size_t allocated;
static u64 gram_mask=DMA_BIT_MASK(32);
static atomic_t opened=ATOMIC_INIT(0);
static bool ready;
static struct miscdevice gram_device;

static int gram_open(struct inode *inode,struct file *file)
{
 if(!smp_load_acquire(&ready))return -ENODEV;
 if(atomic_cmpxchg(&opened,0,1))return -EBUSY;
 return nonseekable_open(inode,file);
}
static int gram_release(struct inode *inode,struct file *file)
{ atomic_set(&opened,0);return 0; }
static long gram_ioctl(struct file *file,unsigned int cmd,unsigned long arg)
{
 struct gram_info info;
 switch(cmd){
 case GRAM_GET_INFO:
  info.dma_address=dma_buffer;info.allocated_bytes=allocated;
  return copy_to_user((void __user *)arg,&info,sizeof(info))?-EFAULT:0;
 case GRAM_COMMIT:
  dma_wmb();return 0;
 default:return -ENOTTY;
 }
}
static int gram_mmap(struct file *file,struct vm_area_struct *vma)
{
 if(vma->vm_pgoff!=0 || vma->vm_end-vma->vm_start>allocated)return -EINVAL;
 return dma_mmap_coherent(gram_device.this_device,vma,cpu_buffer,dma_buffer,allocated);
}
static const struct file_operations gram_fops={
 .owner=THIS_MODULE,.open=gram_open,.release=gram_release,.unlocked_ioctl=gram_ioctl,
 .mmap=gram_mmap,.llseek=no_llseek
};
static struct miscdevice gram_device={
 .minor=MISC_DYNAMIC_MINOR,.name="penumbra_gram",.fops=&gram_fops,.mode=0600
};
static int __init gram_init(void)
{
 int ret;
 if(buffer_bytes<8719488UL || buffer_bytes>64UL*1024*1024)return -EINVAL;
 allocated=PAGE_ALIGN(buffer_bytes);
 ret=misc_register(&gram_device);if(ret)return ret;
 gram_device.this_device->dma_mask=&gram_mask;
 gram_device.this_device->coherent_dma_mask=DMA_BIT_MASK(32);
 ret=dma_set_mask_and_coherent(gram_device.this_device,DMA_BIT_MASK(32));
 if(ret)goto failed;
 cpu_buffer=dma_alloc_coherent(gram_device.this_device,allocated,&dma_buffer,GFP_KERNEL);
 if(!cpu_buffer){ret=-ENOMEM;goto failed;}
 if((u64)dma_buffer+allocated>0x100000000ULL){ret=-ERANGE;goto free_buffer;}
 memset(cpu_buffer,0,allocated);
 smp_store_release(&ready,true);
 pr_info("penumbra_gram: %zu bytes DMA %pad (no FPGA access performed)\n",allocated,&dma_buffer);
 return 0;
free_buffer:
 dma_free_coherent(gram_device.this_device,allocated,cpu_buffer,dma_buffer);
failed:
 misc_deregister(&gram_device);return ret;
}
static void __exit gram_exit(void)
{
 // Open files and their file-backed VMAs hold THIS_MODULE and prevent unload.
 dma_free_coherent(gram_device.this_device,allocated,cpu_buffer,dma_buffer);
 misc_deregister(&gram_device);
}
module_init(gram_init);module_exit(gram_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("PenumbraSight fixed-G coherent DMA buffer; static FPGA reproduction");
