#include <stdint.h>
#include <stddef.h>
// Register access must be exactly one 32-bit transaction. Generic memcpy used
// by Python mmap slices may use overlapping stores and duplicate a command.
uint32_t hybrid_read32(void *base, uint32_t offset) {
    __asm__ volatile("dsb sy" ::: "memory");
    uint32_t value=*(volatile uint32_t *)((uint8_t *)base+offset);
    __asm__ volatile("dsb sy" ::: "memory");
    return value;
}
void hybrid_write32(void *base, uint32_t offset, uint32_t value) {
    *(volatile uint32_t *)((uint8_t *)base+offset)=value;
    __asm__ volatile("dsb sy" ::: "memory");
}
