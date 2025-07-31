    addi x1, x0, 5       # x1 = 5
    addi x2, x0, 10      # x2 = 10
    add  x3, x1, x2      # x3 = 15
    sub  x4, x2, x1      # x4 = 5

    beq  x1, x4, label_beq   # taken (5==5)
    addi x5, x0, 0           # skipped if branch taken
label_beq:
    addi x5, x0, 1           # x5 = 1

    bne  x1, x2, label_bne   # taken (5!=10)
    addi x6, x0, 0
label_bne:
    addi x6, x0, 1           # x6 = 1

    blt  x1, x2, label_blt   # taken (5<10 signed)
    addi x7, x0, 0
label_blt:
    addi x7, x0, 1           # x7 = 1


    addi x8, x0, 0
    beq  x0, x1, bltu_end    # always false, skip next
    addi x8, x0, 1           # skipped
bltu_end:

    bge  x2, x1, label_bge   # taken (10>=5 signed)
    addi x9, x0, 0
label_bge:
    addi x9, x0, 1           # x9 = 1

   
    addi x10, x0, 0
    beq  x0, x1, bgeu_end    # always false, skip next
    addi x10, x0, 1          # skipped
bgeu_end:

    slt  x11, x1, x2         # x11 = 1 (5 < 10)
    sltu x12, x2, x1         # x12 = 0 (10 < 5 unsigned?)

