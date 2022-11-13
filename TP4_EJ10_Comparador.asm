list        p=16f84a
#include    <p16f84a.inc>

numero1	equ	0x20
numero2	equ	0x21
salida	equ	0x22
mascara	equ	b'00011111'

ORG     0x00

	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'11111'
	movwf	TRISA		; configura el puerto A como entrada
	movlw	b'00011111'	; configura los bits RB0-RB4 como entrada y
	movwf	TRISB		; los bits RB5-RB7 como salida
	bcf     STATUS, RP0	; cambia al banco 0 de registros

	goto	inicio

; Subrutina que compara dos numeros para saber si uno es mayor, menor o igual que
; otro. Ambos numeros deben ser pasados por parametro en numero1 y numero2
; El resultado es devuelto en W, retornando:
;           40h si son iguales
;           20h si numero1 es mayor que numero2
;           80h si numero2 es mayor que numero1
comparaMayorMenor
    movfw   numero2     ; Mueve numero2 a W
    subwf	numero1, W	; W = W - numero1
	btfsc	STATUS, Z	; Z = 1?
	retlw	b'01000000'	; numero1 = num2, encender RB6
	btfsc	STATUS, C	; C = 1?
	retlw	b'00100000'	; numero1 > num2, encender RB5
	retlw	b'10000000'	; numero1 < num2, encender RB4

inicio
    movf	PORTA, W	; PORTA -> W
	movwf	numero1		; W -> numero1
	movf	PORTB, W	; PORTB -> W
	andlw	mascara		; pone en '0' los 3 bits más altos de W
    movwf	numero2		; W -> numero2
	call	comparaMayorMenor
	movwf	salida		; W -> salida
	movf	PORTB, W	; PORTB -> W
	andlw	mascara		; pone en '0' los 3 bits más altos de W
	addwf	salida, W	; coloca el valor de salida en los 3 bits más altos de W
	movwf	PORTB		; W -> PORTB
	goto	inicio

END



