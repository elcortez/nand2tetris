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
@1
A = M
M = D
@SP
M = M - 1
(LOOP_START)
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@1
A = M
D = M
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
@1
A = M
M = D
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
@LOOP_START
D;JLT
@1
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
(END)
@END
0;JMP
