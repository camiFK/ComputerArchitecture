# Computer Architecture

## PIC16F84A Assembler
Input and Output.
<br>
Each exercise has an associated electronic circuit to be simulated using Proteus.
<br>
To be considered:
- The inputs are represented by switches that can be operated. When the switch is closed, it produces a 1 and when it is open, a 0.
- The outputs can be connected to LEDs or 7-segment displays for easy viewing.
- The LED is an optoelectronic device that can be thought of as a light bulb that turns on when there is a 1 and stays off when there is a 0.
- The 7-segment display is essentially a set of LEDs arranged in such a way that they can represent digits or letters. in such a way that they can represent digits or letters.

## Exercises
1. Program that takes input from a switch through the first bit of Port A and turns on an LED connected to the first bit of Port B. 
It should turn on when the switch is closed and turn off when it is open.
2. Program that, according to the binary number represented by 5
switches connected to Port A, turns on an LED connected to bit 0 of Port B if it is odd or turns on an LED connected to bit 1 of Port B if it is even.
3. Program that reads a binary number represented by 4 switches connected to port A and displays it in hexadecimal format on a 7-segment display connected to port B. 
Note how the values are represented on the display.
4. Program that given an input of 5 bits represented by 5 switches connected to the inputs of Port A, 
counts the number of 1's and displays that number in decimal format on a 7-segment display connected to Port B.
5. Program that takes the input from a switch through the first bit of Port A and turns on a sequence of LEDs connected to Port B.
This should turn on when the switch is closed and turn off when the sequence is finished.
6. Program that turns on a sequence of LEDs connected to Port B. The program must turn on one by one all the LEDs sequentially and when it reaches the end start again.
7. Program that turns on a sequence of RGB LEDs connected to Port D.
The program must turn on one by one all the LEDs sequentially and when it reaches the end it starts again.
8. Program that takes the input from a pushbutton through the first bit of Port A and turns on a sequence of hexadecimal numbers on a 7-segment display connected to Port B.
This must be incremented when the pushbutton is pressed.
9. Program that turns on a sequence of hexadecimal numbers in a 7-segment display connected to Port B.
This must be incremented sequentially and be shown on the display and when it reaches the end start again.
