module bitWiseAnd(outAnd,A,B);
    input[31:0] A,B;
    output[31:0] outAnd;


    and one(outAnd[0],A[0],B[0]);
    and two(outAnd[1],A[1],B[1]);
    and two2(outAnd[2],A[2],B[2]);
    and three(outAnd[3],A[3],B[3]);
    and four(outAnd[4],A[4],B[4]);
    and five(outAnd[5],A[5],B[5]);
    and six(outAnd[6],A[6],B[6]);
    and seven(outAnd[7],A[7],B[7]);
    and eight(outAnd[8],A[8],B[8]);
    and nine(outAnd[9],A[9],B[9]);
    and ten(outAnd[10],A[10],B[10]);
    and eleven(outAnd[11],A[11],B[11]);
    and tweleve(outAnd[12],A[12],B[12]);
    and thirteen(outAnd[13],A[13],B[13]);
    and fteen(outAnd[14],A[14],B[14]);
    and fivteen(outAnd[15],A[15],B[15]);
    and sixteen(outAnd[16],A[16],B[16]);
    and seveteen(outAnd[17],A[17],B[17]);
    and eighteen(outAnd[18],A[18],B[18]);
    and nineteen(outAnd[19],A[19],B[19]);
    and twenty(outAnd[20],A[20],B[20]);
    and twentytwo(outAnd[21],A[21],B[21]);
    and one1(outAnd[22],A[22],B[22]);
    and one2(outAnd[23],A[23],B[23]);
    and one3(outAnd[24],A[24],B[24]);
    and one5(outAnd[25],A[25],B[25]);
    and one4(outAnd[26],A[26],B[26]);
    and one6(outAnd[27],A[27],B[27]);
    and one7(outAnd[28],A[28],B[28]);
    and one8(outAnd[29],A[29],B[29]);
    and one9(outAnd[30],A[30],B[30]);
    and one10(outAnd[31],A[31],B[31]);
endmodule