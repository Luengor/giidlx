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
        addi    r30, r0, #3
        
        ; Escribimos el máximo
        sw      secuencia_maximo, r1

        ;; Bucle chulo de cálculo
calc_loop:
        ; Escribimos en la secuencia 
        sw      secuencia(r4), r1
        addi    r4, r4, #4

        ; Sumar al valor medio
        add    r3, r3, r1

        ; Comprobamos si el valor es 1 (opt: 3)
        seqi    r28, r1, #1

        ; Comprobamos si es par     (opt: 4)
        andi    r29, r1, #1     ; r29 == 1 si r1 es impar

        ; Salimos si el valor era 1
        bnez    r28, fin_calc

        ;; Cálculo de secuencia 
        beqz    r29, es_par

        ; Es impar
        ; Sumamos en vez de multiplicar (opt: 5)
        ; r6 <- (r1 + r1)
        ; r1 <- (r6 + r1) 
        add     r6, r1, r1
        add     r1, r6, r1

        ; Comprobamos si es el valor máximo (opt: 6)
        sle     r29, r2, r1  ; r29 == 1 si r2 <= r1

        ; r1 <- (r1 +  1)
        addi    r1, r1, #1

        beqz    r29, calc_loop 

        ; Cambiar el máximo             TODO: mirar esto
        sw      secuencia_maximo, r1
        lw      r2, secuencia_maximo

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
        cvti2f  f3, f3

        ; Empezamos a cargar el valor inicial (opt: 1)
        lf      f1, valor_inicial

        ; Guardar media en memoria
        sf      secuencia_valor_medio, f5
        
        ;; Lista
        ; f1:  vIni      el valor inicial
        ; f3:  vT        el número de valores de secuencia 
        ; f5:  vMed      la media
        ; f7:  vMax      el valor máximo
        ; f9:  vT/vMax
        ; f11: vT/vIni
        ; f13: vT/vMed
        cvti2f  f1, f1

        movi2fp f7, r2
        cvti2f  f7, f7

        divf    f9, f3, f7
        divf    f11, f3, f1
        divf    f13, f3, f5

        ; vIni*vT
        multf   f15, f1, f3
        sf      lista, f15

        ; vMax*vT
        multf   f17, f7, f3
        sf      lista+4, f17

        ; vMed*vT
        multf   f19, f5, f3
        sf      lista+8, f19

        ; vIni * vT/vMax
        multf   f15, f1, f9
        sf      lista+12, f15

        ; vIni * vT/vMed
        multf   f17, f1, f13
        sf      lista+16, f17

        ; vMax * vT/vIni 
        multf   f19, f7, f11
        sf      lista+20, f19

        ; vMax * vT/vMed
        multf   f15, f7, f13
        sf      lista+24, f15

        ; vMed * vT/vIni
        multf   f17, f5, f11
        sf      lista+28, f17

        ; vMed * vT/vMax 
        multf   f19, f5, f9
        sf      lista+32, f19

        trap 0;

