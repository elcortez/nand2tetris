@256
D = A
@0
M = D
@9
D = A
@SP
A = M
M = D
@SP
M = M + 1
@8
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
@LT
D;JLT
@NOT_LT
D;JGE
(LT)
@SP
A = M - 1
A = A - 1
M = -1
@END
0;JMP
(NOT_LT)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
(END)
@END
0;JMP
