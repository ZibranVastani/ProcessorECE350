module memoryStage(oOut,en,dOut, dmemAddress, dmemWrite, insn, dmemRead,oIn,bIn);
    input[31:0] insn,dmemRead,oIn,bIn;

    output[31:0] oOut, dOut, dmemWrite, dmemAddress;
    output en;
    
    assign oOut = oIn;
    assign dOut = dmemRead;

    assign dmemAddress = oIn;
    assign dmemWrite = bIn;

    wire[4:0] op;
    assign op = insn [31:27];

    assign en = (op == 5'b11000);
    
endmodule