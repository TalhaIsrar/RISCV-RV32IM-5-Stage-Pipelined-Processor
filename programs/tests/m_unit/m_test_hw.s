.section .text
.globl _start

_start:    
    # Multiply largest 32-bit numbers
    li x1, 0xFFFFFFFF   # operand 1 (4294967295)
    li x2, 0xFFFFFFFF   # operand 2 (4294967295)
    mul x3, x1, x2      # result in x3
end:
    j end
