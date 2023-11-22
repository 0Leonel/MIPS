.macro print %label
	li $v0, 4
	la $a0, %label
	syscall
.end_macro

.macro print_int(%label)
	print(len)
	li $v0, 1
	lb $a0,%label
	syscall
.end_macro

.macro read_string(%string)
	li $v0, 8
	la $a0, %string
	li $a1, 32
	syscall
.end_macro

.macro done
	li $v0,10
	syscall
.end_macro
.data
str1: .space 32
str2: .space 32
lenstr1: .word 0
lenstr2: .word 0

msg1: .asciiz  "\nIngrese la cadena 1: "
msg2: .asciiz "\nIngrese la cadena 2: "

i: .asciiz "\nLa cadena es inversa"
noi: .asciiz "\nLa cadena no es inversa"

len: .asciiz "Cadena tiene: "

.text

main:
    print(msg1)

    read_string(str1)

	la $a0, str1
	jal removeNewLine
	
	la $a0,str1
	jal length
	sb $v0, lenstr1
		
	print_int(lenstr1)
		
    print(msg2)
    
    read_string(str2)
	
	la $a0, str2
	jal removeNewLine
	
	la $a0, str2
	jal length
	sb $v0, lenstr2
		
	print_int(lenstr2)
	
	la $a0, str1
	la $a1, str2
	la $a2, lenstr1
	la $a3, lenstr2
	jal inversas

	bnez $v0, ninv
	print(i) 
	done
ninv:
	print(noi) 
	done
	
inversas:
   	add $sp $sp, -4
   	sw $ra, 0($sp)

    move $t0, $a0   					# Dirección de la primera cadena
    move $t1, $a1   					# Dirección de la segunda cadena
    move $t2, $a2   					# longitud de la primera cadena
	move $t3, $a3 						# longitud de la segunda cadena
	
	lw $t2,0($t2)						#Cargando la longitud de la primera cadena
	lw $t3,0($t3)						#Cargando la longitud de la segundo cadena
	
    li $v0, 0 							#Es verdedaro hasta que se demuestre lo contrario
    bne $t2, $t3, setFalse				#Si la longitudes de las cadena son dif. es FALSO
	add $t3,$t3,-1						#elimino el ultimo caracter NULL
    
    li $s0,0
    li $s1,0

  	li $s2, 0

cmploop:
	add $s1, $t0,$s0					#posicion de la cadena
    lb  $t4,($s1)                       #caracter de la cadena                         

    add $s2,$t1,$t3
    lb $t5,($s2) 
	
	bne $t4,$t5,setFalse 				#comparo los caracteres de cada cadena
	beqz $t4,set						#si el caracter es nulo, termina el bucle
	
    addi $s0,$s0,1                   	#avanza en la cadena
    addi $t3,$t3,-1                   	#retrocede en la cadena
    j cmploop
	
setFalse:
	li $v0, 1 
set:
	lw $ra, 0($sp)
	add $sp $sp, 4
	jr $ra
        
removeNewLine:
	add $sp, $sp, -4
	sw $ra, 0($sp)

    move $s1,$a0
    li $t0, 0 							#Contador de caracteres
    li $t1, 0 							#Contador de caracteres
    removeLoop:
    	add $t1, $s1,$t0
        lb $t2,($t1)  			  		#Carga el byte actual de la cadena
        beqz $t2, doneRemove      		#Si es el carácter nulo, termina el bucle
        bne $t2, 0x0a, continueRemove 	#Si no es el carácter de nueva línea, continua
        sb $zero, ($t1)  				#Reemplaza el carácter de nueva línea con el carácter nulo

    continueRemove:
        addi $t0, $t0, 1   				#Avanza al siguiente byte de la cadena
        j removeLoop					#Regresa al bucle

    doneRemove:
    lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra  							#Regresa de la función
    
length:
	add $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 0
	move $t0, $a0
	
lengthLoop:
	lb $t1,0($t0)
	beqz $t1, lengthend

	addi $v0, $v0, 1	
	addi $t0, $t0, 1
	
	j lengthLoop
lengthend:	
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra


