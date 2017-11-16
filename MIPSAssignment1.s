# MIPS Assignment 1
# Programmed by Shelton Allen

	.data

						# Data declaration 	

invalid_inputStr:					# If invalid input, programs outputs this string
	.asciiz "Invalid hexadecimal number."
buffer:							# Reserved space in memory for user input
	.space 9
validCharacters:					# Reserved space in memory for valid characters in user input
	.space 8

	.text



						# Assembly language instructions
main:							# Begin main code
	
	li $v0, 8					# load read string call code
	la $a0, buffer					# load buffer address into $a0
	li $a1, 9					# define amount of characters to be read
	syscall						# system call for keyboard input
	
	li $s1, 0					# Initialize registers for use
	li $t9, 0
	li $t8, 0
	la $t7, validCharacters				# Load address in memory to store valid characters

checkString: 				# Checks to see if string is valid. If not, branches to code to display error message to user
	lb $t0, 0($a0)					# Load byte into $t0
	beqz $t0, endCheck				# Check if current character is end of line character, if so end checkString
	li $t1, 10					# Load return carriage decimal into $t1
	beq $t0, $t1, endCheck				# End checkString if current character is carriage return
	li $t1, 0x00000020				# Load space character in $t1
	bne $t1, $t0, notASpace				# Check if current character is a space, if not branch to notASpace
      spaceCheck:					# If current character is a space, check where the space is and if the input string is invalid
	addiu $a0, $a0, 1				# Put address of next byte of input string in $a0
	beqz $t8, checkString				# check if there was a valid character before the space, if not ignore space
	addiu $t9, $t9, 1				# Record space following valid character entry
	j checkString					# Loop back to checkString
	
     notASpace:
	 bne $t9, $zero, invalid			# Check if there was a sequence of character, any amount of spaces, then a character. If so branch to invalid
		# Check if in range of 0-9 ASCII		
	li $t1, 0x0000003A
	slt $t2, $t0, $t1				# Sets $t2 if t0 <3Ah
	li $t1, 0x0000002F				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 2Fh
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of 0-9 ASCII 
	addu $s1, $s1, $s0				# If falls in the range, increments $s1
		# Check if byte has code for ASCII a-f 
	li $t1, 0x00000067
	slt $t2, $t0, $t1				# Sets $t2 if t0 < 67
	li $t1, 0x00000060				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 60
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of a-f ASCII 
	addu $s1, $s1, $s0				# If falls in the range, increments $s1

		# Check if byte has code for ASCII A-F
	li $t1, 0x00000047
	slt $t2, $t0, $t1				# Sets $t2 if t0 < 47
	li $t1, 0x00000040				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 40
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of A-F ASCII 
	addu $s1, $s1, $s0				# If falls in the range, increments $s1

	beqz $s1, invalid				# If no valid characters, branch to invalid
		# If valid, do the following
	addiu $t8, $t8, 1				# Keep track of valid character entries 
	sb $t0, 0($t7)					# Move valid character into validCharacter array
	addiu $t7, $t7, 1				# Put address of next byte of validCharacter array in $t7
     	addiu $a0, $a0, 1				# Put address of next byte of input string in $a0
	li $s1, 0					# Reset these registers
	li $s0, 0

	j checkString					# Loop back to checkString
invalid: 
	li $v0, 4					# load print string call code
	la $a0, invalid_inputStr			# Print error message
	syscall						# print buffer string
	j endFunc					# Jump to end of program

endCheck:						# End the checkString
	beqz $t8, invalid				# If no valid characters entered, input is invalid
		# continue to conversion
convertToInteger:
	la $t0, validCharacters				# Load address of validCharacter array into $t0
	li $s0, 0					# Count will be stored in $s0
	li $s1, 0					# Integer will be stored in $s1
	li $t4, 0					# conversionLoop counter
	li $t9, 48					# Needed for conversion
	li $t7, 16					
	li $t6, 39					# Subtraction if character is a-f
	li $t5, 7					# Subtraction if character is A-F
     conversionLoop:					# Converts each byte into decimal
	lb $t2, 0($t0)					# Load byte from validCharacter array into $t2
	subu $t3, $t2, 48				# Subtract 48 from $t2 and put in $t3
	bgt $t3, $t9, athroughf				# If $t3 > 48, then character was between 'a' and 'f'
	bgt $t3, $t7, AthroughF				# If 48 > $t3 > 16, then character was between 'a' and 'f'
	j movConversion					# If it gets here, number is between 0 and 9 and can be input into final register
     AthroughF:		
	subu $t3,$t3, $t5				# Subtract 7 from $t3 to get final decimal conversion
     	j movConversion					# Go to line in code to put decimal in final register
     athroughf:		
	subu $t3, $t3, $t6				# Subtract 39 from $t3 to get final decimal conversion
     movConversion:
	addu $s0, $s0, $t3				# add converted number to $s0 register
	addiu $t0, $t0, 1				# Put next byte address in $t0
	addiu $t4, $t4, 1				# Loop counter incremented
	beq $t4, $t8, showResult			# If $t4=$t8 then branch to showResult as no shifting needed, time to display result			
	sll $s0, $s0, 4					# Shift left logical 4 times
	j conversionLoop				# loop 

     showResult:
	move $t0, $s0 					# Move $s0 to $t0
	bgez $t0, showInt				# If $t0 msb is 0 then display integer
	li $t1, 10					
	divu $s0, $t1					# Divide number by 10
	mflo $s0					# Store quotient in $s0
	mfhi $s1					# Store remainder in $s1
     showInt:
	li $v0, 1					# Load print integer call code
	move $a0, $s0					# Load integer into $a0	
	syscall						# Print integer (if div occurred, print quotient)
	bgez $t0, endFunc				# End function if no need to show remainder that is in $s1
	move $a0, $s1					# Put remainder in $a0
	syscall						# Print remainder
	
endFunc:
	li $v0, 10

					# Load exit code
	syscall
						# System call to exit
