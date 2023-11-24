.macro numero (%label)
	li $v0, 4
	la $a0, %label
	syscall

	li $v0, 6
	syscall
.end_macro

.macro resultado
	li $v0, 4
	la $a0, resT
	syscall
	
	mov.s $f12,$f1
	li $v0, 2
	syscall
.end_macro

.macro done
	li $v0, 10
	syscall
.end_macro

.data
n1: .float 0
n2: .float 0
res: .float 0

num1: .asciiz "\nIngrese el numero 1: "
num2: .asciiz "\nIngrese el numero 2: "

resT: .asciiz "\nEl resultado es : "

.text
raiz:
	numero(num1)
	mov.s $f1,$f0
	numero(num2)
	mov.s $f4,$f0
	
	add.s $f2, $f2, $f1
	li $t3, 0
Loop:
	div.s $f3, $f2, $f1 	# N/x
	add.s $f1, $f3, $f1		# x + N/x
	div.s $f1, $f1, $f4 	# (x + N/x)/2
	add $t3, $t3, 1
	blt $t3, 20, Loop
	s.s $f1,res
	resultado
