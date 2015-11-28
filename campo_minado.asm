j main

paint_pixel:        # paint_pixel(x,y,rgb)
  lw $t2, 4($sp)          # rgb
  lw $t1, 8($sp)          # y
  lw $t0, 12($sp)         # x
  mul $t1, $t1, 512       # y' = 4*(y*512/4)
  sll $t0, $t0, 2         # x' = 4*x
  add $t3, $t1, $t0       # dslc = x' + y'
  sw $t2, 0x10010000($t3) # *(addr + dslc) = rgb
  addi $sp, $sp, 12
  jr $ra
 
paint_hline:         # paint_hline(x,y,len,rgb)
  lw $t3, 4($sp)          # rgb  
  lw $t2, 8($sp)          # len
  lw $t1, 12($sp)         # y
  lw $t0, 16($sp)         # x
  sll $t2, $t2, 2         # end = 4*len 
  mul $t1, $t1, 2048      # y' = 4*(y*512)
  sll $t0, $t0, 2         # x' = 4*x
  while_0:
    beq $t0, $t2, end_0     # while (x' != end) {
    add $t4, $t1, $t0       #   dslc = x' + y'
    sw $t3, 0x10010000($t4) #   *(addr + dslc) = rgb
    addi $t0, $t0, 4        #   x = x + 4
    j while_0               # }
  end_0:
  addi $sp, $sp, 16
  jr $ra

main:
  addi $t0, $zero, 10
  addi $t1, $zero, 10
  addi $t2, $zero, 128
  addi $t3, $zero, 0xFFFFFFFF
  sw $t0, 0($sp)
  sw $t1, -4($sp)
  sw $t2, -8($sp)
  sw $t3, -12($sp)
  addi $sp, $sp, -16
  jal paint_hline 
