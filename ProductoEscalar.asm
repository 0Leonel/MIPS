# Macros para imprimir, leer enteros y finalizar el programa
.macro print (%label)
	li $v0, 4
	la $a0,%label
	syscall
.end_macro

.macro read_int
	li $v0,5
	syscall
.end_macro

.macro done
	li $v0, 10
	syscall
.end_macro

# Seccion de datos
.data
x1: .word 0
x2: .word 0
y1: .word 0
y2: .word 0

agudo: .asciiz "Forman un angulo agudo\n"
obtuso: .asciiz "Forman un angulo obtuso\n"
ortogonal: .asciiz "Son ortogonales\n"

num1: .asciiz "Introduzca X1: "
num2: .asciiz "Introduzca Y1: "
num3: .asciiz "Introduzca X2: "
num4: .asciiz "Introduzca Y2: "

fin: .asciiz "Fin de programa\n"
.text

# Seccion de codigo
main:
	print (num1)
	read_int	
	sw $v0,x1
	
	print (num2)
	read_int
	sw $v0, y1	
	
	la $t0, x1
	lw $t0,0($t0)
	la $t1, y1
	lw $t1,0($t1)
	
	bne $t0, $t1, else	    # Saltar a 'else' si X1 != Y1, de lo contrario ir a 'end'
	beqz $t0, end
else:
	print (num3)
	read_int
	sw $v0, x2	
	
	print (num4)
	read_int
	sw $v0, y2	
	

	la $a0, x1
	la $a1, x2
	la $a2, y1
	la $a3, y2 
	jal ang

	j main
end:
	print (fin)
	done

###################################################################################################################	
ang:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $a0, ($a0)
	lw $a1, ($a1)
	lw $a2, ($a2)
	lw $a3, ($a3)
	
	li $v0, 0		 
	
	li $t0, 0
	li $t1, 0

	
	mult $a0, $a1		#x1 * x2
	mflo $t0
	
	mult $a2,$a3		#y1 * y2
	mflo $t1
	
	add $v0, $t0,$t1	#x1 * x2 + y1 * y2
	
	jal drotprod
end_ang:
	lw $ra,0($sp)
	add $sp, $sp, 4
	jr $ra
	
###################################################################################################################
drotprod:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $v0, es_ortogonal			
	
	bltz $v0, es_obtuso
	print (agudo)
	
	j end_drotprod
es_obtuso:
	print (obtuso)
	
	j end_drotprod	
es_ortogonal:
	print (ortogonal)

end_drotprod:
	lw $ra,0($sp)
	add $sp, $sp, 4	
	jr $ra
	
	
	
