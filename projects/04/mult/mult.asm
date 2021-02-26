// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

@R0
D=M
@first
M=D // first = R0

@R1
D=M
@second
M=D // second = R1

@i
M=1 // i = 1


(LOOP)
@first
D=M
@n
D=D+M
@STOP
D;JGT // if i > n goto STOP

@sum
D=M
@i
D=D+M
@sum
M=D // sum = sum + i
@i
M=M+1 // i = i + 1
@LOOP
0;JMP








// @R0
// D=M
// @n
// M=D // n = R0
//
// @sum
// M=D // sum = R0
//
// @i
// M=1 // i = 1
//
// (LOOP)
//   @i
//   D=M
//   @n
//   D=D+M
//   @STOP
//   D;JGT // if i > n goto STOP
//
//   @sum
//   D=M
//   @i
//   D=D+M
//   @sum
//   M=D // sum = sum + i
//   @i
//   M=M+1 // i = i + 1
//   @LOOP
//   0;JMP
//
// (STOP)
//   @sum
//   D=M
//   @R1
//   M=D // RAM[1] = sum
//
// (END)
//   @END
//   0;JMP
