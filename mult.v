module mult(data_operandA, data_operandB, ctrl_MULT,clock,data_result, data_exception, data_resultRDY);    
    wire wsignalS, Cout, cOverflowOut,wCin,clear;
    wire[1:0] wsignalPM;
    wire[31:0] wShiftedOut, wFlipped,outAdd,outSub,outCLA;
    wire[64:0] wRegOut;
    wire[5:0] wCount;

    input[31:0] data_operandA,data_operandB;
    input ctrl_MULT,clock;
    
    wire[32:0] multiplier;
    wire[31:0] multiplicand;
    output[31:0] data_result;
    output data_exception,data_resultRDY;
    
    //Set up the multiplier
    assign multiplier[0] = 1'b0;
    assign multiplier[32:1] = data_operandA;

    //Mux to determine if it should be shifted
    //mux_2TTbit(out, select, in0, in1);
    //mux_2TTbit shifter(wShiftedOut,wsignalS,multiplicand,multiplicand<<1);

    //Muxes to determine if its add or subtract based on control
    //mux_4(out, select, in0, in1, in2, in3);
    //Plus min works like: 00 Nothing, 01 minus, 10 plus (11 is just nothing not needed)
    //mux_4 flipB(wFlipped,wsignalPM,wRegOut[64:33],~wRegOut[64:33],wRegOut[64:33],32'b0);
    //mux_4oneBit inputBit(wCin,wsignalPM,1'b0,1'b1,1'b0,1'b0);

    //Control
    //module control(plusOrMin,shift,ProdIn);   
    //control ctrl(wsignalPM,wsignalS,wRegOut);
    //set up register
    wire[64:0] firstTime,wfinalRegIn;
    assign firstTime[32:0] = multiplier;
    assign firstTime[64:33] = 32'b0;
    assign multiplicand = data_operandB;
    
    //check counter
    //counter(count,t,clock,en,clr);
    wire wstart,ending;
    //Register
    //multDivReg(out,in,clock,clear,input_enable);
    multDivReg register(wRegOut,wfinalRegIn,clock,clear,1'b1);

    //Counter
    counter count(wCount,1'b1,clock,1'b1,clear);
    //and(wstart,5'b00000,wCount);
    and starter(wstart,~wCount[5],~wCount[4],~wCount[3],~wCount[2],~wCount[1],~wCount[0]);
    and ender(ending,wCount[5],~wCount[4],~wCount[3],~wCount[2],~wCount[1],wCount[0]);
    //assign data_result = wRegOut[31:0];
    //assign data_resultRDY = 1'b1;


    //Subtraction
    wire CoutSub,cOverflowOutSub;
    //fastAdder(S,Cout,cOverflowOut,A,B,Cin)
    fastAdder subCLA(outSub,CoutSub,cOverflowOutSub,wRegOut[64:33],~multiplicand,1'b1);

    //fastAdder(S,Cout,cOverflowOut,A,B,Cin)
    fastAdder addCLA(outAdd,Cout,cOverflowOut,wRegOut[64:33],multiplicand,1'b0);

    //Control for Real
    wire[1:0] ctrlS;
    assign ctrlS = wRegOut[1:0];
    mux_4 ctrl(outCLA, ctrlS, wRegOut[64:33], outAdd, outSub, wRegOut[64:33]);
    //mux to input the first time value
    //wire[31:0] firstTime,wMuxRegin;
    //assign firstTime = data_operandB;


    //Normal Register input
    wire[64:0] wNormRegIn,wShiftedRegIN;
    //assign wNormRegIn[64:33] = outCLA;
    //assign wNormRegIn[32:0] = wRegOut[32:0];
    assign wNormRegIn = {outCLA,wRegOut[32:0]};

    assign wShiftedRegIN = {wNormRegIn[64], wNormRegIn[64:1]};
    
    //mux_2 fTime(wfinalRegIn,~wstart,wNormRegIn,firstTime);
    mux_2sixtyfive ughhhhhhhh(wfinalRegIn,~wstart,firstTime,wShiftedRegIN);

    assign data_result = wRegOut[32:1];
    assign data_resultRDY = ending;

    //Data Exception
    wire signDiff, regDiff;
    assign signDiff = (((data_operandA[31] ^ data_operandB[31]) ^ data_result[31]) & |data_operandA & |data_operandB);
    assign regDiff = ((|wRegOut[64:32]) & (|(~wRegOut[64:32])));
    assign data_exception = signDiff | regDiff;

endmodule