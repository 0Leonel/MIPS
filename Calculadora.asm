.macro read_int
    li $v0, 5
    syscall
.end_macro

.macro print_label (%label)
    li $v0, 4
    la $a0, %label
    syscall
.end_macro
 
.macro numero (%label)
	li $v0, 4
	la $a0, %label
	syscall

	li $v0, 5
	syscall
.end_macro

.macro resultado
	li $v0, 4
	la $a0, resT
	syscall

	li $v0, 1
	lw $a0, res
	syscall
.end_macro

.macro data
	numero(num1)
	sw $v0, n1
	numero(num2)
	sw $v0, n2
	
	lw $t0, n1
	lw $t1, n2
	and $t2, $t2, 0
.end_macro
.macro done
	li $v0, 10
	syscall
.end_macro

.data
n1: .word 0
n2: .word 0
res: .word 0
schedv: .space 32
num1: .asciiz "\nIngrese el numero 1: "
num2: .asciiz "\nIngrese el numero 2: "

resT: .asciiz "\nEl resultado es : "

menu: .ascii "\n\n1. Sumar dos numeros"
      .ascii "\n2. Restar dos numeros"
      .ascii "\n3. Multiplicar dos numeros"
      .ascii "\n4. Dividir dos numeros"
      .ascii "\n0. Salir"
      .asciiz "\nElija una opcion: "

error: .asciiz "\nOpcion invalida"
fin: .asciiz "\nFin del programa"

.text
main:
   	# initialization scheduler vector
	la $t0, schedv
	
	la $t1, suma
	sw $t1, 0($t0)
	
	la $t1, resta
	sw $t1, 4($t0)
	
	la $t1, multiplicacion
	sw $t1, 8($t0)
	
	la $t1, division
	sw $t1, 12($t0)
	
main_loop:

	jal menu_display
	beqz $v0, main_end
	addi $v0, $v0, -1		# dec menu option
	
	sll $v0, $v0, 2         # multiply menu option by 4
	la $t0, schedv
	add $t0, $t0, $v0
	
	lw $t1, ($t0)
    la $ra, main_ret 		# save return address
    jr $t1					# call menu subrutine
main_ret:
    j main_loop		
main_end:
	print_label(fin)
   done

menu_display:

	print_label(menu)
	read_int

	bgt $v0, 4, menu_display_L1
	bltz $v0, menu_display_L1

	jr $ra

menu_display_L1:
	print_label(error)
	j menu_display


suma:
	data
	add $t2, $t0, $t1
	sw $t2,	res
	resultado
    
    jr $ra

resta:
	data
	sub $t2, $t0, $t1
	sw $t2, res
	resultado
	
	jr $ra
		
multiplicacion:
	data
	mult $t0, $t1
	mflo $t2
	sw $t2, res
	resultado
	
	jr $ra
division:
	data 
	beqz $t2, nodiv
	div $t0, $t1
	mflo $t2
	sw $t2, res
	resultado

	jr $ra
nodiv:
	print_label(error)
	
	jr $ra
