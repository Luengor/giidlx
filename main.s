                        .data

;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN
; VARIABLE DE ENTRADA: (SE PODRA MODIFICAR EL VALOR ENTRE 1 Y 100)
valor_inicial:          .word       5 
;; VARIABLES DE SALIDA:
secuencia:              .space      120*4
secuencia_tamanho:      .word       0
secuencia_maximo:       .word       0
secuencia_valor_medio:  .float      0
lista:                  .space      9*4
lista_valor_medio:      .float      0
;; FIN VARIABLES DE ENTRADA Y SALIDA

tres:                   .byte       3

PrintFormat:            .asciiz     "%d\n"
                        .align      2
PrintPar:               .word       PrintFormat
PrintValue:             .space      4

                        .text
                        .global     main


; Tabulaciones normales vv
main:
        ; Cargamos los valores 
        lw      r1, valor_inicial

        ; R2 es el valor máximo de la secuencia
        ; R3 es la suma de todos los valores de la secuencia (para el valor medio)
        ; R4 es el puntero al valor a escribir de secuencia Y el tamaño de la 
        ; secuencia * 4

        ; R30 es 3
        lbu     r30, tres
        

        ; Bucle chulo de cálculo
calc_loop:
        ; Escribimos en la secuencia 
        sw      secuencia(r4), r1
        addi    r4, r4, #4

        ; Sumar al valor medio
        add    r3, r3, r1

        ; Comprobamos si es el valor máximo
        slt     r29, r2, r1  ; r3 == 1 si r2 < r1
        beqz    r29, salir_uno

        ; Cambiar el máximo             TODO: mirar esto
        sw      secuencia_maximo, r1
        lw      r2, secuencia_maximo

salir_uno:
        ; Comprobamos si el valor es 1
        seqi    r29, r1, #1
        bnez    r29, fin_calc


        ;; Cálculo de secuencia 
        ; Comprobamos si es par
        andi    r29, r1, #1     ; r29 == 1 si r1 es impar
        beqz    r29, es_par

        ; Es impar
        multu   r1, r1, r30
        addi    r1, r1, #1

        j calc_loop
        
es_par:
        ; Es par
        srli    r1, r1, #1
        j calc_loop

fin_calc:
        ; Guardar tamaño
        srli    r4, r4, #2
        sw      secuencia_tamanho, r4

        ; Calcular media
        movi2fp f1, r3
        movi2fp f3, r4

        divf    f5, f1, f3

        sf      secuencia_valor_medio, f5

        trap 0;

