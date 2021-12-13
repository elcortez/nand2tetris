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
@261
D = A
@0
M = D
0;JNE
0;JNE
0;JNE
(Sys.init)
0;JNE
0;JNE
0;JNE
@4
D = A
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
0;JGT
0;JGT
@retAddr_VQFJSITU
D = A
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
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
(retAddr_VQFJSITU)
0;JGT
0;JGT
0;JGT
(WHILE)
@WHILE
0;JMP
0;JNE
0;JNE
0;JNE
(Main.fibonacci)
0;JNE
0;JNE
0;JNE
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
@LT_HUZATZNV
D;JLT
@NOT_LT_HUZATZNV
D;JGE
(LT_HUZATZNV)
@SP
A = M - 1
A = A - 1
M = -1
@SP
M = M - 1
@END_HUZATZNV
0;JMP
(NOT_LT_HUZATZNV)
@SP
A = M - 1
A = A - 1
M = 0
@SP
M = M - 1
@END_HUZATZNV
0;JMP
(END_HUZATZNV)
@SP
M = M - 1
A = M
D = M
@IF_TRUE
D;JLT
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
0;JLT
0;JLT
0;JLT
@LCL
D = M
@endFrame_YFDQXBSX
M = D
0;JLT
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
0;JLT
@retAddr_YFDQXBSX
M = D
0;JLT
@SP
M = M - 1
A = M
D = M
@ARG
A = M
M = D
0;JLT
D = A + 1
@SP
M = D
0;JLT
@endFrame_YFDQXBSX
D = M - 1
A = D
D = M
@THAT
M = D
0;JLT
@endFrame_YFDQXBSX
D = M
D = D - 1
D = D - 1
A = D
D = M
@THIS
M = D
0;JLT
@endFrame_YFDQXBSX
D = M
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@ARG
M = D
0;JLT
@endFrame_YFDQXBSX
D = M
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@LCL
M = D
0;JLT
@retAddr_YFDQXBSX
A = M
0;JMP
0;JLT
0;JLT
0;JLT
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
0;JGT
0;JGT
0;JGT
@retAddr_CYMMILYY
D = A
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
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
(retAddr_CYMMILYY)
0;JGT
0;JGT
0;JGT
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
0;JGT
0;JGT
0;JGT
@retAddr_JZPDZRLM
D = A
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@LCL
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@ARG
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@THIS
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
@THAT
D = M
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
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
(retAddr_JZPDZRLM)
0;JGT
0;JGT
0;JGT
@SP
A = M - 1
D = M
A = A - 1
D = M + D
M = D
@SP
M = M - 1
0;JLT
0;JLT
0;JLT
@LCL
D = M
@endFrame_IYPOPWXP
M = D
0;JLT
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
0;JLT
@retAddr_IYPOPWXP
M = D
0;JLT
@SP
M = M - 1
A = M
D = M
@ARG
A = M
M = D
0;JLT
D = A + 1
@SP
M = D
0;JLT
@endFrame_IYPOPWXP
D = M - 1
A = D
D = M
@THAT
M = D
0;JLT
@endFrame_IYPOPWXP
D = M
D = D - 1
D = D - 1
A = D
D = M
@THIS
M = D
0;JLT
@endFrame_IYPOPWXP
D = M
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@ARG
M = D
0;JLT
@endFrame_IYPOPWXP
D = M
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@LCL
M = D
0;JLT
@retAddr_IYPOPWXP
A = M
0;JMP
0;JLT
0;JLT
0;JLT
(END)
@END
0;JMP
