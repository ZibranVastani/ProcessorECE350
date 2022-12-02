module decodeStage(ctrl_readRegA, ctrl_readRegB,insn);
    input[31:0] insn;

    output [4:0] ctrl_readRegA,ctrl_readRegB;

    wire[4:0] op,rd,rs,rt;
    wire insnTemp, bExecute;
    //read the instruction into parts
    assign op = insn[31:27];
    assign rd = insn[26:22];
    assign rs = insn[21:17];
    assign rt = insn[16:12];

    assign insnTemp = (op == 5'd0);
    assign bExecute = (op == 5'b10110);

    //Read from rs unless bExecute is 30
    assign ctrl_readRegA = bExecute ? 5'd30 : rs;
    //if R instruction then read from rt, if not then rd for others
    assign ctrl_readRegB = insnTemp ? rt : rd;
endmodule  