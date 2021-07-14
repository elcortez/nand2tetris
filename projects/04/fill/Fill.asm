// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.


(LOOP)
@KBD
D = M
@IF_NOT_PRESSED
D;JEQ
@IF_PRESSED
D;JGT

(IF_PRESSED)
@value
M = - 1
@START_FILLING_SETUP
0;JMP
(IF_NOT_PRESSED)
@value
M = 0
@START_FILLING_SETUP
0;JMP


(START_FILLING_SETUP)
@8192
D = A
@max_possible_screen_value
M = D
@SCREEN
D = A
@current_screen_value
M = D
(FILL_LOOP)
@value
D = M
@current_screen_value
A = M
M = D
@current_screen_value
M = M + 1
@max_possible_screen_value
M = M - 1
D = M
@FILL_LOOP
D;JGT
@LOOP
0;JMP
