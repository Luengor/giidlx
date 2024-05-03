                        .data

;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN
; VARIABLE DE ENTRADA: (SE PODRA MODIFICAR EL VALOR ENTRE 1 Y 100)
valor_inicial:          .word       97 
;; VARIABLES DE SALIDA:
secuencia:              .space      120*4
secuencia_tamanho:      .word       0
secuencia_maximo:       .word       0
secuencia_valor_medio:  .float      0
lista:                  .space      9*4
lista_valor_medio:      .float      0
;; FIN VARIABLES DE ENTRADA Y SALIDA

uno_entre_nueve:        .float      0.111111111

                        .text
                        .global     main

; Tabulaciones normales vv
main:
        ; Cargamos los valores 
        lw      r1, valor_inicial

        ; R1 es el valor actual de la secuencia
        ; R2 es el valor máximo de la secuencia
        ; R3 es la suma de todos los valores de la secuencia (para el valor medio)
        ; R4 es el puntero al valor a escribir de secuencia Y el tamaño de la 
        ; secuencia * 4

        ; R30 es 3
        addi    r30, r0, #3

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
        ; f1:  vIni      el valor inicial
        movi2fp f1, r3
        ; f3:  vT        el número de valores de secuencia 
        movi2fp f3, r4

        ; f5:  vMed      la media
        divf    f5, f1, f3
        cvti2f  f3, f3

        sf      secuencia_valor_medio, f5
        
        ;; Lista
        lf      f1, valor_inicial
        cvti2f  f1, f1

        ; f7:  vMax      el valor máximo
        movi2fp f7, r2
        cvti2f  f7, f7

        ; f9:  vT/vMax
        divf    f9, f3, f7
        ; f11: vT/vIni
        divf    f11, f3, f1
        ; f13: vT/vMed
        divf    f13, f3, f5

        ; vIni*vT
        multf   f15, f1, f3
        sf      lista, f15
        addf    f21, f21, f15

        ; vMax*vT
        multf   f17, f7, f3
        sf      lista+4, f17
        addf    f21, f21, f17

        ; vMed*vT
        multf   f19, f5, f3
        sf      lista+8, f19
        addf    f21, f21, f19

        ; vIni * vT/vMax
        multf   f15, f1, f9
        sf      lista+12, f15
        addf    f21, f21, f15

        ; vIni * vT/vMed
        multf   f17, f1, f13
        sf      lista+16, f17
        addf    f21, f21, f17

        ; vMax * vT/vIni 
        multf   f19, f7, f11
        sf      lista+20, f19
        addf    f21, f21, f19

        ; vMax * vT/vMed
        multf   f15, f7, f13
        sf      lista+24, f15
        addf    f21, f21, f15

        ; vMed * vT/vIni
        multf   f17, f5, f11
        sf      lista+28, f17
        addf    f21, f21, f17

        ; vMed * vT/vMax 
        multf   f19, f5, f9
        sf      lista+32, f19
        addf    f21, f21, f19

        ;; Valor medio de la lista
        lf      f23, uno_entre_nueve
        multf   f21, f21, f23
        sf      lista_valor_medio, f21

        trap 0;

