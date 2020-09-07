.globl main
main:

.data

	msg1: 		.asciiz "Player1, Enter your name: "		
	msg2:		.asciiz "\nPlayer2, Enter your nmae: "		
	player1:	.space 4					
	player2:	.space 4					
	linebreak:	.asciiz "\n"
	ask:		.asciiz ", Enter the unmarked index:\n"		
	counter: 	.word 0:8
	marker:		.word 0:9
	draw:		.asciiz "Match is drawn\n"
	wins:		.asciiz " wins\n"
	line:		.asciiz "-------------"
	pipe:		.asciiz "|"
	space:		.asciiz " "
	nought:		.asciiz "O"
	cross:		.asciiz "X"
		
.text
	
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 8
	la $a0, player1
	la $a1, 4
	syscall
	
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 8
	la $a0, player2
	la $a1, 4
	syscall
	
	li $v0, 4
	la $a0, linebreak
	syscall
	
	li $v0, 4
	la $a0, linebreak
	syscall
	
	li $t0, 0
	li $t9, 9
	loop:
	
	li $t2, 2
	li $t3, 3
	div $t0, $t2
	mfhi $t2
	
	repeat:
	
	li $v0, 4
	bne $t2, $zero, else1
		la $a0, player1
		j l1
	else1:
		la $a0, player2
	l1:
	syscall	
		
	li $v0, 4
	la $a0, ask
	syscall
		
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, linebreak
	syscall
	
	li $s0, 1
	li $s2, 10
	grid1:
	
	li $v0, 4
	la $a0, pipe
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s7, $s0, -1
	sll $s4, $s7, 2
	lw $s4, marker($s4)
	li $s5, -1
	li $s6, 1
	
	beq $s4, $s5, case1a
	beq $s4, $zero, case2a
	beq $s4, $s6, case3a
	case1a:
		li $v0, 4
		la $a0, nought
		j l6a
	case2a:
		li $v0, 1
		move $a0, $s7
		j l6a
	case3a:
		li $v0, 4
		la $a0, cross
	l6a:
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	div $s0, $t3
	mfhi $s3
	bne $s3, $zero, end1
		li $v0, 4
		la $a0, pipe
		syscall
		li $v0, 4
		la $a0, linebreak
		syscall
		li $v0, 4
		la $a0, line
		syscall
		li $v0, 4
		la $a0, linebreak
		syscall
	end1:
	
	addi $s0, $s0, 1
	bne $s0, $s2, grid1
		
	li $v0, 5
	syscall
	bge $v0, $t9, repeat
	blt $v0, $zero, repeat
	sll $t8, $v0, 2
	
	lw $a0, marker($t8)
	bne $a0, $zero, repeat	
	bne $t2, $zero, else2
		addi $a0, $a0, -1
		j l2
	else2:
		addi $a0, $a0, 1
	l2:	
	sw $a0, marker($t8)
		
	li $t4, -3
	div $v0, $t3
	mfhi $t8					
	mflo $t5			
	addi $s1, $t5, 3		
	sll $t1, $t8, 2
	sll $s1, $s1, 2
	li $t6, 6
	li $t7, 7
	sll $t6, $t6, 2
	sll $t7, $t7, 2
	
	bne $t2, $zero, else3
		lw $a0, counter($t1)
		addi $a0, $a0, -1
		beq $a0, $t4, exit1
		sw $a0, counter($t1)
		lw $a0, counter($s1)
		addi $a0, $a0, -1
		beq $a0, $t4, exit1	
		sw $a0, counter($s1)
		bne $t8, $t5, else31
			lw $a0, counter($t6)
			addi $a0, $a0, -1
			beq $a0, $t4, exit1
			sw $a0, counter($t6)
		else31:
		add $a0, $t8, $t5
		addi $a0, $a0, -2
		bne $a0, $zero, else33
			lw $a0, counter($t7)
			addi $a0, $a0, -1
			beq $a0, $t4, exit1
			sw $a0, counter($t7)
		else33:
		j l3
	else3:
		lw $a0, counter($t1)
		addi $a0, $a0, 1
		beq $a0, $t3, exit2
		sw $a0, counter($t1)
		lw $a0, counter($s1)
		addi $a0, $a0, 1
		beq $a0, $t3, exit2
		sw $a0, counter($s1)
		bne $t8, $t5, else32
			lw $a0, counter($t6)
			addi $a0, $a0, 1
			beq $a0, $t3, exit2
			sw $a0, counter($t6)
		else32:
		add $a0, $t8, $t5
		addi $a0, $a0, -2
		bne $a0, $zero, else34
			lw $a0, counter($t7)
			addi $a0, $a0, 1
			beq $a0, $t3, exit2
			sw $a0, counter($t7)
		else34:
	l3:
	
	addi $t0, $t0, 1
	bne $t0, $t9, loop
	
	li $v0, 4
	la $a0, draw
	syscall
	j l5
	
	exit1:
		li $v0, 4
		la $a0, player1
		j l4
	exit2:
		li $v0, 4
		la $a0, player2
	l4:
	syscall
	li $v0, 4
	la $a0, wins
	syscall
	
	l5:
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, linebreak
	syscall
	
	li $s0, 1
	li $s2, 10
	grid2:
	
	li $v0, 4
	la $a0, pipe
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s7, $s0, -1
	sll $s4, $s7, 2
	lw $s4, marker($s4)
	li $s5, -1
	li $s6, 1
	
	beq $s4, $s5, case1b
	beq $s4, $zero, case2b
	beq $s4, $s6, case3b
	case1b:
		li $v0, 4
		la $a0, nought
		j l6b
	case2b:
		li $v0, 4
		la $a0, space
		j l6b
	case3b:
		li $v0, 4
		la $a0, cross
	l6b:
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	div $s0, $t3
	mfhi $s3
	bne $s3, $zero, end2
		li $v0, 4
		la $a0, pipe
		syscall
		li $v0, 4
		la $a0, linebreak
		syscall
		li $v0, 4
		la $a0, line
		syscall
		li $v0, 4
		la $a0, linebreak
		syscall
	end2:
	
	addi $s0, $s0, 1
	bne $s0, $s2, grid2

	li $v0, 10
	syscall
