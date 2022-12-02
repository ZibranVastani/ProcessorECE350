module XMLatch(insnOut,dataOOut,dataBOut,insnIn,dataOIn,dataBIn,clock,reset,en);
    input[31:0] insnIn,dataOIn,dataBIn;
    input clock,reset,en;

    output[31:0] insnOut,dataOOut,dataBOut;
    
    //singleRegister insn(insnOut,insnIn,clock,reset,en);
    singleRegister O(dataOOut,dataOOut,clock,reset,en);
    singleRegister insn(insnOut,insnIn,clock,reset,en);
    singleRegister B(dataBOut,dataBIn,clock,reset,en);

    //DFFE Need for exception
endmodule