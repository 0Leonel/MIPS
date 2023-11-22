.macro numero
	li $v0, 5
	syscall
.end_macro

.macro printf(%a)
	li $v0, 4
	la $a0,%a
	syscall
.end_macro

.macro espacio
	li $v0, 4
	la $a0, space
	syscall
.end_macro



.data
len: .word 0
num: .word 0
cadena: .space 64 #Primer lugar no lo esta tocando 

length: .asciiz "\nIngrese la longitud del arreglo: "
numeroP: .asciiz "\nIngrese el numero ["
numeroF: .asciiz "]: "

es: .asciiz "\n Los numeros ingresados son: "
space: .asciiz " "
.text
main: 
	  printf(length)
						  
	  numero	
	  sw $v0, len
	  
	  la $t1, len
	  lw $t1, 0($t1)
	  
	  add $t0, $t0, 1
	  la $t2, cadena
loop:
	   bgt $t0, $t1, finloop
      printf(numeroP)
      
      move $a0, $t0
      li $v0,1
      syscall
      
      printf(numeroF)
      
      numero 
		      
      sll $t3,$t0,2
      add $t3,$t3,$t2
      sw $v0, 0($t3)
      addi $t0, $t0, 1
      j loop  
finloop:
      and $t0, $t0,0
      add $t0, $t0, 1
      printf(es)
loop2: 
	   bgt $t0, $t1, finloop2
				
	   sll $t4, $t0, 2
	   add $t4 $t4, $t2
	   
		li $v0, 1
		lw $a0, ($t4)
	 	syscall
		
		espacio
		
	   add $t0, $t0,1
	   j loop2
	  
finloop2:
	j end

end:
      li $v0, 10
      syscall

			
		
