module MWLatch(insnOut,dataOOut,dataDOut,insnIn,dataOIn,dataDIn,clock,reset,en);
    input [31:0] insnIn,dataOIn,dataDIn;
    input clock,reset,en;

    output [31:0] insnOut,dataOOut,dataDOut;

    //singleRegister insn(insnOut,insnIn,clock,reset,en);
    singleRegister insn(insnOut,insnIn,clock,reset,en);

    singleRegister O(dataOOut,dataOOut,clock,reset,en);
    singleRegister D(dataDOut,dataDOut,clock,reset,en);

    //DFFE needed for exception

endmodule