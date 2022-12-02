module SLL4bit(outA,A);
    input[31:0] A;
    output[31:0] outA;

    genvar c;
    generate 
        for (c=0; c < 4; c=c+1) begin: loop1
            assign outA[c] = 1'b0;
        end 
        for (c=4;c < 32;c=c+1) begin: loop2
            assign outA[c] = A[c-4];
        end
    endgenerate
endmodule