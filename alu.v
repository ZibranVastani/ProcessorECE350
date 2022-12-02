module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:
    
    //Addition
    wire[31:0] wAdd,wSub;
    wire wCout,wCoutSub;
    wire wCOverflowAdd,wCOverflowSub;

    fastAdder ADD(wAdd,wCout,wCOverflowAdd,data_operandA,data_operandB,1'b0);
    wire[31:0] wAND,wOr,wSLL,wSRA;

    //Subtraction
    wire[31:0] wInvertedB;
    assign wInvertedB = ~data_operandB;
    fastAdder SUB(wSub,wCoutSub,wCOverflowSub,data_operandA,wInvertedB,1'b1);

    //Bitwise AND
    bitWiseAnd AND(wAND,data_operandA,data_operandB);

    //Bitwise OR
    bitWiseOr OR(wOr,data_operandA,data_operandB);

    //SLL
    LeftBarrelShifter Lefty(wSLL,ctrl_shiftamt,data_operandA);

    //SRA
    RightBarrelShifter Righty(wSRA,ctrl_shiftamt,data_operandA);
    
    

    mux_8 opCode(data_result, ctrl_ALUopcode[2:0], wAdd, wSub, wAND, wOr, wSLL, wSRA, 32'b0, 32'b0);

    //Not Equal to
    or nEqual(isNotEqual, wSub[0], wSub[1], wSub[2], wSub[3], wSub[4], wSub[5], wSub[6], 
            wSub[7], wSub[8], wSub[9], wSub[10], wSub[11], wSub[12], wSub[13], wSub[14], wSub[15], 
            wSub[16], wSub[17], wSub[18], wSub[19], wSub[20], wSub[21], wSub[22], wSub[23], wSub[24], 
            wSub[25], wSub[26], wSub[27], wSub[28], wSub[29], wSub[30], wSub[31]);
    


    //Overflow
    //mux_2 flowy(overflow,ctrl_ALUopcode[0],wCOverflowAdd,wCoutSub);
    assign overflow = ctrl_ALUopcode[0] ? wCOverflowSub : wCOverflowAdd;


    //Less than
    /*wire wfirstBitNegative, wANeg, wBPos, wNegPos, wAPosBNeg, wTyler;
    or lessThan(wfirstBitNegative,wSub[31],1'b0);
    //A neg B pos
    and aNeg(wANeg,data_operandA[31],1'b1);
    and bPos(wBPos,data_operandB[31],1'b0);
    and aNegbPos(wNegPos,wANeg,wBPos);
    //and A pos and B neg not the case
    and aPosbNeg(wAPosBNeg,~wANeg,~wBPos);
    or firstBit_or_AnegBPos(wTyler,wNegPos,wfirstBitNegative);
    and LessthanGate(overflow,wTyler,~wAPosBNeg);
    */
    wire wless1,wless2;
    //and the MSB of result and not overflow
    and lessThan1(wless1,data_result[31],~overflow);
    //and overflow and MSB of A
    and lessThan2(wless2,overflow,data_operandA[31]);
    //or the output of these
    or lessThan3(isLessThan,wless1,wless2);



    

endmodule