0;JNE
0;JNE
0;JNE
(Sys.init)
0;JNE
0;JNE
0;JNE
@4000
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@3
M = D
@5000
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@4
M = D
0;JGT
0;JGT
0;JGT
@retAddr_OXTNIMFN
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
@ARG
M = D
0;JGT
@SP
D = M
@LCL
M = D
0;JGT
@Sys.main
0;JMP
0;JGT
(retAddr_OXTNIMFN)
0;JGT
0;JGT
0;JGT
@SP
A = M - 1
D = M
@6
M = D
@SP
M = M - 1
(LOOP)
@LOOP
0;JMP
0;JNE
0;JNE
0;JNE
(Sys.main)
@0
D = A
@SP
A = M
M = D
@SP
M = M + 1
@0
D = A
@SP
A = M
M = D
@SP
M = M + 1
@0
D = A
@SP
A = M
M = D
@SP
M = M + 1
@0
D = A
@SP
A = M
M = D
@SP
M = M + 1
@0
D = A
@SP
A = M
M = D
@SP
M = M + 1
0;JNE
0;JNE
0;JNE
@4001
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@3
M = D
@5001
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@4
M = D
@200
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
M = M + 1
A = M
M = D
@1
M = M - 1
@SP
M = M - 1
@40
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
M = M + 1
M = M + 1
A = M
M = D
@1
M = M - 1
M = M - 1
@SP
M = M - 1
@6
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
M = M + 1
M = M + 1
M = M + 1
A = M
M = D
@1
M = M - 1
M = M - 1
M = M - 1
@SP
M = M - 1
@123
D = A
@SP
A = M
M = D
@SP
M = M + 1
0;JGT
0;JGT
0;JGT
@retAddr_NHVGAXOL
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
0;JGT
@SP
D = M
@LCL
M = D
0;JGT
@Sys.add12
0;JMP
0;JGT
(retAddr_NHVGAXOL)
0;JGT
0;JGT
0;JGT
@SP
A = M - 1
D = M
@5
M = D
@SP
M = M - 1
@1
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@1
M = M + 1
A = M
D = M
@1
M = M - 1
@SP
A = M
M = D
@SP
M = M + 1
@1
M = M + 1
M = M + 1
A = M
D = M
@1
M = M - 1
M = M - 1
@SP
A = M
M = D
@SP
M = M + 1
@1
M = M + 1
M = M + 1
M = M + 1
A = M
D = M
@1
M = M - 1
M = M - 1
M = M - 1
@SP
A = M
M = D
@SP
M = M + 1
@1
M = M + 1
M = M + 1
M = M + 1
M = M + 1
A = M
D = M
@1
M = M - 1
M = M - 1
M = M - 1
M = M - 1
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
A = A - 1
D = M + D
M = D
@SP
M = M - 1
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
@endFrame_DZGGINKG
M = D
0;JLT
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@retAddr_DZGGINKG
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
@endFrame_DZGGINKG
D = M - 1
A = D
D = M
@THAT
M = D
0;JLT
@endFrame_DZGGINKG
D = M
D = D - 1
D = D - 1
A = D
D = M
@THIS
M = D
0;JLT
@endFrame_DZGGINKG
D = M
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@ARG
M = D
0;JLT
@endFrame_DZGGINKG
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
@retAddr_DZGGINKG
A = M
0;JMP
0;JLT
0;JLT
0;JLT
0;JNE
0;JNE
0;JNE
(Sys.add12)
0;JNE
0;JNE
0;JNE
@4002
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@3
M = D
@5002
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
A = M
D = M
@4
M = D
@2
A = M
D = M
@SP
A = M
M = D
@SP
M = M + 1
@12
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
0;JLT
0;JLT
0;JLT
@LCL
D = M
@endFrame_MFDMABBZ
M = D
0;JLT
D = D - 1
D = D - 1
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@retAddr_MFDMABBZ
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
@endFrame_MFDMABBZ
D = M - 1
A = D
D = M
@THAT
M = D
0;JLT
@endFrame_MFDMABBZ
D = M
D = D - 1
D = D - 1
A = D
D = M
@THIS
M = D
0;JLT
@endFrame_MFDMABBZ
D = M
D = D - 1
D = D - 1
D = D - 1
A = D
D = M
@ARG
M = D
0;JLT
@endFrame_MFDMABBZ
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
@retAddr_MFDMABBZ
A = M
0;JMP
0;JLT
0;JLT
0;JLT
(END)
@END
0;JMP
