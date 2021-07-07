// Compute RAM[1] = 1 + 2 + ... + RAM[0]
@R0
D = M // Load R0 into D
@n
M = D // Load R0 into n
@i
M = 1 // Load 1 into i
@sum
M = 0 // Load 0 into sum
(LOOP)
@i
D = M
@n
D = D - M
@STOP
D;JGT // if i > n goto STOP
@sum
D = M
@i
D = D + M
@sum
M = D // sum = sum + i
@i
M = M + 1
@LOOP
0;JMP
(STOP)
@sum
D = M
@R1
M = D // RAM[1] = sum
(END)
@END
0;JMP
