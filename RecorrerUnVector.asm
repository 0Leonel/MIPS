.data

numero: .word 0
		.space 36

numeros: .word 1,2,3,4,225,126,127,128,129,0
.text
main:

	la $t3, numero
	
	la $t1, numeros
	and $t0, $t0, 0
loop:
	
	sll $t2,$t0,2
	add $t2,$t2,$t1
	lw $t4, 0($t2)
	
	sll $t5, $t0, 2
	add $t5, $t5, $t3
	sw $t4, 0($t5) 
	
	add $t0, $t0, 1
	bnez $t4, loop
	
end: