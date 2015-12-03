#BITMAP_START=0x10010000
#blue = 0x000000FF
#red = 0x00FF0000
#green = 0x0000FF00
#width = 256
#uma linha = 1024 em endere?os

#sumario
#paint pixel: 27
#paint_hline: 39
#paint_vline: 82
#paint_paint_dline_direita: 107
#paint_dline_esquerda: 122
#paint_square: 148
#fill_square(imcompleta): 170
#paint_one: 181
#paint_two: 230
#paint_three: 313
#paint_four: 396
#paint_five: 460
#paint_six: 564
#paint_seven: 669
#paint_eight: 714
#paint_asterisc: 816

j main

paint_pixel:        # paint_pixel(a0=x,a1=y,a2=rgb)
 	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
  
	sll $t1, $t1, 10        # y' = 4*(256*y)
	sll $t0, $t0, 2         # x' = 4*x
	add $t3, $t1, $t0       # dslc = x' + y'
	sw $t2, 0x10010000($t3) # *(addr + dslc) = rgb
	jr $ra
 
#paint_hline iterativa com paint_pixel incluida
paint_hline: 		#paint_hline(a0=x, a1=y, a2=len, a3=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
	addi $t3, $a3, 0
  
	sll $t5, $t1, 10     # y' = 4*(256*y)
	sll $t4, $t0, 2      # x' = 4*x
	add $t6, $t4, $t5    # dslc = x' + y'
  
	sll $t2, $t2, 2      # limite = limite*4
	add $t2, $t6, $t2    # limiteDeDeslocamento = dslc + limite*4

	while_0:
  		slt $t7, $t2, $t6
  		bne $t7, $zero, end_1   #if limiteDeDeslocamento < dslc : branch
  	
  		sw $t3, 0x10010000($t6)	# *(addr + dslc) = rgb
 	
 		addi $t6, $t6, 4        # dslc += 4 (+uma coluna)
 		j while_0                                                    
  	end_0:
  	jr $ra

#paint_hline:         # paint_hline(x,y,len,rgb)
#  lw $t3, 4($sp)          # rgb  
#  lw $t2, 8($sp)          # len
#  lw $t1, 12($sp)         # y
#  lw $t0, 16($sp)         # x
#  sll $t2, $t2, 2         # end = 4*len 
#  mul $t1, $t1, 512       # y' = 4*(y*256)
#  #sll $t0, $t0, 2         # x' = 4*x
#  while_0:
#    beq $t0, $t2, end_0     # while (x' != end) {
#    add $t4, $t1, $t0       #   dslc = x' + y'
#    sw $t3, 0x10010000($t4) #   *(addr + dslc) = rgb
#    addi $t0, $t0, 4        #   x = x + 4
#    j while_0               # }
#  end_0:
#  addi $sp, $sp, 16
#  jr $ra

#paint_vline iterativa com paint_pixel incluida
paint_vline: 		#paint_vline(a0=x, a1=y, a2=len, a3=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
	addi $t3, $a3, 0
  
	add $t2, $t2, $t1	#limite = len + y
	sll $t2, $t2, 10	#limiteDeDeslocamento = 4*(256*limite)
  
	sll $t5, $t1, 10	# y' = 4*(256*y)
	sll $t4, $t0, 2         # x' = 4*x
	add $t6, $t4, $t5       # dslc = x' + y'
  	
	while_1:
  		slt $t7, $t2, $t6
  		bne $t7, $zero, end_1 #if limiteDeDeslocamento < dslc : branch
  	
  		sw $t3, 0x10010000($t6) # *(addr + dslc) = rgb
 	
 		addi $t6, $t6, 1024 # dslc += 2048 (+uma linha)
 		j while_1                                                    
  	end_1:
  	jr $ra

#paint_dline_direita iterativa com paint_pixel incluida
paint_dline_direita: 		#paint_dline(a0=x, a1=y, a2=len, a3=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
	addi $t3, $a3, 0
  
	add $t2, $t2, $t1	#limite = len + y
	sll $t2, $t2, 10	#limiteDeDeslocamento = 4*(256*limite)
  
	sll $t5, $t1, 10	# y' = 4*(256*y)
	sll $t4, $t0, 2         # x' = 4*x
	add $t6, $t4, $t5       # dslc = x' + y'
  	
	while_2:
  		slt $t7, $t2, $t6
  		bne $t7, $zero, end_2 #if limiteDeDeslocamento < dslc : branch
  		#addi $s0, $t6, 4
  		sw $t3, 0x10010000($t6) # *(addr + dslc) = rgb
 	
 		addi $t6, $t6, 1028 # dslc += 2052 (+uma linha + uma coluna)
 		j while_2                                                   
  	end_2:
  	jr $ra

#paint_dline_esquerda iterativa com paint_pixel incluida
paint_dline_esquerda: 		#paint_dline(a0=x, a1=y, a2=len, a3=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
	addi $t3, $a3, 0
  
	add $t2, $t2, $t1	#limite = len + y
	sll $t2, $t2, 10	#limiteDeDeslocamento = 4*(256*limite)
  
	sll $t5, $t1, 10	  # y' = 4*(256*y)
	sll $t4, $t0, 2         # x' = 4*x
	add $t6, $t4, $t5       # dslc = x' + y'
  	
	while_3:
		slt $t7, $t2, $t6
  		bne $t7, $zero, end_3 #if limiteDeDeslocamento < dslc : branch
  		#addi $s0, $t6, 4
  		sw $t3, 0x10010000($t6) # *(addr + dslc) = rgb
 	
 		addi $t6, $t6, 1020 # dslc += 2048 (+uma linha)
 		j while_3                                                   
  	end_3:
  	jr $ra

#desenha um quadrado
paint_square:	#paint_square(a0=x, a1=y, a2=side, a3=rgb)
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal paint_vline
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal paint_hline
	add $a0, $a0, $a2
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal paint_vline
	sub $a0, $a0, $a2
	add $a1, $a1, $a2
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal paint_hline
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	jr $ra
  
fill_square:    #fill_square(a0=x, a1=y, a2=side, a3=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
	addi $t3, $a3, 0

paint_one: # paint_one($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 6
	addi $a1, $t1, 1
	addi $a2, $zero, 3
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_dline_esquerda
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 6
	addi $a1, $t1, 1
	addi $a2, $zero, 8
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
paint_two: # paint_two($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 2
	addi $a1, $t1, 2
	addi $a2, $t2, 0
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_pixel
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 3
	addi $a1, $t1, 1
	addi $a2, $zero, 4
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 8
	addi $a1, $t1, 2
	addi $a2, $zero, 6
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_dline_esquerda
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 2
	addi $a1, $t1, 8
	addi $a2, $zero, 6
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 
 paint_three: # paint_three($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 2
	addi $a1, $t1, 1
	addi $a2, $zero, 6
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 8
	addi $a1, $t1, 2
	addi $a2, $zero, 6
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 5
	addi $a1, $t1, 4
	addi $a2, $zero, 2
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 2
	addi $a1, $t1, 8
	addi $a2, $zero, 6
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
 paint_four: # paint_four($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 3
	addi $a1, $t1, 1
	addi $a2, $zero, 3
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 3
	addi $a1, $t1, 4
	addi $a2, $zero, 4
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 7
	addi $a1, $t1, 1
	addi $a2, $zero, 8
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
paint_five: # paint_five($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 3
	addi $a1, $t1, 1
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 3
	addi $a1, $t1, 2
	addi $a2, $zero, 2
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 3
	addi $a1, $t1, 4
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 8
	addi $a1, $t1, 5
	addi $a2, $zero, 3
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 3
	addi $a1, $t1, 8
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
paint_six: # paint_six($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 3
	addi $a1, $t1, 1
	addi $a2, $zero, 5
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 3
	addi $a1, $t1, 2
	addi $a2, $zero, 7
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 3
	addi $a1, $t1, 4
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 8
	addi $a1, $t1, 5
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 3
	addi $a1, $t1, 8
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
paint_seven: # paint_seven($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 3
	addi $a1, $t1, 1
	addi $a2, $zero, 5
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 8
	addi $a1, $t1, 2
	addi $a2, $zero, 7
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
paint_eight: # paint_eight($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 3
	addi $a1, $t1, 1
	addi $a2, $zero, 5
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 3
	addi $a1, $t1, 2
	addi $a2, $zero, 7
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 3
	addi $a1, $t1, 4
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 8
	addi $a1, $t1, 2
	addi $a2, $zero, 7
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 3
	addi $a1, $t1, 8
	addi $a2, $zero, 4
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	jr $ra
 	
 paint_asterisc: # paint_asterisc($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 1
	addi $a1, $t1, 1
	addi $a2, $zero, 7
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_dline_direita
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
 	
 	addi $a0, $t0, 7
	addi $a1, $t1, 1
	addi $a2, $zero, 7
	addi $a3, $t2, 0
 	
 	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_dline_esquerda
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 4
	addi $a1, $t1, 1
	addi $a2, $zero, 7
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_vline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	addi $a0, $t0, 1
	addi $a1, $t1, 4
	addi $a2, $zero, 6
	addi $a3, $t2, 0
	
	sw $t0, 0($sp)
 	sw $t1, -4($sp) 
 	sw $t2, -8($sp) 
 	sw $ra, -12($sp)
 	addi $sp, $sp, -16
 	
 	jal paint_hline
 	
 	lw $t0, 16($sp)
 	lw $t1, 12($sp)
  	lw $t2, 8($sp)
  	lw $ra, 4($sp)
  	addi $sp, $sp, 16
  	
  	jr $ra

#versao recursiva: utilizar como modelo para sub-rotinas recursivas
#paint_vline:
#  addi $t0, $a0, 0
#  addi $t1, $a1, 0
#  addi $t2, $a2, 0
#  addi $t3, $a3, 0 #carrega os argumentos nos registradores temp
#  add $t2, $t2, $t1 
#  while_1:
#  	beq $t1, $t2, end_1
# 	sw $t0, 0($sp)
# 	sw $t1, -4($sp) 
# 	sw $t2, -8($sp) 
# 	sw $t3, -12($sp)
# 	sw $ra, -16($sp) #salva tudo, inclusive o ponto de retorno, na pilha	  
# 	addi $sp, $sp, -20
# 	addi $a0, $t0, 0   
# 	addi $a1, $t1, 0   
# 	addi $a2, $t3, 0 #passa os argumentos
# 	jal paint_pixel #desvia para a sub-rotina
# 	lw $t0, 20($sp)
# 	lw $t1, 16($sp)
#  	lw $t2, 12($sp)
#  	lw $t3, 8($sp)
#  	lw $ra, 4($sp) #recupera os valores da pilha
#  	addi $sp, $sp, 20
# 	addi $t1, $t1, 1 
# 	j while_1                                                    
#  end_1:
#  jr $ra

main:
	addi $a0, $zero, 20   
	addi $a1, $zero, 6   
	addi $a2, $zero, 200   
	addi $a3, $zero, 0x000000FF #blue
	jal paint_vline 
	
	addi $a0, $zero, 20   
	addi $a1, $zero, 6   
	addi $a2, $zero, 200   
	addi $a3, $zero, 0x0000FF00 #green
	jal paint_hline
	
	addi $a0, $zero, 20   
	addi $a1, $zero, 206   
	addi $a2, $zero, 200   
	addi $a3, $zero, 0x00FFFF00 
	jal paint_hline
	
	addi $a0, $zero, 20   
	addi $a1, $zero, 6   
	addi $a2, $zero, 200   
	addi $a3, $zero, 0x00FF0000 #red
	jal paint_dline_direita
	
	addi $a0, $zero, 220   
	addi $a1, $zero, 6   
	addi $a2, $zero, 200   
	addi $a3, $zero, 0x00FF00FF 
	jal paint_dline_esquerda
  
	addi $a0, $zero, 1   
	addi $a1, $zero, 1   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_one
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 11   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_two
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 21   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_three
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 31   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_four
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 41   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_five
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 51   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_six
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 61   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_seven
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 71   
	addi $a2, $zero, 0x00FFFFFF
	jal paint_eight
	
	addi $a0, $zero, 1   
	addi $a1, $zero, 81   
	addi $a2, $zero, 0x00FF0000
	jal paint_asterisc