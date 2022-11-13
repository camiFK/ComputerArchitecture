list        p=16f84a
#include    <p16f84a.inc>

	ORG     0x00		; comienzo del programa

    	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'11111'	; configura el puerto A como entrada
	movwf	TRISA
	clrf	TRISB		; configura el puerto B como salida
	bcf     STATUS, RP0	; cambia al banco 0 de registros

	goto	inicio

inicio
    	movf	PORTA, 0    ; Toma la entrada del puerto A y la guarda en W
	movwf	PORTB       ; Pone lo que se encuentra en W en el puerto B
	goto	inicio      ; Vuelve al inicio

END
