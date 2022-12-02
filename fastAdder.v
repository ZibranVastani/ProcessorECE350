module fastAdder(S,Cout,cOverflowOut,A,B,Cin);
    input[31:0] A,B;
    input Cin;
    output[31:0] S;
    output Cout,cOverflowOut;
    wire[3:0] Pout,Gout;
    wire [3:0] Cdead;
    wire [3:0] Ctransfer;
    wire wPC0,wP1G0,wP1P0C0,wP2G1,wP2P1G0,wP2P1P0C0,wP3G2,wP3P2G1,wP3P2P1G0,wP3P2P1P0C0;
    wire[3:0] CoverflowBus;
    //Block 0
    cla8 block0(S[7:0],Cdead[0],CoverflowBus[0],Gout[0],Pout[0],A[7:0],B[7:0],Cin);

    //Empty block after block 0 to get C8
    and PC0(wPC0,Pout[0],Cin);
    or C8(Ctransfer[0],Gout[0],wPC0);
    
    //Block 1
    cla8 block1(S[15:8],Cdead[1],CoverflowBus[1],Gout[1],Pout[1],A[15:8],B[15:8],Ctransfer[0]);

    //Empty block after block 1 to get C16
    and P1G0(wP1G0,Pout[1],Gout[0]);
    and P1P0C0(wP1P0C0,Pout[1],Pout[0],Cin);    
    or C16(Ctransfer[1],Gout[1],wP1G0,wP1P0C0);

    //Block 2
    cla8 block2(S[23:16],Cdead[2],CoverflowBus[2],Gout[2],Pout[2],A[23:16],B[23:16],Ctransfer[1]);

    //Empty block after block 2 to get C24
    and P2G1(wP2G1,Pout[2],Gout[1]);
    and P2P1G0(wP2P1G0,Pout[2],Pout[1],Gout[0]);
    and P2P1P0C0(wP2P1P0C0,Pout[2],Pout[1],Pout[0],Cin);
    or C24(Ctransfer[2],Gout[2],wP2G1,wP2P1G0,wP2P1P0C0);


    //Block 3
    cla8 block3(S[31:24],Cdead[3],CoverflowBus[3],Gout[3],Pout[3],A[31:24],B[31:24],Ctransfer[2]);

    //empty block after block 3 to get c32
    and P3G2(wP3G2,Pout[3],Gout[2]);
    and P3P2G1(wP3P2G1,Pout[3],Pout[2],Gout[1]);
    and P3P2P1G0(wP3P2P1G0,Pout[3],Pout[2],Pout[1],Gout[0]);
    and P3P2P1P0C0(wP3P2P1P0C0,Pout[3],Pout[2],Pout[1],Pout[0],Cin);
    or C32(Ctransfer[3],Gout[3],wP3G2,wP3P2G1,wP3P2P1G0,wP3P2P1P0C0);

    assign Cout = Ctransfer[3];

    assign cOverflowOut = CoverflowBus[3];

endmodule