module writeStage(ctrl_writeReg, data_writeReg, ctrl_writeEnable, insn, oIn, dIn);
    input[31:0] insn, oIn, dIn;
    
    output [31:0] data_writeReg;
    output [4:0] ctrl_writeReg;
    output ctrl_writeEnable;

    wire add, addi, sub, mul, div, r, insnR, writeB,jail, newX;
    wire[4:0] op;

    assign op = insn[31:27];

    assign insnR = (op == 5'b00000);

    assign addi = (op == 5'b00101);
    assign writeB = (op == 5'b01000);
    assign jail = (op == 5'b00011);
    assign newX = (op == 5'b10101);

    assign ctrl_writeEnable = insnR || addi || writeB || jail || newX || 1'b0;
    
    wire[4:0] rd = insn[26:22];

    wire[31:0] temp;
    wire[4:0] writeRegTemp;

    assign data_writeReg = ~writeB ? oIn : dIn;
    assign writeRegTemp = newX ? 5'd30 : rd;
    assign ctrl_writeReg = jail ? 5'd31 : writeRegTemp;
endmodule