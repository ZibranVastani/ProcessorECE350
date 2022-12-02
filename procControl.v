module procControl(in_instr, ctrl_writeEnable,ctrl_writeReg,ctrl_readRegA,ctrl_readRegB,sw_instr,lw_instr,choose_im);
    input[31:0] in_instr;
    output sw_instr, lw_instr, ctrl_writeEnable, choose_im; 
    output [4:0] ctrl_writeReg, ctrl_writeReg_jal, ctrl_readRegA, ctrl_readRegB, ctrl_readRegB_1;

    wire addi;
    wire read_rd;

    assign read_rd = (sw_instr | jr | bne | blt); 

    assign ctrl_readRegA = bex ? 5'b11110: in_instr[21:17]; 
    assign ctrl_readRegB_1 = read_rd ? in_instr[26:22] : in_instr[16:12];
    assign ctrl_readRegB = rrb_ctrl ? 5'b00000 : ctrl_readRegB_1;
    wire rrb_ctrl;
    assign rrb_ctrl = addi | bex; 

    assign choose_im = (addi | sw_instr | lw_instr);
    assign addi = (~in_instr[31] & ~in_instr[30] & in_instr[29] & ~in_instr[28] & in_instr[27]);
    assign sw_instr = (~in_instr[31] & ~in_instr[30] & in_instr[29] & in_instr[28] & in_instr[27]);
    assign lw_instr = (~in_instr[31] & in_instr[30] & ~in_instr[29] & ~in_instr[28] & ~in_instr[27]);

    assign ctrl_writeReg_jal = jal ? 5'b11111: in_instr[26:22]; //look @ reg on left side of equation, that determines what to write to, jal, setx
    assign ctrl_writeReg = setx ? 5'b11110 : ctrl_writeReg_jal;


    assign ctrl_writeEnable = (~sw_instr & ~jump & ~bne & ~jr & ~blt & ~bex & ~mul & ~div); //use the not of the instructions that DO NOT write back
        
    wire jump, bne, jr, blt, bex, setx, jal, mul, div;

    assign jump = (~in_instr[31] & ~in_instr[30] & ~in_instr[29] & ~in_instr[28] & in_instr[27]); 
    assign bne = (~in_instr[31] & ~in_instr[30] & ~in_instr[29] & in_instr[28] & ~in_instr[27]);
    assign jr = (~in_instr[31] & ~in_instr[30] & in_instr[29] & ~in_instr[28] & ~in_instr[27]);
    assign blt = (~in_instr[31] & ~in_instr[30] & in_instr[29] & in_instr[28] & ~in_instr[27]);
    assign bex = (in_instr[31] & ~in_instr[30] & in_instr[29] & in_instr[28] & ~in_instr[27]);
    assign setx = (in_instr[31] & ~in_instr[30] & in_instr[29] & ~in_instr[28] & in_instr[27]);
    assign jal = (~in_instr[31] & ~in_instr[30] & ~in_instr[29] & in_instr[28] & in_instr[27]);

    assign mul = (~in_instr[31] & ~in_instr[30] & ~in_instr[29] & ~in_instr[28] & ~in_instr[27] & 
                    ~in_instr[6] & ~in_instr[5] & in_instr[4] & in_instr[3]  & ~in_instr[2]);
    assign div = (~in_instr[31] & ~in_instr[30] & ~in_instr[29] & ~in_instr[28] & ~in_instr[27] & 
                    ~in_instr[6] & ~in_instr[5] & in_instr[4] & in_instr[3]  & in_instr[2]);


endmodule