;configure the  assembler directive 'list' so as to set processor to 18f4620 and set the radix used for data expressions to decimal (can be HEX|DEC|OCT)
    list p=18f4620, r=DEC
    #include <p18f4620.inc>
    
tempo1	    EQU		0x20		; temporizador1
tempo2	    EQU		0x21		; temporizador2
tempo3	    EQU		0x22		; temporizador3
segundos    EQU		0x23
leido	    EQU		0x24
contador   EQU		0x25
	  

; configure the micro so that the watchdog timer is off, low-voltage programming is off, master clear is off and the clock works off the internal oscillator
;    config WDT=OFF, LVP=OFF, MCLRE=OFF, OSC=INTIO67, CCP2MX = PORTC
    
    config OSC = INTIO67, FCMEN = OFF, IESO = OFF                       ;// CONFIG1H
    config PWRT = OFF, BOREN = OFF, BORV = 0                        ;// CONFIG2L
    config WDT = OFF, WDTPS = 32768                                    ;// CONFIG2H
    config MCLRE = ON, LPT1OSC = OFF, PBADEN = OFF, CCP2MX = PORTC       ;// CONFIG3H
    config STVREN = ON, LVP = OFF, XINST = OFF				;// CONFIG4L
    config CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF                   ;// CONFIG5L
    config CPB = OFF, CPD = OFF                                         ;// CONFIG5H
    config WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF               ; // CONFIG6L
    config WRTB = OFF, WRTC = OFF, WRTD = OFF                           ; // CONFIG6H
    config EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF           ;// CONFIG7L
    config EBTRB = OFF     
    
;The org directive tells the compiler where to position the code in memory
    org 0x0000 ;The following code will be programmed in reset address location i.e. This is where the micro jumps to on reset	
    goto Main ;Jump to Main immediately after a reset
  
;--------------------------------------------------------------------------
; Main Program
;-------------------------------------------------------------------------- 
    
Main
    movlw	h'0F'		; Configuramos todos los pines como digitales
    movwf ADCON1

    clrf	TRISB		; configura el puerto B como salida
				; PORTB son los leds y el display si está activado
				
    movlw	b'00000000'	; configura los bits RA7-RA0 del puerto A
    movwf	TRISA		; 
    
    movlw	b'00001001'	; BIT 3 activa los Display, el BIT 0 el Display 0
    movwf	LATA		; 
    
    goto inicio
    
; Subrutina que convierte un binario a su correspondiente en hexa para
; representar en un display de 7 segmentos.
; Recibe por parámetro en el registro W el binario a adaptar a binario de 7 segmentos
conversorBin7seg
    btfsc	STATUS, Z	; Z = 1 ? Consulta si es 0 (cero)
	retlw	b'00111111'	; 0
	movwf	leido       ; Mueve el valor de W a leido y comienza a decrementarlo
	decf	leido       ; hasta que llegue a 0 el que de cero es el valor a representar
	btfsc	STATUS, Z
	retlw	b'00000110'	; 1
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01011011'	; 2
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01001111'	; 3
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01100110'	; 4
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01101101'	; 5
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01111101'	; 6
	decf	leido
	btfsc	STATUS, Z
	retlw	b'00000111'	; 7
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01111111'	; 8
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01101111'	; 9
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01110111'	; A
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01111100'	; B
	decf	leido
	btfsc	STATUS, Z
	retlw	b'00111001'	; C
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01011110'	; D
	decf	leido
	btfsc	STATUS, Z
	retlw	b'01111001'	; E
	retlw	b'01110001'	; F
	
inicio		; como entrada, TRISA = 00000110	
	MOVLW	.1	
	MOVWF	segundos
reiniciar	
	CLRF	contador
iterar  	
	MOVF	contador, W		; Guardamos en W el valor del contador a mostrar
	CALL	conversorBin7seg	; Llamamos al conversor con el valor en W
	MOVWF	PORTB			; Movemos el resultado que está en W al PORTB
	MOVF	segundos, W		; Seteamos los segundos del retardo
	CALL	retardo			;
	movf	contador, W		; Movemos el contador a W para después 
	sublw	15			; controlar si llegamos a 15
	btfsc	STATUS, Z		; Si llegó a 15
	goto	reiniciar		; Reiniciar
	incf	contador		; Sino, incremento el contador
	goto	iterar      ; Vuelve al inicio

retardo	CLRF 	tempo1		; pone tempo1 en 0
	CLRF	tempo2		; pone tempo2 en 0
	MOVWF 	tempo3		; carga en tempo3 el valor del registro W
bucle	DECFSZ 	tempo1		; resta 1 a tempo1
	GOTO 	bucle		; si no es 0 va a bucle
	DECFSZ 	tempo2		; resta 1 a tempo2
	GOTO 	bucle		; si no es 0 va a bucle
	DECFSZ 	tempo3		; resta 1 a tempo3
	GOTO 	bucle		; si no es 0 va a bucle
	RETURN				; finaliza el bucle

    END


