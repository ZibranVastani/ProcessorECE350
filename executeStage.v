module executeStage(insnIn,insnOut,dataExecOut,rs,rt,rd,notequal,lessthan,clock,reset);
    input clock,reset;
    input [31:0] insnIn,rs,rt;
    output [31:0] dataExecOut,insnOut,rd;
    wire [4:0] opcode,shamt,ALUop,zeros;
    output notequal,lessthan;

    assign opcode = insn[31:27];
    assign shamt = insn[11:7];
    assign ALUop = insn[6:2];
    assign zeros = insn[1:0];
    
    wire [31:0] addiWire,mathwire,addiImm,rsSave,rtSave,insn,dataExecOut1,dataExecOut2,dataExecOut3;
    wire ovfAddi,ovfMath;
    wire [31:0] ovf,ovfInternal,ovfInternal2;
    wire[16:0] immediate = insn[16:0];


        //module singleRegister(out,in,clock,clear,input_enable);
    singleRegister insnReg(insn,insnIn,clock,reset,1'b1);
    singleRegister RegA(rsSave, rs, clock, reset,1'b1);
    singleRegister RegB(rtSave, rt, clock, reset,1'b1);
    assign rd = rtSave;
    assign insnOut = (ovf) ? 32'b00101111100000000000000000000000:insn;

    assign addiImm = immediate[16] ? {15'b111111111111111,immediate}:{15'd0,immediate};
    mux_8 fibSel(dataExecOut1, opcode[2:0], mathwire, 32'd0,32'd0,32'd0,32'd0,addiWire, 32'd0,addiWire);
    assign dataExecOut2 = (opcode==5'b01000) ? addiWire:dataExecOut1;
    assign dataExecOut3 = (ovf) ? ovfInternal2:dataExecOut2;
    assign dataExecOut = (insn[26:22]==5'b00000) ? 32'b0:dataExecOut3;

    mux_8 ovfselector(ovfInternal, ALUop[2:0], 32'd1, 32'd3, 32'd0, 32'd0, 32'd0, 32'd0, 32'd4,32'd5);
    assign ovfInternal2 = (opcode[2:0]==5'b00101) ? 32'd2:ovfInternal;
    assign ovf = ovfAddi==1'b1||ovfMath==1'b1;

        //module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
    alu addi(rsSave,addiImm,5'd0,5'd0,addiWire,notequal,lessthan,ovfAddi);
    alu addSub(rsSave,rtSave, ALUop, shamt,mathwire,notequal,lessthan,ovfMath);
endmodule