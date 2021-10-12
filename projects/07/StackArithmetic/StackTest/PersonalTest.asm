@256
D = A
@0
M = D
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
@17
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
@EQ
D;JEQ
@NOT_EQ
D;JNE
(EQ)
@SP
A = M - 1
A = A - 1
M = -1
@SP
M = M - 1
@END
0;JMP
(NOT_EQ)
@SP
A = M - 1
A = A - 1
M = 0
@SP
M = M - 1
@END
0;JMP
(END)
@END
0;JMP
