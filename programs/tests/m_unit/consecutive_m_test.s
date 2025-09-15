.section .text
.global _start
_start:
    li   x1, -123
    li   x2, 345
    mul     x3, x1, x2       # low                                        x3 = -42435
    mulh    x4, x1, x2       # high signed                                x4 = -1
    mulhu   x5, x1, x2       # high unsigned                              x5 = 344
    div     x6, x1, x2       # =0 (|num|<|den|)                           x6 = 0
    rem     x7, x1, x2       # =-123456789                                x7 = -123
    li      x8, -2147483648
    li      x9, -1
    div     x10, x8, x9      # overflow -> spec says =INT_MIN             x10 = -2147483648
    rem     x11, x8, x9      # =0                                         x11 = 0
    div     x12, x1, x0      # divide by zero -> spec: -1                 x12 = -1
    rem     x13, x1, x0      # remainder undefined (but many cores= x1)   x13 = -123
done: j done
