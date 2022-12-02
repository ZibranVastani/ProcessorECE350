module PCLatch(pcOut, reset, en, pcIn, clock);
    input [31:0] pcIn;
    input reset, en, clock;

    output [31:0] pcOut;

    //singleRegister(out,in,clock,clear,input_enable);
    singleRegister PC(pcOut,pcIn,clock,reset,en);
endmodule
