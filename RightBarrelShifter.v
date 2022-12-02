module RightBarrelShifter(outA,shamt,A);
    input[4:0] shamt;
    input[31:0] A;
    output[31:0] outA;
    wire[31:0] wbarrel8,wbarrel4,wbarrel16,wbarrel2,wbarrel1,wTransfer1,wTransfer2,wTransfer3,wTransfer4,wTransfer5;
    
    //16bit shifter
    RSA16bit sixteen(wTransfer1,A);
    mux_2 postSixteen(wbarrel16,shamt[4],A,wTransfer1);

    //8bit shifter
    RSA8bit eight(wTransfer2,wbarrel16);
    mux_2 postEight(wbarrel8,shamt[3],wbarrel16,wTransfer2);

    //4bit shifter
    RSA4bit four(wTransfer3,wbarrel8);
    mux_2 postFour(wbarrel4,shamt[2],wbarrel8,wTransfer3);

    //2bit shifter
    RSA2bit two(wTransfer4,wbarrel4);
    mux_2 postTwo(wbarrel2,shamt[1],wbarrel4,wTransfer4);

    //1bit shifter
    RSA1bit one(wTransfer5,wbarrel2);
    mux_2 postOne(outA,shamt[0],wbarrel2,wTransfer5);

endmodule