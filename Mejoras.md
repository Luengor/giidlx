Partimos de 250 ciclos con 10:
    - 114 instrucciones
    - 139 stalls:
        -1 LD
        -20 branch
        -58 fp
        -36 structural
        -17 control
        -7 trap
    

Optimizaciones:

    --BRANCH--
    1.- mover la carga del valor inicial mas arriba para que el valor de f1 este disponible cuando cvti2f lo pida (-1 stall LD)

    2.-mover la comparacion del valor maximo mas arriba para que el valor de la comparacion este disponible cuando beqz lo pida (- 1 stall de branch por iteracion de bucle == 7)

    3.-mover la comparacionn de si el numero es 1 mas arriba para que el valor de la comparacion este disponible cuando bnez lo pida (- 1 stall de branch por iteracion de bucle == 7)

    4.-mover la comparacionn de si el numero es impar mas arriba para que el valor de la comparacion este disponible cuando bnez lo pida (+1 ciclo total y - 1 stall de branch por iteracion de bucle == 5)

    --PUNTO FLOTANTE--
    5.- Desplegar la multiplicacion: la instruccion mult consume 5 ciclos, pero la instruccion add solo comsume 1, por tanto, sumar
    en 1 registro 2 veces el valor y luego sumarselo otra vez nos quita los 4 ciclos de stall que genera una multiplicacion y ganamos
    1 ciclo de instruccion de la nueva orden add (+1 instruccion y -4 FP por cada vez que hay un numero impar = 3)

    6.-


    12.- Recolocar las divisiones para evitar los structural stall lo maximo posible

    