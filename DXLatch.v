module DXLatch(DXOut,insnOut,dataAOut,dataBOut,DXIn,insnIn,dataAIn,dataBIn,clock, reset, en);
    input[31:0] DXIn, insnIn, dataAIn, dataBIn;
    input clock, reset, en;

    output[31:0] DXOut, insnOut, dataAOut, dataBOut;

    //singleRegister(out,in,clock,clear,input_enable);
    singleRegister DXInReg(DXOut, DXIn,clock,reset,en);
    singleRegister insnReg(insnOut,insnIn,clock,reset,en);

    singleRegister A(dataAOut,dataAIn,clock,reset,en);
    singleRegister B(dataBOut,dataBIn,clock,reset,en);

endmodule