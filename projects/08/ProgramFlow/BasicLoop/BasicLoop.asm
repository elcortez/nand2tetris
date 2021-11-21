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
D;JGT
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
