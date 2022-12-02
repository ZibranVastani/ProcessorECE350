module div(data_operandA, data_operandB, ctrl_DIV,clock,data_result, data_exception, data_resultRDY);
    //Input and Output
    input ctrl_DIV, clock;
    input[31:0] data_operandA, data_operandB;
    output data_resultRDY,data_exception;
    output[31:0] data_result;

    //Wires
    wire sign,clr,Cout,CoutSub,cOverflowOut,cOverflowOutSub,cOverflowOut2,Cout2,finalSign,clear,wstart,ending;
    wire[31:0] wA,wQ,wM,addOut,subOut,muxA,negResult,twoComp,wAinv,wBinv,muxQ;
    wire[64:0] wRegIn,wRegOut,firstTime,muxAQ;
    wire[63:0] AQ, shiftAQ;
    wire[5:0] wCount;

    //Hardware

    //Counter
    counter count(wCount,1'b1,clock,1'b1,clear);
    and starter(wstart,~wCount[5],~wCount[4],~wCount[3],~wCount[2],~wCount[1],~wCount[0]);
    and ender(ending,wCount[5],~wCount[4],~wCount[3],~wCount[2],~wCount[1],wCount[0]);

    //Get inital sign difference
    xor(sign,data_operandA[31],data_operandB[31]);

    //assign sign = data_operandA[31] ^ data_operandB[31];

    //Get M and Q
    //assign wQ = data_operandA;
    //assign wM = data_operandB;
    //fastAdder(S,Cout,cOverflowOut,A,B,Cin);

    //Get inverse of A, then mux to get Q
    fastAdder Ainv(wAinv,Cout,cOverflowOut,~data_operandA,32'b1,1'b0);
    mux_2 Q(wQ,data_operandA[31],data_operandA,wAinv);
    
    //Get inverse of B, then mux to get M
    fastAdder binv(wBinv,Cout,cOverflowOut,~data_operandB,32'b1,1'b0);
    mux_2 M(wM,data_operandB[31],data_operandB,wBinv);
   

    //Set up start register
    assign firstTime[31:0] = wQ;
    assign firstTime[63:32] = 32'b0;
    assign firstTime[64] = 1'b0;

    //AQ and shift
    assign AQ = wRegOut[63:0];
    assign shiftAQ = AQ << 1;

    //Add and Sub
    //fastAdder(S,Cout,cOverflowOut,A,B,Cin);
    fastAdder add(addOut,Cout,cOverflowOut,subOut,wM,1'b0);
    fastAdder sub(subOut,CoutSub,cOverflowOutSub,shiftAQ[63:32],~wM,1'b1);
    
    //Pick A and Q A is 32 bits, Q is 33. A = A (+/-) M
    assign muxA = subOut[31] ?  addOut : subOut;
    assign muxQ = subOut[31] ? {shiftAQ[31:1],1'b0} : {shiftAQ[31:1], 1'b1};
    //assign out = select ? in1 : in0;


    //Combine AQ
    assign muxAQ = {1'b0,muxA,muxQ};

    mux_2sixtyfive bigMux(wRegIn,~wstart,firstTime,muxAQ);

    //init register
    //multDivReg(out,in,clock,clear,input_enable);
    multDivReg divReg(wRegOut,wRegIn,clock,clr,1'b1);


    //Get the 2s Complement result
    fastAdder addertwoComp(twoComp,Cout2,cOverflowOut2,~wRegOut[31:0],32'b1,1'b0);
    assign data_resultRDY = ending;
    assign negResult = sign ? twoComp: wRegOut[31:0];
    assign finalSign = |data_operandB;
    assign data_result = finalSign ? negResult: 32'b0;
    assign data_exception = ~finalSign;

endmodule