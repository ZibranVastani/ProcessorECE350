module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB, threeOut
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB, threeOut;

	reg[31:0] registers[31:0];

	integer count;
	initial begin
		for (count=0; count<32; count=count+1)
			registers[count] <= 0;
	end

	integer i;
	always @(posedge clock or posedge ctrl_reset)
	begin
		if(ctrl_reset)
			begin
				for(i = 0; i < 32; i = i + 1)
					begin
						registers[i] <= 32'd0;
					end
			end
		else
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0)
				registers[ctrl_writeReg] <= data_writeReg;
	end
	
	assign data_readRegA = registers[ctrl_readRegA];
	assign data_readRegB = registers[ctrl_readRegB];
	assign threeOut = registers[3];
endmodule
