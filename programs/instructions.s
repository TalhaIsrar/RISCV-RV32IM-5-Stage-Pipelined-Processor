.section .text
.global _start
_start:
    li   x1, -123
    li   x2, 345
    mul     x3, x1, x2       # low
    mulh    x4, x1, x2       # high signed
    mulhu   x5, x1, x2       # high unsigned
    div     x6, x1, x2       # =0 (|num|<|den|)
    rem     x7, x1, x2       # =-123456789
    li      x8, -2147483648
    li      x9, -1
    div     x10, x8, x9      # overflow -> spec says =INT_MIN
    rem     x11, x8, x9      # =0
    div     x12, x1, x0      # divide by zero -> spec: -1
    rem     x13, x1, x0      # remainder undefined (but many cores= x1)
done: j done
