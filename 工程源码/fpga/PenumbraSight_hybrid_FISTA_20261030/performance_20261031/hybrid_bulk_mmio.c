#include <stdint.h>
#include <stddef.h>
/* Same volatile 32-bit accesses and barriers as the validated baseline.
 * Never memcpy MMIO: every command must be written exactly once. */
static inline uint32_t rd(void *base, uint32_t off) {
    __asm__ volatile("dsb sy" ::: "memory");
    uint32_t v=*(volatile uint32_t *)((uint8_t *)base+off);
    __asm__ volatile("dsb sy" ::: "memory");
    return v;
}
static inline void wr(void *base, uint32_t off, uint32_t v) {
    *(volatile uint32_t *)((uint8_t *)base+off)=v;
    __asm__ volatile("dsb sy" ::: "memory");
}
int hybrid_bulk_load(void *base,const int32_t *x,uint32_t n) {
    if(!base || !x || n!=1044) return -1;
    wr(base,4,1);
    for(uint32_t i=0;i<n;i++) {
        wr(base,0x0c,i);wr(base,0x10,(uint32_t)x[i]);wr(base,4,2);
    }
    return rd(base,0x38)==n ? 0 : -2;
}
int hybrid_bulk_read_gx(void *base,uint32_t *out,uint32_t n) {
    if(!base || !out || n!=1044) return -1;
    for(uint32_t i=0;i<n;i++) {
        wr(base,0x0c,i);
        for(uint32_t j=0;j<4;j++) out[4*i+j]=rd(base,0x28+4*j);
    }
    return 0;
}
int hybrid_bulk_read_tv(void *base,int32_t *out,uint32_t n) {
    if(!base || !out || n!=1044) return -1;
    for(uint32_t i=0;i<n;i++) {wr(base,0x0c,i);out[i]=(int32_t)rd(base,0x28);}
    return 0;
}
