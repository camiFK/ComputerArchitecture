list        p=16f84a
#include    <p16f84a.inc>

leido       equ	0x10
entrada     equ 0x15
entrada1    equ 0x20
entrada2    equ 0x30
resultado   equ 0x40
mascara1    equ b'00011'
mascara2    equ b'11100'
mascaraResta equ b'00100'

ORG	0x00		; comienzo del programa

	bsf     STATUS, RP0	; cambia al banco 1 de registros
	movlw	b'11111'	; configura los bits RA3-RA0 del puerto A
	movwf	TRISA		; como entrada, el bit RA4 como salida
	clrf	TRISB		; configura el puerto B como salida
	bcf     STATUS, RP0	; cambia al banco 0 de registros

	goto	inicio

; Subrutina que lee los bits del PuertoA y separa los dos numeros provinientes
; de dicho puerto. Los 2 bits menos significativos los guarda en entrada1 y
; los 3 bits mas significativos en entrada2
leerNumeros
    movwf   entrada         ; Movemos lo que esta en W a entrada
    movwf   entrada1        ; Movemos lo que esta en W a entrada1
    movwf   entrada2        ; Movemos lo que esta en W a entrada2
    andlw   mascara1        ; mascara para quedarnos solo con 2 bits de la parte baja
    movwf   entrada1        ; movemos el resultado a entrada1

    ; Obtenemos el otro numero
    movfw   entrada2        ; movemos el valor de entrada2 a W
    andlw   mascara2        ; mascara para quedarnos solo con la parte alta
    movwf   entrada2        ; movemos el valor de W a entrada2
    rrf     entrada2        ; sacamos los 2 bits mas bajos
    rrf     entrada2
    return

; Subrutina que suma dos numeros que son pasados en entrada1 y entrada2. El
; resultado de la suma es devuelto en resultado
sumarDosNumeros
    movfw   entrada1        ; Movemos la entrada1 a W
    movwf   resultado       ; Movemos el valor de W a resultado (valor de entrada1)
    movfw   entrada2        ; Movemos el valor de entrada2 a W
    addwf   resultado       ; sumamos lo que esta en W (tambien en entrada2) con resultado (entrada1)
    return

; Subrutina que convierte un binario a su correspondiente en decimal para
; representar en un display de 7 segmentos. El 10 lo representa como 0 y el bit 8 encendido
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
    movf	PORTA, 0	; PORTA -> W
    call	leerNumeros         ; Lee los dos numeros recibidos del PuertoA
    call    sumarDosNumeros     ; Suma los dos numeros
    movfw   resultado           ; Movemos el resultado de la suma a W
    call    conversorBin7seg    ; Convertimos a display de 7 segmentos
	movwf	PORTB               ; Muestra en el PuertoB el resultado
	goto	inicio

END