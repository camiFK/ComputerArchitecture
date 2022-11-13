list        p=16f84a
#include    <p16f84a.inc>

leido       equ	0x10
entrada     equ 0x20
contador    equ 0x30
cantBits    equ 0x40

ORG	0x00		; comienzo del programa

	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'11111'	; configura los bits RA3-RA0 del puerto A
	movwf	TRISA		; como entrada, el bit RA4 como salida
	clrf	TRISB		; configura el puerto B como salida
	bcf     STATUS, RP0	; cambia al banco 0 de registros

	goto	inicio

; Subrutina que cuenta la cantidad de bits de un byte. Dicho byte deberá ser
; pasado por parametro en entrada.
; Retorna la cantidad de bits del byte en contador
contarBitsDeByte
    iteracion
        rlf     entrada         ; Rota la entrada y la pone en el carry
        btfsc	STATUS, C       ; Si hay carry es porque es un 1
        incf    contador        ; Si es un uno incrementa el contador
        decfsz  cantBits        ; Decrementa el contador de iteaciones y si es 0 salta
        goto    iteracion
    return

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
	retlw	b'10111111'	; 10 = 0 + bit de diez

inicio    
    movlw   b'00000000'         ; Inicializamos el contador en 0
    movwf   contador
    movlw   b'00001000'         ; Inicializamos la cantida de bits en 8
    movwf   cantBits
    movf	PORTA, 0            ; PORTA -> W
    movwf   entrada
    call	contarBitsDeByte    ; Cuenta la cantidad de bits leidos del PuertoA
    movfw   contador            ; Pasa el resultado del conteo a W
    call    conversorBin7seg    ; Convierte el numero a display 7 seg
	movwf	PORTB               ; Muestra el resultado en el PuertoB
	goto	inicio

END


