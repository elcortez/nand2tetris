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
@retAddr_FMSRDKYA
D = A
@SP
A = M
M = D
@SP
M = M + 1
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
@SP
D = M - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
@ARG
M = D
@SP
D = M
@LCL
M = D
@Sys.init
0;JMP
(retAddr_FMSRDKYA)
(Sys.init)
@4
D = A
@SP
A = M
M = D
@SP
M = M + 1
@retAddr_WIKCTMUT
D = A
@SP
A = M
M = D
@SP
M = M + 1
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
@SP
D = M - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
@ARG
M = D
@SP
D = M
@LCL
M = D
@Main.fibonacci
0;JMP
(retAddr_WIKCTMUT)
(WHILE)
@WHILE
0;JMP
(Main.fibonacci)
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@2
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
@LT_EFAIWJZH
D;JLT
@NOT_LT_EFAIWJZH
D;JGE
(LT_EFAIWJZH)
@SP
A = M - 1
A = A - 1
M = -1
@SP
M = M - 1
@END_EFAIWJZH
0;JMP
(NOT_LT_EFAIWJZH)
@SP
A = M - 1
A = A - 1
M = 0
@SP
M = M - 1
@END_EFAIWJZH
0;JMP
(END_EFAIWJZH)
@SP
M = M - 1
A = M
D = M
@IF_TRUE
D;JNE
@IF_FALSE
0;JMP
(IF_TRUE)
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@LCL
D = M
@endFrame_AVMHWYSQ
M = D
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@retAddr_AVMHWYSQ
M = D
@SP
M = M - 1
A = M
D = M
@ARG
A = M
M = D
D = A + 1
@SP
M = D
@endFrame_AVMHWYSQ
D = M - 1
A = D
D = M
@THAT
M = D
@endFrame_AVMHWYSQ
D = M
D = D - 1
D = D - 1
A = D
D = M
@THIS
M = D
@endFrame_AVMHWYSQ
D = M
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@ARG
M = D
@endFrame_AVMHWYSQ
D = M
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@LCL
M = D
@retAddr_AVMHWYSQ
A = M
0;JMP
(IF_FALSE)
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@2
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
@retAddr_MIQKIFTN
D = A
@SP
A = M
M = D
@SP
M = M + 1
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
@SP
D = M - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
@ARG
M = D
@SP
D = M
@LCL
M = D
@Main.fibonacci
0;JMP
(retAddr_MIQKIFTN)
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
@retAddr_CAKCKULF
D = A
@SP
A = M
M = D
@SP
M = M + 1
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
@SP
D = M - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
@ARG
M = D
@SP
D = M
@LCL
M = D
@Main.fibonacci
0;JMP
(retAddr_CAKCKULF)
@SP
A = M - 1
D = M
A = A - 1
D = M + D
M = D
@SP
M = M - 1
@LCL
D = M
@endFrame_BMHQZGRG
M = D
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@retAddr_BMHQZGRG
M = D
@SP
M = M - 1
A = M
D = M
@ARG
A = M
M = D
D = A + 1
@SP
M = D
@endFrame_BMHQZGRG
D = M - 1
A = D
D = M
@THAT
M = D
@endFrame_BMHQZGRG
D = M
D = D - 1
D = D - 1
A = D
D = M
@THIS
M = D
@endFrame_BMHQZGRG
D = M
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@ARG
M = D
@endFrame_BMHQZGRG
D = M
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@LCL
M = D
@retAddr_BMHQZGRG
A = M
0;JMP
(END)
@END
0;JMP
