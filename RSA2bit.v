module RSA2bit(outA,A);
    input[31:0] A;
    output[31:0] outA;

    /*genvar c;
    generate 
        for (c=31; c < 29; c=c-1) begin: loop1
            assign outA[c] = A[31];
        end 
        for (c=29;c <= 0;c=c-1) begin: loop2
            assign outA[c] = A[c+2];
        end
    endgenerate
    */
    assign outA[31] = A[31];
    assign outA[30] = A[31];
    assign outA[29] = A[31];
    assign outA[28] = A[30];
    assign outA[27] = A[29];
    assign outA[26] = A[28];

    assign outA[25] = A[27];
    assign outA[24] = A[26];
    assign outA[23] = A[25];
    assign outA[22] = A[24];
    assign outA[21] = A[23];

    assign outA[20] = A[22];
    assign outA[19] = A[21];
    assign outA[18] = A[20];
    assign outA[17] = A[19];
    assign outA[16] = A[18];

    assign outA[15] = A[17];
    assign outA[14] = A[16];
    assign outA[13] = A[15];
    assign outA[12] = A[14];
    assign outA[11] = A[13];

    assign outA[10] = A[12];
    assign outA[9] = A[11];
    assign outA[8] = A[10];
    assign outA[7] = A[9];
    assign outA[6] = A[8]; 

    assign outA[5] = A[7];
    assign outA[4] = A[6];
    assign outA[3] = A[5];
    assign outA[2] = A[4];
    assign outA[1] = A[3];

    assign outA[0] = A[2]; 

endmodule