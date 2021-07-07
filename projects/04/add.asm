@R0
D = M
@POSITIVE     // Addressing POSITIVE (which is 8)
D;JGT         // Check D ; If D > 0, goto POSITIVE
@R1
M=0
@END           // Addressing END
0;JMP          // End of programm
(POSITIVE)     // Defining POSITIVE as line 8 (hack assembly sugar syntax)
@R1
M=1
(END)          // Defining END as line 11 (10 before POSITIVE came up)
@END           // Addressing END
0;JMP          // End of programm
