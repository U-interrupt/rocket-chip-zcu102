#define DRAM_BASE 0x800000000

.section .text.start, "ax", @progbits
.globl _start
_start:
  la a0, _start
  csrw mtvec, a0
  // csrwi 0x7c1, 0 // disable chicken bits
  // loop count
  li s0, 10 
  // led gpio value
  li x2, 0x3f
  // gpio addr
  li x1, 0x60010000
outer_loop_begin:
  beqz s0, outer_loop_end
  sd x2, 0x0(x1)
  addi s0, s0, -1
  neg x2, x2
  li s3, 1000000
inner_loop_begin:
  beqz s3, inner_loop_end
  addi s3, s3, -1
  j inner_loop_begin
inner_loop_end:
  j outer_loop_begin
outer_loop_end:
  
  csrr a0, mcause
  li s3, 10000000
  sd a0, 0(x1)
error_loop_begin:
  beqz s3, error_loop_end
  addi s3, s3, -1
  j inner_loop_begin
error_loop_end:  

  // Write DDR
  li x1, 0x810000000
  li x2, 0x12345678
  sd x2, 0x0(x1)

  // Read DDR
  li x1, 0x820000000
  li x3, 0x60010000
  ld x2, 0x0(x1)
  sd x2, 0x0(x3)


  // Jump to entry
  li s0, DRAM_BASE
  csrr a0, mhartid
  la a1, _dtb
  jr s0

.section .text.hang, "ax", @progbits
.globl _hang
_hang:
  // csrwi 0x7c1, 0 // disable chicken bits
  csrr a0, mhartid
  la a1, _dtb
  csrwi mie, 0
1:
  wfi
  j 1b

.section .rodata.dtb, "a", @progbits
.globl _dtb
.align 5, 0
_dtb:
.ascii "DTB goes here"