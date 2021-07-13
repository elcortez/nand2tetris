@8192
D = A
@max_possible_screen_value
M = D
@SCREEN
D = A
@current_screen_value
M = D
(BEGIN_LOOP)
@current_screen_value
A = M
M = -1
@current_screen_value
M = M + 1
@max_possible_screen_value
M = M - 1
D = M
@BEGIN_LOOP
D;JGT
(END)
@END
0;JMP
