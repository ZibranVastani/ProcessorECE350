/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
    /*
    //Wires
    wire[31:0] pcPCout, pcFDout, pcDXout,insnFDout, insnDXout, insnMWout,insnFDin,insnXMout, aDXout, bDXout, oXMout,bXMout, oMWout, dMWout,pcIn, pcOutExe,memOout, memDout;
    wire dataHazard, br, aluBin, j, rwd, jr, jal, branchTaken;
    wire[4:0] pc5;

    //Latches and Stages
    
    //module PCLatch(pcOut, reset, en, pcIn, clock);
    PCLatch latch1(pcPCout,reset,1'b1,pcIn,clock);

    //module fetchStage(pcOut, pcOutExe, branchTaken, address_imem, pc5, pcIn);
    fetchStage stage1(pcPCout, pcOutExe, branchTaken,address_imem, pc5, pcIn);

    assign insnFDin = branchTaken ? 32'd0 : q_imem;


    //module FDLatch(fdOut,insnOut,fdIn,insnIn,clock,reset,en);
    FDLatch latch2(pcFDout, insnFDout, pcPCout,insnFDin, clock, reset,1'b1);

    //module decodeStage(ctrl_readRegA, ctrl_readRegB,insn);
    decodeStage stage2(ctrl_readRegA, ctrl_readRegB, insnFDout);

    wire[31:0] insnDXin;
    assign insnDXin = (branchTaken) ? 32'd0 : insnFDin;
    //module DXLatch(DXOut,insnOut,dataAOut,dataBOut,DXIn,insnIn,dataAIn,dataBIn,clock, reset, en);
    DXLatch latch3(pcDXout,insnDXout,aDXout,bDXout,pcFDout,insnDXin,data_readRegA,data_readRegB,clock,reset,1'b1);

    wire[31:0] oOutExec, bOutExec;
    wire takeBranch; //This is useless, but its more work to delete it
    
    //module executeStage(pcIn, jbranchTaken, takeBranch, oOut, bOut, insn, regA, regB, pcOut, pc5);
    executeStage stage3(pcDXout,branchTaken,takeBranch,oOutExec,bOutExec,insnDXout,aDXout, bDXout,pcOutExe,pc5);

    //module XMLatch(insnOut,dataOOut,dataBOut,insnIn,dataOIn,dataBIn,clock,reset,en);
    XMLatch latch4(insnXMout,oXMout,bXMout,insnDXout,oOutExec,bOutExec,clock,reset,1'b1);

    //module memoryStage(oOut,en,dOut, dmemAddress, dmemWrite, insn, dmemRead,oIn,bIn);
    memoryStage stage4(memOout, wren, memDout, address_dmem, data, insnXMout, q_dmem, oXMout, bXMout);

    //module MWLatch(insnOut,dataOOut,dataDOut,insnIn,dataOIn,dataDIn,clock,reset,en);
    MWLatch latch5(insnMWout,oMWout,dMWout,insnXMout,memOout,memDout,clock,reset,1'b1);

    //module writeStage(ctrl_writeReg, data_writeReg, ctrl_writeEnable, insn, oIn, dIn);
    writeStage stage5(ctrl_writeReg, data_writeReg,ctrl_writeEnable,insnMWout,oMWout, dMWout);
    */
    

    //Take 2
    //All Wires
    wire divExcp, multOvf; 
    wire [31:0] pcOut, aluPcIn, pcIn, pcOutLatch, romOutLatch, pcOutLatchDec, romOutLatchDec, 
    dataAout, dataBout, jTarget, pc_in_1, pc_in_2;
    wire jump, jal, jumpinst, isNotEqual, isLessThan, overflow, mwJrBYP, xmJrBYP, dxJrBYP;
    wire [31:0] data1JR, data2JR, dataJR;
    wire [31:0] pcInLatch, romInLatch; 
    wire wrenD, swD, lwD, imD;
    wire [4:0] rra_d, rrb_d, wr_d;
    wire [31:0] romInLatchDX;
    wire stall, dxFlush, jr;
    wire[31:0] dataBInLatch, dataAInLatch, dataPCInLatchDX;
    wire [31:0] immVal, aluIn2, dataExecOut, oExecOut, bExOut, 
    romExOut, aluIn2BYP1, aluIn2BYP2, aluIn1BYP1, aluIn1, bexTarg;
    wire muxIn2, isNotEqual2, isLessThan2, ovf2; 
    wire [4:0] aluOpEx, aluOpEx1;
    wire we_e, sw_e, lw_e;
    wire [4:0] rrExec, rrExecb, writeEn, writeEnctrl;
    wire execMemOvf, bex, bp_ctrl_1, bp_ctrl_2, bp_ctrl_1_b, bp_ctrl_2_b, is_branch, bne_ex, blt_ex, blt_alu, bne_alu, branch_overflow;
    wire [31:0] branchPcAlu;
    wire branchTake;
    wire [31:0] pcLatchExec, pcLatchintoExec, pcBex;
    wire xJal, xSetx;
    wire [31:0] execMemOut1, execMemOut2, signExtendTarg;
    wire [31:0] writeOvf, writeOvfAdd, writeOvfSub, execMemOut;
    wire addX, addiX, subX, sw_instr, lw_instr, we_m, im_m;
    wire [4:0] rra_m, rrb_m, wr_m, wr_m_ctrl; 
    wire[31:0] oMemOut, dMemOut, romMemOut;
    wire memBYP, memWBOvf;
    wire[31:0] pcMemLatch;
    wire [31:0] data_writeReg_1, data_writeReg_2, setxTarg, data_writeReg_3;
    wire we_w, sw_w, lw_w, im_w, setx;
    wire [4:0] rraW, rrbW, writeEnWW, ctrl_writeReg_1;
    wire wbJal;
    wire multX, divX;
    wire [31:0] insnMultDiv, multdivOutMem, multdivOutLatched, multdivOutLatched1, multdivOutLatched2; 
    wire md_exception, data_resultRDY;
    wire multDivInProg, multDivSelect;
    wire [4:0] multDivWriteEn;


    //Fetch Stage and Latches -------------------------------------------------------------------------------------------------------------------------------------------

    //Latches
    //module procReg(clock, input_enable, rdE, out, in, clear);
    procReg pc(~clock, ~stall, 1'b1, pcOut, pcIn, reset);
    //module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
    alu pc_addOne(32'd1, pcOut, 5'b0, 5'b1, aluPcIn, isNotEqual, isLessThan, overflow);
    //rom output reenters through q_imem (Latches for Fetch)
    procReg pcLatchObj(~clock, ~stall, 1'b1, pcOutLatch, pcInLatch, reset);//aluPcIn is input, pc+1
    procReg romLatchObj(~clock, ~stall, 1'b1, romOutLatch, romInLatch, reset);//q_imem is input


    //Stage (jal, BYP, and jr)
    //values from ex, wb, or mem, compare wren and write reg (each reg)

    assign pc_in_2 = jr ? dataJR : pc_in_1;
    assign pcIn = branchTake ? pcLatchintoExec : pc_in_2;
    assign address_imem = pcOut; 

    assign pcInLatch = (jr | branchTake) ? 32'b0 : aluPcIn;
    assign romInLatch = (jr | branchTake) ? 32'b0 : q_imem;

    //jal add fetch
    assign jump = (q_imem[31:27] == 5'b00001);
    assign jal = (q_imem[31:27] == 5'b00011);
    assign jumpinst = jal | jump;
    
    assign jTarget[26:0] = q_imem[26:0];
    assign jTarget[31:27] = 5'b0; 

    assign pc_in_1 = jumpinst ? jTarget: aluPcIn;

    //jr Bypass fetch
    assign mwJrBYP = (rrb_d == writeEnWW) & we_w & (writeEnWW != 5'b00000);
    assign xmJrBYP = (rrb_d == wr_m) & we_m & (wr_m != 5'b00000);
    assign dxJrBYP = (rrb_d == writeEn) & we_e & (writeEn != 5'b00000);

    assign data1JR = mwJrBYP ? data_writeReg : data_readRegB;
    assign data2JR = xmJrBYP ? oExecOut : data1JR;
    assign dataJR = dxJrBYP ? execMemOut: data2JR;


    
    //Decode Stage and Latches -------------------------------------------------------------------------------------------------------------------------------------------
        //control to get vals of ctrl reg A and B
        //latches
    procReg pcLatchDecObjs(~clock, 1'b1, 1'b1, pcOutLatchDec, dataPCInLatchDX, reset);
    procReg aLatchDecObj(~clock, 1'b1, 1'b1, dataAout, dataAInLatch, reset);
    procReg bLatchDecObj(~clock, 1'b1, 1'b1, dataBout, dataBInLatch, reset);    
    procReg romLatchPLZWORK(~clock, 1'b1, 1'b1, romOutLatchDec, romInLatchDX, reset);
    //insnreg

    procControl controlFOrDecode(romOutLatch,wrenD,wr_d,rra_d,rrb_d,swD,lwD,imD);

    assign ctrl_readRegA = rra_d;
    assign ctrl_readRegB = rrb_d;

    // wire [31:0] romInLatchDX;
    // wire stall, dxFlush;

    
    //Jump Start
        // wire jr;
    assign jr = ~romOutLatch[31] & ~romOutLatch[30] & romOutLatch[29] & ~romOutLatch[28] & ~romOutLatch[27];

    //ctrl stall (add MultDiv Func)
    assign dxFlush = stall | branchTake;
    assign stall = (lw_e & ((rra_d == writeEn) | ((rrb_d == writeEn) & ~swD))) | data_resultRDY | multDivInProg;
    //stall mux: qimem & stall (branch)
        // wire[31:0] dataBInLatch, dataAInLatch, dataPCInLatchDX;
    assign romInLatchDX = dxFlush ? 32'b0 : romOutLatch;
    assign dataBInLatch = dxFlush ? 32'b0 : data_readRegB;
    assign dataAInLatch = dxFlush ? 32'b0 : data_readRegA;
    assign dataPCInLatchDX = dxFlush? 32'b0: pcOutLatch;


    //Execute Stage and latches -------------------------------------------------------------------------------------------------------------------------------------------
        //Wires moved up top
        // wire [31:0] immVal, aluIn2, dataExecOut, oExecOut, bExOut, romExOut, 
        //aluIn2BYP1, aluIn2BYP2, aluIn1BYP1, aluIn1, bexTarg; 
        // wire muxIn2, isNotEqual2, isLessThan2, ovf2; 
        // wire [4:0] aluOpEx, aluOpEx1;

    //Latches
    procReg  oEXLatchObj(~clock, 1'b1, 1'b1, oExecOut, execMemOut, reset);
    procReg bEXLatchObj(~clock, 1'b1, 1'b1, bExOut, dataBout, reset);
    procReg romLatchExObj(~clock, 1'b1, 1'b1, romExOut, romOutLatchDec, reset);
    procReg pcLatchExObj(~clock, 1'b1, 1'b1, pcLatchExec, pcLatchintoExec, reset);//pc_out_decode is input


    execReAssign test1(immVal,romOutLatchDec);

    // wire we_e, sw_e, lw_e;
    // wire [4:0] rrExec, rrExecb, writeEn, writeEnctrl;

    procControl exectuteControls(romOutLatchDec,we_e,writeEnctrl,rrExec,rrExecb,sw_e,lw_e,muxIn2);
    assign writeEn = ovf2 ? 5'b11110 : writeEnctrl;
    // wire execMemOvf;  Mem Reg to store mem
    dffe_ref ovfDFFEE(.q(execMemOvf), .d(ovf2), .clk(~clock), .en(we_e), .clr(reset));
    //bex will become branch, unless pc = endCounts
    // wire bex; 
    assign bex = (romOutLatchDec[31] & ~romOutLatchDec[30] & romOutLatchDec[29] & romOutLatchDec[28] & ~romOutLatchDec[27]); 
    assign bexTarg[26:0] = romOutLatchDec[26:0];
    assign bexTarg[31:27] = 5'b0; 
    
    //Jal and Setx
    // wire xJal, xSetx;
    assign xSetx = romOutLatchDec[31] & ~romOutLatchDec[30] & romOutLatchDec[29] & ~romOutLatchDec[28] & romOutLatchDec[27];
    assign xJal = ~romOutLatchDec[31] & ~romOutLatchDec[30] & ~romOutLatchDec[29] & romOutLatchDec[28] & romOutLatchDec[27];
    // wire [31:0] execMemOut1, execMemOut2, signExtendTarg;
    assign signExtendTarg = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, romOutLatchDec[26:0]};
    assign execMemOut1 = xJal ? pcOutLatchDec : dataExecOut;
    assign execMemOut2 = xSetx ? signExtendTarg : execMemOut1;
    assign execMemOut = ovf2 ? writeOvf : execMemOut2;


    //BYP ctrl
    //rs1 is romOutLatchDec, rd is romExOut
    // wire bp_ctrl_1, bp_ctrl_2; 

    //rs1 is romOutLatchDec, rd is romMemOut
    assign bp_ctrl_1 = (rrExec == wr_m) & we_m & (wr_m != 5'b00000);
    assign bp_ctrl_2 = (rrExec == writeEnWW) & we_w &(writeEnWW != 5'b00000);

    //BYP for aluIn1, pick correct Val
    assign aluIn1BYP1 = bp_ctrl_2 ? data_writeReg : dataAout;
    assign aluIn1 = bp_ctrl_1 ? oExecOut: aluIn1BYP1;

    //control for BYP 2

        // wire bp_ctrl_1_b, bp_ctrl_2_b; 

    assign bp_ctrl_1_b = (rrExecb == wr_m) & we_m & (wr_m != 5'b00000);
    assign bp_ctrl_2_b = (rrExecb == writeEnWW) & we_w & (writeEnWW != 5'b00000);

    

    //add pc if branch

    // wire [31:0] pcLatchExec, pcLatchintoExec, pcBex;

    assign pcBex = bex ? bexTarg : branchPcAlu;
    assign pcLatchintoExec = branchTake ? pcBex : pcOutLatchDec;

    

    // wire [31:0] writeOvf, writeOvfAdd, writeOvfSub, execMemOut; 

    assign writeOvfAdd = addX ? 32'd1 : 32'd0;
    assign writeOvfSub = subX ? 32'b00000000000000000000000000000011 : writeOvfAdd;
    assign writeOvf = addiX ? 32'b00000000000000000000000000000010 : writeOvfSub;

    // wire addX, addiX, subX; 
    assign addX = (~romOutLatchDec[31] & ~romOutLatchDec[30] & ~romOutLatchDec[29] & ~romOutLatchDec[28] & ~romOutLatchDec[27]);

    assign addiX = (~romOutLatchDec[31] & ~romOutLatchDec[30] & romOutLatchDec[29] & ~romOutLatchDec[28] & romOutLatchDec[27]);
    assign subX = (~romOutLatchDec[31] & ~romOutLatchDec[30] & ~romOutLatchDec[29] & ~romOutLatchDec[28] & romOutLatchDec[27]);

    //also BYP for aluIn2
    assign aluIn2BYP1 = bp_ctrl_2_b? data_writeReg : dataBout;
    assign aluIn2BYP2 = bp_ctrl_1_b? oExecOut: aluIn2BYP1;
    assign aluIn2 = muxIn2 ? immVal: aluIn2BYP2;

    assign aluOpEx1 = muxIn2 ? 5'b0 : romOutLatchDec[6:2];

    assign is_branch = bne_ex | blt_ex |bex;
    assign bne_ex = (~romOutLatchDec[31] & ~romOutLatchDec[30] & ~romOutLatchDec[29] & romOutLatchDec[28] & ~romOutLatchDec[27]);
    assign blt_ex = (~romOutLatchDec[31] & ~romOutLatchDec[30] & romOutLatchDec[29] & romOutLatchDec[28] & ~romOutLatchDec[27]);

    assign aluOpEx = is_branch ? 5'b00001 : aluOpEx1;
    alu execute_instr(aluIn1, aluIn2, aluOpEx, romOutLatchDec[11:7], dataExecOut, isNotEqual2, isLessThan2, ovf2);

    alu take_branch_alu(pcOutLatchDec, immVal, 5'b00000, 5'b1, branchPcAlu, bne_alu, blt_alu, branch_overflow); 

    assign branchTake = (bne_ex & isNotEqual2) | (blt_ex & ~isLessThan2 & isNotEqual2) |(bex & isNotEqual2); 

    //Memory Latches and Stage -------------------------------------------------------------------------------------------------------------------------------------------
        // wire sw_instr, lw_instr; 

        // wire we_m, im_m;
        // wire [4:0] rra_m, rrb_m, wr_m, wr_m_ctrl;

    //Latches
    procReg oMemLatchObj(~clock, 1'b1, 1'b1, oMemOut, oExecOut, reset);
    procReg dMemLatchObj(~clock, 1'b1, 1'b1, dMemOut, q_dmem, reset);
    procReg romMemLatchObj(~clock, 1'b1, 1'b1, romMemOut, romExOut, reset);
    procReg pcMemlatchObj(~clock, 1'b1, 1'b1, pcMemLatch, pcLatchExec, reset);//pc_execute is input


    //Control to get memCodes
    procControl memCtrlObk(romExOut,we_m,wr_m_ctrl,rra_m,rrb_m,sw_instr,lw_instr,im_m);
        // wire[31:0] oMemOut, dMemOut, romMemOut;
    assign wren = sw_instr; //one if sw, 0 otherwise

    assign address_dmem = oExecOut; 

    assign memBYP = (rrb_m == writeEnWW) & we_w & (writeEnWW != 5'b00000);

    //reg b to dest register
    //bypass mux for data to be written in 

    assign data = memBYP ? data_writeReg : bExOut; 

    assign wr_m = execMemOvf ? 5'b11110 : wr_m_ctrl;
    dffe_ref mem_dffe(.q(memWBOvf), .d(execMemOvf), .clk(~clock), .en(we_m), .clr(reset));
    
    //Writeback stage and latches -------------------------------------------------------------------------------------------------------------------------------------------
        // wire [31:0] data_writeReg_1, data_writeReg_2, setxTarg, data_writeReg_3;
        // wire we_w, sw_w, lw_w, im_w, setx;
        // wire [4:0] rraW, rrbW, writeEnWW, ctrl_writeReg_1;
    
    //Get control out for mem Regs
    procControl wb_ctrl(romMemOut,we_w,writeEnWW, rraW,rrbW,sw_w,lw_w,im_w);

    assign ctrl_writeReg_1 = memWBOvf ? 5'b11110: writeEnWW;//get from ctrl module;
    assign ctrl_writeReg = data_resultRDY ? multDivWriteEn :ctrl_writeReg_1;

    assign data_writeReg_1 = lw_w ? dMemOut : oMemOut;
    
    //get opcode from execute stage
    // wire multX, divX; 
    //00110
    assign multX = (romOutLatchDec[31:27] == 5'b00000) && (romOutLatchDec[6:2] == 5'b00110);
    //00111
    assign divX = (romOutLatchDec[31:27] == 5'b00000) && (romOutLatchDec[6:2] == 5'b00111);

    // write Jal insn
    // wire wbJal;
    assign wbJal = (~romMemOut[31] & ~romMemOut[30] & ~romMemOut[29] & romMemOut[28] & romMemOut[27]);
    assign data_writeReg_2 = wbJal ? pcMemLatch : data_writeReg_1;
    assign data_writeReg_3 = setx ? setxTarg : data_writeReg_2;
    assign data_writeReg = data_resultRDY ? multdivOutLatched : data_writeReg_3;
    assign ctrl_writeEnable = we_w; //change to output of procControl;//1'b1; 
    
    //if jal, reg 31 if not reg 1
    
    //setx write to a target only if 31
    assign setx = (romMemOut[31] & ~romMemOut[30] & romMemOut[29] & ~romMemOut[28] & romMemOut[27]);
    assign setxTarg[26:0] = romMemOut[26:0];
    assign setxTarg[31:27] = 5'b0;


    //MULTDIV TESTING -------------------------------------------------------------------------------------------------------------------------------------------
    assign multDivSelect = multX | divX;
    dffe_ref mult_happening(.q(multDivInProg), .d(1'b1), .clk(clock), .en(multX || divX), .clr(data_resultRDY || reset));
    
    procReg ex_mult_instr(.clock(~clock), .input_enable(multDivSelect), .rdE(1'b1), .out(insnMultDiv), .in(romOutLatchDec), .clear(reset));
   
    multdiv multdivproc(.data_operandA(aluIn1), .data_operandB(aluIn2BYP2), .ctrl_MULT(multX), .ctrl_DIV(divX), .clock(clock), .data_result(multdivOutMem), .data_exception(md_exception), .data_resultRDY(data_resultRDY));
    procReg mult_div_latchout(.clock(~clock), .input_enable(data_resultRDY), .rdE(1'b1), .out(multdivOutLatched), .in(multdivOutMem), .clear(reset));

    assign multDivWriteEn = insnMultDiv[26:22];

    assign divExcp = divX & md_exception;
    assign multOvf = multX & md_exception;
	/* END CODE */

endmodule
