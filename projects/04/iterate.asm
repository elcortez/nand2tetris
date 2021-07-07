// Compute 1 + 2 + .. + n
@R0 // change here
D = M   // load the value of RAM[0] in D
@sum    // Address a random value in RAM and call it 'sum'
M = D   // put the value of  RAM[0] in sum
(BEGIN_LOOP)
@sum    // Address sum
D = D - 1  // remove 1 from D
M = M + D  // add D to sum
@BEGIN_LOOP
D;JGT    // if D > 0, go back to the beginning of loop
(END)
@END
0;JMP
