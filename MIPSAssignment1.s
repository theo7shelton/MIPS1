# MIPS Assignment 1
# Programmed by Shelton Allen

	.data

							# Data declaration 
inputStr: 
	.asciiz "Enter a string containing only hex"	
buffer:	
	.space 8

	.text						# Assembly language instructions
main:							# Begin main code
	addi $t0, $zero, 0
	li $v0, 4					# load print string call code
	la $a0, inputStr				# load address of string to print
	syscall						# print inputStr
	
	li $v0, 8					# load read string call code
	la $a0, buffer					# load buffer address into $a0
	li $a1, 9					# define amount of characters to be read
	syscall						# system call for keyboard input

	li $v0, 4					# load print string call code
	syscall						# print buffer string

	li $v0, 10					# Load exit code
	syscall						# System call to exit
