.data
inputBuffer: .space 50  # Reserva espacio para almacenar la entrada del usuario
mensaje: .asciiz "Ingresa: "
.text
main:
    # Imprimir un mensaje solicitando la entrada del usuario
    li $v0, 4
    la $a0, mensaje
    syscall

    # Leer la entrada del usuario
    li $v0, 8
    la $a0, inputBuffer
    li $a1, 50  # Longitud máxima de entrada
    syscall

    # Remover el carácter de nueva línea (0x0a) si está presente
    jal removeNewLine

    # Aquí, inputBuffer contiene la cadena ingresada por el usuario sin el carácter de nueva línea

    # Tu código adicional aquí

    # Salir del programa
    li $v0, 10
    syscall

# Función para remover el carácter de nueva línea
removeNewLine:
    li $t0, 0   # Inicializa un índice para recorrer la cadena
    removeLoop:
        lb $t1, inputBuffer($t0)  # Carga el byte actual de la cadena
        beqz $t1, doneRemove      # Si es el carácter nulo, termina el bucle
        beq $t1, 0x0a, removeChar # Si es el carácter de nueva línea, salta a removeChar
        j continueRemove          # Si no es ninguno de los casos anteriores, continúa el bucle

    removeChar:
        sb $zero, inputBuffer($t0)  # Reemplaza el carácter de nueva línea con el carácter nulo
        j continueRemove

    continueRemove:
        addi $t0, $t0, 1   # Avanza al siguiente byte de la cadena
        j removeLoop

    doneRemove:
    jr $ra  # Regresa de la función
