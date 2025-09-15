    .section .text
    .globl _start

_start:
    # Input values
    li x1, 7          # a
    li x2, 13         # b
    li x3, 20         # m

    # Initialize result = 1
    li x4, 1          # result
    add x5, x2, x0    # copy exponent to x5 (exp)

modexp_loop:
    # Check if exponent == 0
    beq x5, x0, modexp_done

    # If exponent % 2 == 1, multiply result by a
    andi x6, x5, 1
    beq x6, x0, skip_mult

    # result = (result * a) % m
    mul x4, x4, x1
    rem x4, x4, x3

skip_mult:
    # a = (a * a) % m
    mul x1, x1, x1
    rem x1, x1, x3

    # exp = exp >> 1
    srli x5, x5, 1   # logical shift right
    j modexp_loop

modexp_done:
    add x7, x0, x4 # Final result in x7
end: 
    j end
