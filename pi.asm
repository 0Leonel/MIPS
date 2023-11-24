.data
  pi: .float 3.1415926535 # place value of pi in the data segment
  n1: .float 0.0
  n: .word 0
  n2: .word 0
.text
	li $v0,6
	syscall

	mov.s $f12,$f0
	li $v0,2
	syscall

  l.s $f0, pi           # load pi from data segment into $f12
  li $v0, 2
  syscall                 # print $f12
  
  
  li $v0,5
  syscall
  sw $v0,n
  
  li $v0,5
  syscall
  sw $v0,n2
  
  la $a0,n
  la $a1,n2
  jal pow
  
  move $a0,$v0
  li $v0,1
  syscall
  
  li $v0, 10
  syscall
  
  
pow:
   # save return address on stack
   addi $sp, $sp, -4  
   sw $ra, 0($sp)
   # if y == 0 then return 1.0
   bne $a1, $zero, pow_elif
   li $v0, 1
   j pow_return    

   # else check if y is even
pow_elif:
   andi $t0, $a1, 1
   bne $t0, $zero, pow_else
   srl $a1, $a1, 1
   jal pow
   mul $v0, $v0, $v0
   j pow_return

   # else y must be odd
pow_else:
   addi $a1, $a1, -1
   jal pow
   mul $v0, $a0, $v0   

pow_return:
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra
