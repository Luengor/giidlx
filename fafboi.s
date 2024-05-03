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

        ; Cargamos 1/9 para dentro de ~150 líneas (opt: 8)
        lf      f23, uno_entre_nueve

        ; R2 es el valor máximo de la secuencia
        ; R3 es la suma de todos los valores de la secuencia (para el valor medio)
        ; R4 es el puntero al valor a escribir de secuencia Y el tamaño de la 
        ; secuencia * 4

        ; Bucle chulo de cálculo
calc_loop:
        ; Escribimos en la secuencia 
        sw      secuencia(r4), r1
        addi    r4, r4, #4

        ; Comprobamos si es par (opt: 7)
        andi    r29, r1, #1     ; r29 == 1 si r1 es impar

        ; Sumar al valor medio
        add    r3, r3, r1

        ; Salto si es par
        beqz    r29, es_par

        ;; Es impar
        ; Comprobamos si el valor es 1 antes (opt: 3/8)
        seqi    r28, r1, #1

        ; Sumamos en vez de multiplicar (opt: 4)
        ; r6 <- (r1 + r1)
        add     r6, r1, r1

        ; Comprobamos si el valor es 1
        bnez    r28, fin_calc

        ; r1 <- (r6 + r1) 
        add     r1, r6, r1

        ; Comprobamos si es el valor máximo solo si es impar (opt: 5)
        sle     r29, r2, r1     ; r29 == 1 si r2 <= r1

        ; r1 <- (r1 +  1)
        addi    r1, r1, #1

        ; Saltar si no es el máximo
        beqz    r29, par_rapido 

        ; Cambiar el máximo (opt: 10)
        addi    r2, r1, #0

par_rapido:
        ;; Ciclo par rápido (opt: 6)
        sw      secuencia(r4), r1   ; Guardamos en secuencia 
        addi    r4, r4, #4          ; Sumamos al indice de secuencia
        add     r3, r3, r1          ; Sumamos al valor medio

es_par:
        srli    r1, r1, #1          ; Dividimos entre 2
        j calc_loop
        

fin_calc:
        ; Guardar tamaño
        srli    r4, r4, #2
        sw      secuencia_tamanho, r4

        ; Calcular media
        movi2fp f1, r3
        movi2fp f3, r4

        ; f5:  vMed      la media
        divf    f5, f1, f3

        ; Escribimos el valor máximo (opt: 10)
        sw      secuencia_maximo, r2

        ; f3:  vT        el número de valores de secuencia 
        cvti2f  f3, f3

        ; Empezamos a cargar el valor inicial (opt: 1)
        lf      f1, valor_inicial

        ; Cargamos el valor máximo en f7
        movi2fp f7, r2

        ; f1:  vIni      el valor inicial
        cvti2f  f1, f1

        ; f7:  vMax      el valor máximo
        cvti2f  f7, f7

        ; Guardar media en memoria
        sf      secuencia_valor_medio, f5
        
        ; f9:  vT/vMax --- Primera división
        divf    f9, f3, f7

        ; vIni*vT
        multf   f15, f1, f3
        addf    f21, f21, f15
        sf      lista, f15

        ; vMax*vT
        multf   f17, f7, f3
        addf    f21, f21, f17
        sf      lista+4, f17

        ; vMed*vT
        multf   f19, f5, f3

        ; f11: vT/vIni --- Segunda división
        divf    f11, f3, f1

        ; Sige vMed*vT
        addf    f21, f21, f19
        sf      lista+8, f19

        ; vIni * vT/vMax
        multf   f15, f1, f9
        addf    f21, f21, f15
        sf      lista+12, f15

        ; vMed * vT/vMax 
        multf   f19, f5, f9
        addf    f21, f21, f19
        sf      lista+32, f19

        ; f13: vT/vMed --- Tercera división
        divf    f13, f3, f5

        ; vIni * vT/vMed
        multf   f17, f1, f13
        addf    f21, f21, f17
        sf      lista+16, f17

        ; vMax * vT/vIni 
        multf   f19, f7, f11
        addf    f21, f21, f19
        sf      lista+20, f19

        ; vMax * vT/vMed
        multf   f15, f7, f13
        addf    f21, f21, f15
        sf      lista+24, f15

        ; vMed * vT/vIni
        multf   f17, f5, f11
        addf    f21, f21, f17
        sf      lista+28, f17

        ;; Valor medio de la lista
        multf   f21, f21, f23
        sf      lista_valor_medio, f21

        trap 0;

