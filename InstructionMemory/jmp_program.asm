    addi x3, x0, 5
    addi x4, x0, 7

    jal x1, add_nums
    
    addi x7, x0, 0xF
    addi x8, x0, 0xE

loop:
    jal x0, loop

add_nums:
    add x6, x3, x4
    jalr x0, x1, 0