module SLL1bit(outA,A);
    input[31:0] A;
    output[31:0] outA;

    genvar c;
    generate 
        assign outA[0] = 1'b0;
        for (c=1; c < 32; c=c+1) begin: loop1
            assign outA[c] = A[c-1];
        end 
    endgenerate
endmodule