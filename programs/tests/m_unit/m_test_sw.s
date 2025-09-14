.section .text
.globl _start

_start:        
    # Multiply x1 * x2 using shift-add, all 32 bits
    li x1, 0xFFFFFFFF   # operand 1
    li x2, 0xFFFFFFFF   # operand 2
    li x3, 0            # result
    li x5, 32           # loop counter

mul_loop:
    andi x4, x2, 1      # check LSB of x2
    beq x4, x0, skip_add
    add x3, x3, x1      # add x1 if bit is 1

skip_add:
    sll x1, x1, 1       # shift operand1 left
    srl x2, x2, 1       # shift operand2 right
    addi x5, x5, -1
    bnez x5, mul_loop

end:
    j end
