.macro print (%label)
	li $v0, 4
	la $a0,%label
	syscall
.end_macro

.macro done
	li $v0,10
	syscall
.end_macro

.macro read_int
	li $v0,5
	syscall
.end_macro

.macro print_int (%int)
	move $a0, %int
	li $v0, 1
	syscall
.end_macro

.macro pila
	add $sp, $sp, -16
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
.end_macro

.macro desapila
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	add $sp, $sp, 16
.end_macro

.macro cargo
	add $sp, $sp, -4
	sw $ra, 0 ($sp)
	
	move $t0,$a0	#Cargo el array para poder almacenar
	move $t1,$a1	#Cargo la longitud de la que quiero en la cadena
.end_macro

.macro descargo
	lw $ra, 0($sp)
	add $sp, $sp, 4
.end_macro

.data
len_array: .space 4

aux: .space 32
array: .space 32

lenArray: .asciiz "\nEnter the length of the array: "
numberF: .asciiz "\nEnter the number ["
numberL: .asciiz "]: "
space: .asciiz " "
arreglo: .asciiz "\nArray: "
numberPar: .asciiz "\nPares: "
numberImpar: .asciiz "\nImpares: "
m: .asciiz "\nMenor a mayor: "
M: .asciiz "\nMayor a menor: "
P: .asciiz "\nPrimos: "
.text
main:
	print (lenArray)
	
	read_int
	sw $v0, len_array
	
	la $a0, array
	la $a1, len_array
	jal enterArray

	print (arreglo)
	la $a0, array
	la $a1, len_array
	jal printArray

	print (numberPar)
	la $a0, array
	la $a1, len_array
	jal printEven

	print (numberImpar)
	la $a0, array
	la $a1, len_array
	jal printOdd
	
	print (P)
	la $a0, array
	la $a1, len_array
	jal Primos
	
	print (m)
	la $a0, array
	la $a1, len_array
	jal Sortm
	
	la $a0, array
	la $a1, len_array
	jal printArray
	
	print (M)
	la $a0, array
	la $a1, len_array
	jal SortM
	
	la $a0, array
	la $a1, len_array
	jal printArray
	
	
	done

############################################################################################################

enterArray:
	cargo
	lw $t1,0($t1)
	li $t2,0
	li $t3,0
	li $t4,1 		#contador exclusivo XD
loopArray:
	beq $t2,$t1,exitArray
	print (numberF)
	print_int ($t4)
	print (numberL)

	read_int
	
	sll $t3,$t2,2
	add $t3,$t3,$t0
	sw $v0,($t3)

	addi $t4, $t4, 1
	addi $t2, $t2, 1

j loopArray

exitArray:
	descargo
	jr $ra

############################################################################################################

printArray:
	cargo
	lw $t1, 0($t1)
	li $t2, 0
	li $t3, 0

loopPrintArray:
	beq $t2, $t1, exitPrintArray
	sll $t3,$t2,2
	add $t3,$t3,$t0
	lw $t4,($t3)

	print_int ($t4)
	print (space)
	
	addi $t2, $t2, 1

	j loopPrintArray

exitPrintArray:
	descargo
	jr $ra

############################################################################################################

printEven:
	cargo
	lw $t1, 0($t1)
	li $t2, 0
	li $t3, 0
	li $t6, 2
loopPar:
	beq $t2, $t1, exitParArray
	sll $t3,$t2,2
	add $t3,$t3,$t0
	lw $t4,($t3) 

	divu $t4, $t6
	mfhi $t5
	bnez $t5, continuePar

	print_int ($t4)
	print (space)
continuePar:

	addi $t2, $t2, 1

	j loopPar

exitParArray:
	descargo
	jr $ra

############################################################################################################

printOdd:
	cargo
	lw $t1, 0($t1)
	li $t2, 0
	li $t3, 0
	li $t5, 0
loopOdd:
	beq $t2, $t1, exitOdd
	sll $t3,$t2,2
	add $t3,$t3,$t0
	lw $t4,($t3) 

	and $t5, $t4,1
	beqz $t5, continueOdd

	print_int ($t4)
	print (space)
continueOdd:

	addiu $t2, $t2, 1

	j loopOdd

exitOdd:
	descargo
	jr $ra

############################################################################################################

Sortm:
	cargo
	lw $t1, 0($t1)
	li $t2, 0  		#i
	li $t3, 0		#j
	li $t9, -1
	add $t9, $t9, $t1

LSm1:
	beq $t2,$t1,exitSortm
	li $t3,0
	LSm2:
	beq $t3, $t9, FSm2
	sll $t4, $t3, 2
	add $t4, $t4, $t0

	lw $t5, 0($t4)
	lw $t6, 4($t4)

	ble $t5, $t6, noswapm
	sw $t6, 0($t4)
	sw $t5, 4($t4)
noswapm:
	add $t3, $t3, 1
	j LSm2
FSm2:
	add $t2, $t2, 1
	j LSm1

exitSortm:
	descargo
	jr $ra

############################################################################################################
SortM:
	cargo
	lw $t1, 0($t1)
	li $t2, 0  		#i
	li $t3, 0		#j
	li $t9, -1
	add $t9, $t9, $t1

LSM1:
	beq $t2,$t1,exitSortM
	li $t3,0
	LSM2:
	beq $t3, $t9, FSM2
	sll $t4, $t3, 2
	add $t4, $t4, $t0

	lw $t5, 0($t4)
	lw $t6, 4($t4)

	bge $t5, $t6, noswapM
	sw $t6, 0($t4)
	sw $t5, 4($t4)
noswapM:
	add $t3, $t3, 1
	j LSM2
FSM2:
	add $t2, $t2, 1
	j LSM1

exitSortM:
	descargo
	jr $ra

############################################################################################################
Primos:
	cargo
	lw $t1, 0($t1)
	li $t2, 0  		#i
	li $t3, 0		

loopPrimo:
	beq $t2, $t1, exitPrimo
	sll $t3,$t2,2
	add $t3,$t3,$t0
	lw $t4,($t3)

	move $a0, $t4
	jal isPrime

	bnez $v0, continuePrimo
	print_int ($t4)
	print (space)
continuePrimo:

	addi $t2, $t2, 1
	j loopPrimo
exitPrimo:
	descargo
	jr $ra

############################################################################################################
isPrime:
	pila
	move $t0, $a0
	blez $t0, setNoPrimo
	beq $t0, 1, setNoPrimo
	li $t1, 2
	li $t2, 0
	li $v0, 0
isPrimeLoop:
	beq $t1, $t0, exitIsPrime
	divu $t0, $t1
	mfhi $t2
	beqz $t2,setNoPrimo
	addiu $t1, $t1, 1
	
	j isPrimeLoop
setNoPrimo:
	li $v0, 1
exitIsPrime:
	desapila
	jr $ra


