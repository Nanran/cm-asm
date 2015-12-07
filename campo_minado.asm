#BITMAP_START=0x10010000
#blue = 0x000000FF
#red = 0x00FF0000
#green = 0x0000FF00
#width = 256
#uma linha = 1024 em endere?os
#seed = $s0
#incidencia de minas = $s1 (quanto maior, menor a chance te minas aparecerem)
#
#valor que representa uma mina = 666 = $s3

#sumario
#paint pixel: 27
#paint_hline: 39
#paint_vline: 82
#paint_paint_dline_direita: 107
#paint_dline_esquerda: 122
#paint_square: 148
#fill_square: 170
#paint_one: 181
#paint_two: 230
#paint_three: 313
#paint_four: 396
#paint_five: 460
#paint_six: 564
#paint_seven: 669
#paint_eight: 714
#paint_asterisc: 816
#rand_in_default_range: 907
#pos_to_mine_adress: 915
#place_mine_or_not: 923
#place_mines_12_12: 940

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
	
	add $t2, $t2, $t1  # limy = y + side
	sll $t2, $t2, 10   # limy' = 4*(256*limy) 
	
	sll $t1, $t1, 10   # y' = 4*(256*y)
	
	while_4:
		beq $t1, $t2, end_4
		add $t4, $a2, $a0     # limx = x + side
		sll $t4, $t4, 2        # limx' = 4*limx
		addi $t0, $a0, 0       
 		sll $t0, $t0, 2        # x' = 4*x
		while_5:
			beq $t0, $t4, end_5
			add $t5, $t1, $t0   # dslc = x' + y' 
			sw $t3, 0x10010000($t5)
			add $t0, $t0, 4
			j while_5
		end_5:
		addi $t1, $t1, 1024
		j while_4
	end_4:
	jr $ra

paint_one: # paint_one($a0=x,$a1=y,$a2=rgb)
	addi $t0, $a0, 0
	addi $t1, $a1, 0
	addi $t2, $a2, 0
		
	addi $a0, $t0, 14
	addi $a1, $t1, 7
	addi $a2, $zero, 5
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
 	
 	addi $a0, $t0, 14
	addi $a1, $t1, 7
	addi $a2, $zero, 15
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

rand_in_default_range: #rand_in_range(($a0)-1=limite) retorna $v0 = int randomico
	li $v0, 42
	addi $a1, $s1, 0
	addi $a0, $s0, 0
	syscall
	addi $v0, $a0, 0
	jr $ra

pos_to_mine_adress: #a0 = x, $a1 = y, $v0 = endereço
	sll $a0, $a0, 2
	mul $a1, $a1, 12
	sll $a1, $a1, 2
	add $v0, $s2, $a0
	add $v0, $v0, $a1
	jr $ra

place_mine_or_not: #$a0 = x, $a1 = y
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal pos_to_mine_adress
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	addi $t0, $v0, 0 #t0 = endereço da mina
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal rand_in_default_range
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	addi $t1, $v0, 0 #t1 = resultado randomico < $s1
	beq $t1, 0, place_mine
		sw $zero, 0($t0)
		j end_place_mine
	place_mine:
		sw $s3, 0($t0)
	end_place_mine:
	jr $ra


place_mines_8x8: #planta as minas (visualizar no bitmap display)
	
	addi $t1, $zero, 0
	mines_while_0:
		li $t0, 0
		mines_while_1:
			sw $ra, 0($sp)
			sw $t0, -4($sp)
			sw $t1, -8($sp)
			addi $sp, $sp, -12
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			jal place_mine_or_not
			lw $ra, 12($sp)
			lw $t0, 8($sp)
			lw $t1, 4($sp)
			addi $sp, $sp, 12
			
			addi $t0, $t0, 1
		bne $t0, 8, mines_while_1
		addi $t1, $t1, 1
	bne $t1, 8, mines_while_0
	
	jr $ra


paint_grid_8x8:
	addi $a0, $zero, 7            # x coordinate of top left corner
	addi $a1, $zero, 7            # y coordinate of top left corner
	addi $a2, $zero, 240          # line length
	addi $a3, $zero, 0x00FFFFFF   # color
	
	sw $ra, 0($sp)          # store return adress in stack
	addi $sp, $sp, -4
	 
	grid_while_1:                       # paint each horizontal lize 
		addi $t1, $a2, 7            # limite = line length + 7 (coordenada do fim da linha)
		sle $t2, $a1, $t1           # 
		beq $t2, $zero, grid_end_1  # branch if y > limite
		jal paint_hline             # paint horizontal line
		addi $a1, $a1, 30           # y = y + 30 (square length = 29)
		j grid_while_1               
	grid_end_1:
	
	addi $a1, $zero, 7    # reset y to 0
	
	grid_while_2:                       # paint each vertical line
 		addi $t0, $a2, 7            # limite = line length + 7 (coordenada do fim da linha)
		sle $t2, $a0, $t0           # 
		beq $t2, $zero, grid_end_2  # branch if x > limite
		jal paint_vline             # paint vertical line
		addi $a0, $a0, 30           # x = x + 30 (square length = 29)
		j grid_while_2               
	grid_end_2:
	
	lw $ra, 4($sp)       # get return address from stack 
	addi $sp, $sp, 4
	jr $ra               # return

	

label_block:                  # label_block(x=a0, y=a1)
	sll $t0, $a1, 3      #
	add $t0, $t0, $a0    # 
	sll $t0, $t0, 2      # dslc = 4*(8*y + x)
	
	lw $t1, 0x10000000($t0)
	
	beq $t1, $s3, label_exit  # branch if block is a mine
		addi $t2, $zero, 0   # count = 0
		
		addi $t3, $t1, -1    # y0 = y-1
		addi $t4, $t1, 2     # yf = y+2 (limit)
		label_while_0:
			beq $t3, $t4, label_end_0    # branch if x0 == xf
			blt $t3, 0, label_end_1      #  
			bge $t3, 8, label_end_1      # skip iteration if y0 < 0 or y0 >= 8
	
			addi $t5, $t0, -1  # x0 = x-1
			addi $t6, $t0, 2   # xf = x+2 
			label_while_1:
				beq $t5, $t6, label_end_1    # branch if x0 == xf
				blt $t5, 0, label_continue   #
				bge $t5, 8, label_continue   # skip iteration if x0 < 0 or x0 >= 8
			
				sll $t7, $t3, 3       #
				add $t7, $t7, $t5     #
				sll $t7, $t7, 2       # dslc = 4*(8*y0 + x0)
			
				lw $t8, 0x10000000($t7)  # 
			
				bne $t8, $s3, label_continue  # skip if point at (x0, y0) is not a mine
					addi $t2, $t2, 1   # add 1 to count if (x0, t0) is a mine
				label_continue:
				
				addi $t5, $t5, 1   # x0 = x0 + 1
				j label_while_1
			label_end_1:
			
			addi $t3, $t3, 1  # y0 = y0 + 1
			j label_while_0
		label_end_0:
		sw $t2, 0x10000000($t0)  # store count at (x, y)
	label_exit:
	jr $ra


populate_field:
	sw $a0, 0($sp)
	sw $a1, -4($sp)
	sw $ra, -8($sp)	
	addi $sp, $sp, -12	

	addi $a1, $zero, 0
	populate_while_0:
		beq $a1, 8, populate_end_0
		
		addi $a0, $zero, 0
		populate_while_1:
			beq $a0, 8, populate_end_1
			jal label_block
			addi $a0, $a0, 1
			j populate_while_1
		populate_end_1:
		addi $a1, $a1, 1
		j populate_while_0
	populate_end_0:
	
	lw $ra, 4($sp)
	lw $a1, 8($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 12
	
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
	li $s0, 1337 #define a semente
	li $s1, 3 #define a incidencia de minas (1 em em cada dez)
	li $s2, 0x10000000 #define inicio do campo
	li $s3, 666
	
	jal place_mines_8x8
	jal populate_field
	
	jal paint_grid_8x8
	
	li $a0, 8
	li $a1, 8
	jal paint_one