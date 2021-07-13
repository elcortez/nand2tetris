@R0
D = M
@rectangle_length
M = D
@SCREEN
D = A
@current_screen_value
M = D
(BEGIN_BLACKNESS_LOOP)
@current_screen_value
A = M
M = -1
@32
D = A
@thirty_two
M = D
(BEGIN_ITERATION_LOOP)
@current_screen_value
M = M + 1
@thirty_two
M = M - 1
D = M
@BEGIN_ITERATION_LOOP
D;JGT
@rectangle_length
M = M - 1
D = M
@BEGIN_BLACKNESS_LOOP
D;JGT
(END)
@END
0;JMP
