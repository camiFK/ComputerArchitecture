list        p=16f84a
#include    <p16f84a.inc>

leido       equ	0x20
entrada1    equ 0x30
entrada2    equ 0x40
mascara1    equ b'00111'
mascara2    equ b'11000'

ORG	0x00		; comienzo del programa

	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'01111'	; configura los bits RA3-RA0 del puerto A
	movwf	TRISA		; como entrada, el bit RA4 como salida
	clrf	TRISB		; configura el puerto B como salida
	bcf     STATUS, RP0	; cambia al banco 0 de registros

	goto	inicio

; Subrutina que convierte un binario a su correspondiente en hexa para
; representar en un display de 7 segmentos.
; Recibe por parámetro en el registro W el binario a adaptar a binario de 7 segmentos
conversorBin7seg
    btfsc	STATUS, Z	; Z = 1 ? Consulta si es 0 (cero)
	retlw	b'0111111'	; 0
	movwf	leido       ; Mueve el valor de W a leido y comienza a decrementarlo
	decf	leido       ; hasta que llegue a 0 el que de cero es el valor a representar
	btfsc	STATUS, Z
	retlw	b'0000110'	; 1
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1011011'	; 2
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1001111'	; 3
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1100110'	; 4
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1101101'	; 5
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1111101'	; 6
	decf	leido
	btfsc	STATUS, Z
	retlw	b'0000111'	; 7
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1111111'	; 8
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1101111'	; 9
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1110111'	; A
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1111100'	; B
	decf	leido
	btfsc	STATUS, Z
	retlw	b'0111001'	; C
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1011110'	; D
	decf	leido
	btfsc	STATUS, Z
	retlw	b'1111001'	; E
	retlw	b'1110001'	; F

inicio
    movf	PORTA, 0            ; Leemos los bits ingresados en el PORTA -> W
    call	conversorBin7seg    ; Convertimos los bits ingresados al binario correspondiente
                                ; de salida adaptado para el display de 7 seg
	movwf	PORTB
	goto	inicio

END



