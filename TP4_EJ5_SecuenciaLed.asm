;configure the  assembler directive 'list' so as to set processor to 18f4620 and set the radix used for data expressions to decimal (can be HEX|DEC|OCT)
    list p=18f4620, r=DEC
    #include <p18f4620.inc>
    
tempo1	EQU		0x20		; temporizador1
tempo2	EQU		0x21		; temporizador2
tempo3	EQU		0x22		; temporizador3
segundos EQU		0x23

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
				
    movlw	b'00000001'	; configura los bits RA7-RA0 del puerto A
    movwf	TRISA		; 
	
inicio		; como entrada, TRISA = 00000110	
	MOVLW	.1	
	MOVWF	segundos
	MOVWF	PORTB
iterar  	
	MOVF	segundos, W
	CALL	retardo
	rlncf	PORTB
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


