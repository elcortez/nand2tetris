@SCREEN
D = A
@current_screen_value
M = D
@R0
D = M
@rectangle_length
M = D
(BEGIN_BLACKNESS_LOOP)
@current_screen_value
A = M
M = -1
@32
D = A
@current_screen_value
M = D + M
@rectangle_length
M = M - 1
D = M
@BEGIN_BLACKNESS_LOOP
D;JGT
(END)
@END
0;JMP
