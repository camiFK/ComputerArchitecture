list        p=16f84a
#include    <p16f84a.inc>

entrada	equ	0x20
salida	equ	0x21

ORG	0x00

	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'01111'	; configura los bits RA0-RA3 como entrada y
	movwf	TRISA		; RA4 como salida
	clrf	TRISB		; configura el puerto B como salida
	bcf     STATUS, RP0	; cambia al banco 0 de registros
    goto    inicio

inicio
    clrf	salida		; ponemos en salida = 0
    movf	PORTA, W	; PORTA -> W
    movwf	entrada		; cargamos la entrada del puerto A en entrada W -> entrada
    rrf     entrada		; rota entrada hacia la derecha, LSB -> C
    incf	entrada		; incrementa entrada
    correr
        rlf     salida		; rota salida hacia la izquierda, C -> LSB
        decfsz	entrada		; decrementa entrada y si el resultado es cero,
                            ; saltea la proxima instrucción
    goto correr		; itera nuevamente
        movf	salida, W	; salida -> W
        movwf	PORTB		; W -> PORTB
goto inicio

END
