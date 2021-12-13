@2
M = M + 1
A = M
D = M
@2
M = M - 1
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@4
M = D
@0
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
A = M - 1
D = M
@4
A = M
M = D
@SP
M = M - 1
@1
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
A = M - 1
D = M
@4
M = M + 1
A = M
M = D
@4
M = M - 1
@SP
M = M - 1
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@2
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
A = M - 1
D = M
A = A - 1
D = M - D
M = D
@SP
M = M - 1
@SP
A = M - 1
D = M
@2
A = M
M = D
@SP
M = M - 1
(MAIN_LOOP_START)
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JNE
0;JNE
0;JNE
@SP
M = M - 1
A = M
D = M
@COMPUTE_ELEMENT
D;JNE
@END_PROGRAM
0;JMP
(COMPUTE_ELEMENT)
@4
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@4
M = M + 1
A = M
D = M
@4
M = M - 1
@SP
A = M
M = D
@SP
M = M + 1
@SP
A = M - 1
D = M
A = A - 1
D = M + D
M = D
@SP
M = M - 1
@SP
A = M - 1
D = M
@4
M = M + 1
M = M + 1
A = M
M = D
@4
M = M - 1
M = M - 1
@SP
M = M - 1
@4
D = M
@SP
A = M
M = D
@SP
M = M + 1
@1
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
A = M - 1
D = M
A = A - 1
D = M + D
M = D
@SP
M = M - 1
@SP
M = M - 1
A = M
D = M
@4
M = D
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@1
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
A = M - 1
D = M
A = A - 1
D = M - D
M = D
@SP
M = M - 1
@SP
A = M - 1
D = M
@2
A = M
M = D
@SP
M = M - 1
@MAIN_LOOP_START
0;JMP
(END_PROGRAM)
(END)
@END
0;JMP
