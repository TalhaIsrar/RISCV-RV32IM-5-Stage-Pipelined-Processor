.section .text
.global _start
_start:
    li   x1, 0x7FFFFFFF      # INT_MAX
    addi x2, x1, 1           # expect 0x80000000 (wrap)
    li   x3, -1
    slt  x4, x3, x0          # signed: -1 < 0 => 1
    sltu x5, x3, x0          # unsigned: 0xFFFFFFFF < 0? => 0
    sll  x6, x2, 31          # shift-left with large amount (only lower 5 bits count)
    sra  x7, x3, 31          # -1 >> 31 = 0xFFFFFFFF
done: j done
