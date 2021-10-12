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
@END
0;JMP
(NOT_EQ)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
@16
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
@END
0;JMP
(NOT_EQ)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
@16
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
@END
0;JMP
(NOT_EQ)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
@892
D = A
@SP
A = M
M = D
@SP
M = M + 1
@891
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
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
@892
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
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
@891
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
@32767
D = A
@SP
A = M
M = D
@SP
M = M + 1
@32766
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
@GT
D;JGT
@NOT_GT
D;JLE
(GT)
@SP
A = M - 1
A = A - 1
M = -1
@END
0;JMP
(NOT_GT)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
@32767
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
@GT
D;JGT
@NOT_GT
D;JLE
(GT)
@SP
A = M - 1
A = A - 1
M = -1
@END
0;JMP
(NOT_GT)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
@32766
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
@GT
D;JGT
@NOT_GT
D;JLE
(GT)
@SP
A = M - 1
A = A - 1
M = -1
@END
0;JMP
(NOT_GT)
@SP
A = M - 1
A = A - 1
M = 0
@END
0;JMP
@57
D = A
@SP
A = M
M = D
@SP
M = M + 1
@31
D = A
@SP
A = M
M = D
@SP
M = M + 1
@53
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
@112
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
M = M - D
M = M -D
@SP
A = M - 1
D = M
A = A - 1
D = M & D
M = D
@SP
M = M - 1
@82
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
D = M | D
M = D
@SP
M = M - 1
@SP
A = M - 1
D = -M
M = D
@SP
M = M - 1
(END)
@END
0;JMP
