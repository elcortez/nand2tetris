@R1
D = M
@16
@temp // Find some available mem register and use it to represent temp
M = D // temp = R1
@R0
D = M
@R1
M = D // R1 = R0
@temp
D = M
@R0
M = D // R0 = temp
(END)
@END
0;JMP
