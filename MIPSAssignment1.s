# MIPS Assignment 1
# Programmed by Shelton Allen

	.data

						# Data declaration 
inputStr: 
	.asciiz "\nEnter a string containing only hex"	

invalid_inputStr:
	.asciiz "\nThe string is invalid. Try again!"
resultStr:
	.asciiz "\nThe result is: "
buffer:	
	.space 9

	.text



						# Assembly language instructions
main:							# Begin main code
	li $v0, 4					# load print string call code
	la $a0, inputStr				# load address of string to print
	syscall						# print inputStr
	
	li $v0, 8					# load read string call code
	la $a0, buffer					# load buffer address into $a0
	li $a1, 9					# define amount of characters to be read
	syscall						# system call for keyboard input
	
	addi $s1, $zero, 0
checkString: 
	lb $t0, 0($a0)
	beqz $t0, endFunc				# Check if current character is end of line character
	li $t1, 10
	beq $t0, $t1, endFunc				# End program if current character is newline character

		# Check if in range of 0-9 ASCII
	li $t1, 0x0000003A
	slt $t2, $t0, $t1				# Sets $t2 if t0 <3Ah
	li $t1, 0x0000002F				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 2Fh
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of 0-9 ASCII 
	add $s1, $s1, $s0			
		# Check if byte has code for ASCII a-f 
	li $t1, 0x00000067
	slt $t2, $t0, $t1				# Sets $t2 if t0 < 67
	li $t1, 0x00000060				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 60
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of a-f ASCII 
	add $s1, $s1, $s0

		# Check if byte has code for ASCII A-F
	li $t1, 0x00000047
	slt $t2, $t0, $t1				# Sets $t2 if t0 < 47
	li $t1, 0x00000040				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 40
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of A-F ASCII 
	add $s1, $s1, $s0

	beqz $s1, invalid
	addi $a0, $a0, 1
	li $s1, 0
	li $s0, 0
	j checkString
invalid: 
	li $v0, 4					# load print string call code
	la $a0, invalid_inputStr			# Print error message
	syscall						# print buffer string

endFunc:
	li $v0, 4
	la $a0, resultStr
	syscall
	li $v0, 10

					# Load exit code
	syscall
						# System call to exit
