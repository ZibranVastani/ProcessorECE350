module fetchStage(pcOut, pcOutExe, branchTaken, address_imem, pc5, pcIn);
    input [31:0] pcOut, pcOutExe; //pcOutExe comes from execute stage
    input branchTaken;

    output [4:0] pc5;
    output[31:0] pcIn,address_imem;
    
    wire[31:0] pcPlus1;
    wire Cout,cOverflowOut;
    
    //Add 1
    //module fastAdder(S,Cout,cOverflowOut,A,B,Cin);
    fastAdder addOne(pcPlus1,Cout,cOverflowOut,pcOut,32'b0,1'b1);
    

    assign address_imem = pcOut;
    assign pc5 = pcOut[31:27];

    assign pcIn = branchTaken ? pcOutExe : pcPlus1;
endmodule