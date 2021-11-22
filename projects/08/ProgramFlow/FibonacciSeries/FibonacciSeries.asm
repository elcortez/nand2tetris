@256
D = A
@0
M = D
@300
D = A
@1
M = D
@400
D = A
@2
M = D
@3000
D = A
@3
M = D
@3010
D = A
@4
M = D
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
@SP
M = M - 1
A = M
D = M
@COMPUTE_ELEMENT
D;JGT
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
