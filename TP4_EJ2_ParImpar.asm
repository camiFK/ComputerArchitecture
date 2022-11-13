list        p=16f84a
#include    <p16f84a.inc>

numero  equ	0x20    ; numero donde guardaremos la entrada del PuertoA

ORG     0x00

	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'11111'	; configura el puerto A como entrada
	movwf	TRISA
	movlw	b'00000000'	; configura el puerto B como entrada
	movwf	TRISB
	bcf     STATUS, RP0	; cambia al banco 0 de registros

	goto	inicio

defineParidad
    	rrf     numero		; Rota un caracter a derecha dejandolo en el bit Carry
	btfsc	STATUS, C	; C = 1? Preguntamos si el carry es uno
                        	; Si el carry es 1 es porque es impar sino es par
    	retlw	b'00000001'	; numero < num2, encender RB0
	retlw	b'00000010'	; numero < num2, encender RB1

inicio
	movf	PORTA, 0        ; PORTA -> W
	movwf	numero          ; guardamos el numero ingresado en el PuertoA W -> numero
	call	defineParidad   ; llamamos a definir la paridad con el numero guardado
	movwf	PORTB           ; ponemos el W ->PORTB que es el resultado de la paridad
	goto	inicio

END
