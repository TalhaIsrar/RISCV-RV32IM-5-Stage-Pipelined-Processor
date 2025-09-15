    .section .text
    .globl _start

_start:
    # Numbers to reduce: 84, 126, 210, 462, 924
    li x5, 84
    li x6, 126
    li x7, 210
    li x8, 462
    li x9, 924

    # Step 1: gcd(x5, x6)
    add x10, x5, x0   # a = 84
    add x11, x6, x0   # b = 126

gcd_loop1:
    beq x11, x0, gcd_done1
    rem x12, x10, x11
    add x10, x11, x0
    add x11, x12, x0
    jal x0, gcd_loop1
gcd_done1:
    add x13, x10, x0   # gcd12 = result

    # Step 2: gcd(gcd12, x7)
    add x10, x13, x0
    add x11, x7, x0

gcd_loop2:
    beq x11, x0, gcd_done2
    rem x12, x10, x11
    add x10, x11, x0
    add x11, x12, x0
    jal x0, gcd_loop2
gcd_done2:
    add x14, x10, x0   # gcd123

    # Step 3: gcd(gcd123, x8)
    add x10, x14, x0
    add x11, x8, x0

gcd_loop3:
    beq x11, x0, gcd_done3
    rem x12, x10, x11
    add x10, x11, x0
    add x11, x12, x0
    jal x0, gcd_loop3
gcd_done3:
    add x15, x10, x0   # gcd1234

    # Step 4: gcd(gcd1234, x9)
    add x10, x15, x0
    add x11, x9, x0

gcd_loop4:
    beq x11, x0, gcd_done4
    rem x12, x10, x11
    add x10, x11, x0
    add x11, x12, x0
    jal x0, gcd_loop4
gcd_done4:
    add x16, x10, x0   # Final GCD

done:
    # Final result is in x16
    jal x0, done
