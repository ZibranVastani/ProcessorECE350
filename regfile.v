module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire[31:0] wDecodedA, wDecodedB, wDecodedWE,wGateWE;
	wire [31:0] [31:0] wRegOutput;

	decoder_32 decodeA(wDecodedA,ctrl_readRegA,1'b1);
	decoder_32 decodeB(wDecodedB,ctrl_readRegB,1'b1);
	decoder_32 decodeWE(wDecodedWE, ctrl_writeReg,1'b1);


	// add your code here
	genvar i;
	generate
		for(i = 0; i<32; i=i+1) begin: loop1
			and GateWE(wGateWE[i],ctrl_writeEnable,wDecodedWE[i]);
			assign wGateWE[0] = 1'b0;
			singleRegister reg1(wRegOutput[i],data_writeReg,clock,ctrl_reset,wGateWE[i]);
		end
	endgenerate

	genvar j;
	generate
		for(j = 0; j<32; j=j+1) begin: loop2
			triBuf a_buffer(data_readRegA,wRegOutput[j],wDecodedA[j]);
			triBuf b_buffer(data_readRegB,wRegOutput[j],wDecodedB[j]);
		end
	endgenerate
endmodule
