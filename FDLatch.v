module FDLatch(fdOut,insnOut,fdIn,insnIn,clock,reset,en);
    input [31:0] insnIn, fdIn;
    input clock, reset,en;

    output [31:0] fdOut,insnOut;

    //singleRegister(out,in,clock,clear,input_enable);
    singleRegister address(fdOut,fdIn,clock,reset,en);
    singleRegister insn(insnOut,insnIn,clock,reset,en);


endmodule