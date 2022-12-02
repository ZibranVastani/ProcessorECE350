module cla8(S, Cout,overflowC,Gout,Pout, X,Y,Cin);
    input[7:0] X,Y;
    input Cin;
    output[7:0] S;
    output overflowC;
    output Cout, Gout, Pout;
    wire [7:0] C, G, P;
    wire wPC0,wP1PC0, wP1G0, wP2G1,wP3G2, wP2P1G0,wP2P1P0C0,wP3G3,wP3P2G1
         ,wP3P2P1G0,wP3P2P1P0C0,wP4G3,wP4P3G2,wP4P3P2G1,wP4P3P2P1G0,wP4P3P2P1P0C0
         ,wP5G4,wP5P4G3,wP5P4P3G2,wP5P4P3P2PG1,wP5P4P3P2P1G0,wP5P4P3P2P1P0C0
         ,wP6G5,wP6P5G4,wP6P5P4G3,wP6P5P4P3G2,wP6P5P4P3P2G1,wP6P5P4P3P2P1G0,wP6P5P4P3P2P1P0C0
         ,wP7G6,wP7P6G5,wP7P6P5G4,wP7P6P5P4G3,wP7P6P5P4P3G2,wP7P6P5P4P3P2G1,wP7P6P5P4P3P2P1G0,wP7P6P5P4P3P2P1P0C0,wP7P6P5P4P3P2P1P0;

    //CLA 1
    or x0_or_y0(P[0],X[0],Y[0]); //Create P0
    and x0_and_y0(G[0],X[0],Y[0]); //Create G0
    and p0_and_c0(wPC0,P[0],Cin);
    or C1(C[0],wPC0,G[0]); //Create C0
    xor S0(S[0],Cin,Y[0],X[0]); //Create S0

    //CLA 2
    or P1(P[1],X[1],Y[1]); //Create P1
    and G1(G[1],X[1],Y[1]); //Create G1
    and p1_and_c1(wP1PC0,Cin,P[0],P[1]); 
    and p1_and_g0(wP1G0,P[1],G[0]);
    or C2(C[1],wP1PC0,G[1],wP1G0); //Create C2
    xor S1(S[1],C[0],Y[1],X[1]); //Create S1

    // CLA 3
    or P2(P[2],X[2],Y[2]); //Create P2
    and G2(G[2],X[2],Y[2]); //Create G2
    and P2G1(wP2G1,P[2],G[1]);
    and P2P1G0(wP2P1G0,P[2],P[1],G[0]);
    and P2P1P0C0(wP2P1P0C0,P[2],P[1],P[0],Cin);
    or C3(C[2],wP2G1,wP2P1G0,wP2P1P0C0,G[2]); //Create C3
    xor S2(S[2],C[1],Y[2],X[2]);

    //CLA 4
    or P3(P[3],X[3],Y[3]); //Create P3
    and G3(G[3],X[3],Y[3]); //Create G3
    and P3G2(wP3G2,P[3],G[2]);
    and P3P2G1(wP3P2G1,P[3],P[2],G[1]);
    and P3P2P1G0(wP3P2P1G0,P[3],P[2],P[1],G[0]);
    and P3P2P1P0C0(wP3P2P1P0C0,P[3],P[2],P[1],P[0],Cin); 
    or C4(C[3],wP3G2,wP3P2G1,wP3P2P1G0,wP3P2P1P0C0,G[3]); //Create C4
    xor S3(S[3],C[2],Y[3],X[3]); //Create S3

    //CLA 5
    or P4(P[4],X[4],Y[4]); //Create P4
    and G4(G[4],X[4],Y[4]); //Create G4
    and P4G3(wP4G3,P[4],G[3]);
    and P4P3G2(wP4P3G2,P[4],P[3],G[2]);
    and P4P3P2G1(wP4P3P2G1,P[4],P[3],P[2],G[1]);
    and P4P3P2P1G0(wP4P3P2P1G0,P[4],P[3],P[2],P[1],G[0]);
    and P4P3P2P1P0C0(wP4P3P2P1P0C0,P[4],P[3],P[2],P[1],P[0],Cin);
    or C5(C[4],G[4],wP4G3,wP4P3G2,wP4P3P2G1,wP4P3P2P1G0,wP4P3P2P1P0C0); //Create C4
    xor S4(S[4],C[3],Y[4],X[4]); //Create S4

    //CLA 6
    or P5(P[5],X[5],Y[5]); //Create P5
    and G5(G[5],X[5],Y[5]); //Create G5
    and P5G4(wP5G4,P[5],G[4]);
    and P5P4G3(wP5P4G3,P[5],P[4],G[3]);
    and P5P4P3G2(wP5P4P3G2,P[5],P[4],P[3],G[2]);
    and P5P4P3P2PG1(wP5P4P3P2PG1,P[5],P[4],P[3],P[2],G[1]);
    and P5P4P3P2P1G0(wP5P4P3P2P1G0,P[5],P[4],P[3],P[2],P[1],G[0]);
    and P5P4P3P2P1P0C0(wP5P4P3P2P1P0C0,P[5],P[4],P[3],P[2],P[1],P[0],Cin);
    or C6(C[5],G[5],wP5G4,wP5P4G3,wP5P4P3G2,wP5P4P3P2PG1,wP5P4P3P2P1G0,wP5P4P3P2P1P0C0);
    xor S5(S[5],C[4],Y[5],X[5]);

    //CLA 7
    or P6(P[6],X[6],Y[6]); //Create P6
    and G6(G[6],X[6],Y[6]); //Create G6
    and P6G5(wP6G5,P[6],G[5]);
    and P6P5G4(wP6P5G4,P[6],P[5],G[4]);
    and P6P5P4G3(wP6P5P4G3,P[6],P[5],P[4],G[3]);
    and P6P5P4P3G2(wP6P5P4P3G2,P[6],P[5],P[4],P[3],G[2]);
    and P6P5P4P3P2G1(wP6P5P4P3P2G1,P[6],P[5],P[4],P[3],P[2],G[1]);
    and P6P5P4P3P2P1G0(wP6P5P4P3P2P1G0,P[6],P[5],P[4],P[3],P[2],P[1],G[0]);
    and P6P5P4P3P2P1P0C0(wP6P5P4P3P2P1P0C0,P[6],P[5],P[4],P[3],P[2],P[1],P[0],Cin);
    or C7(C[6],G[6],wP6G5,wP6P5G4,wP6P5P4G3,wP6P5P4P3G2,wP6P5P4P3P2G1,wP6P5P4P3P2P1G0,wP6P5P4P3P2P1P0C0);
    xor S6(S[6],C[5],Y[6],X[6]);

    //CLA 8
    or P7(P[7],X[7],Y[7]);
    and G7(G[7],X[7],Y[7]);
    and P7G6(wP7G6,P[7],G[6]);
    and P7P6G5(wP7P6G5,P[7],P[6],G[5]);
    and P7P6P5G4(wP7P6P5G4,P[7],P[6],P[5],G[4]);
    and P7P6P5P4G3(wP7P6P5P4G3,P[7],P[6],P[5],P[4],G[3]);
    and P7P6P5P4P3G2(wP7P6P5P4P3G2,P[7],P[6],P[5],P[4],P[3],G[2]);
    and P7P6P5P4P3P2G1(wP7P6P5P4P3P2G1,P[7],P[6],P[5],P[4],P[3],P[2],G[1]);
    and P7P6P5P4P3P2P1G0(wP7P6P5P4P3P2P1G0,P[7],P[6],P[5],P[4],P[3],P[2],P[1],G[0]);
    and P7P6P5P4P3P2P1P0C0(wP7P6P5P4P3P2P1P0C0,P[7],P[6],P[5],P[4],P[3],P[2],P[1],P[0],Cin);
    or C8(Cout,G[7],wP7G6,wP7P6G5,wP7P6P5G4,wP7P6P5P4G3,wP7P6P5P4P3G2,wP7P6P5P4P3P2G1,wP7P6P5P4P3P2P1G0,wP7P6P5P4P3P2P1P0C0);
    xor S7(S[7],C[6],Y[7],X[7]);


    //P and G calc
    and P7P6P5P4P3P2P1P0(wP7P6P5P4P3P2P1P0,P[7],P[6],P[5],P[4],P[3],P[2],P[1],P[0]);
    and PoutAnd(Pout,P[7],P[6],P[5],P[4],P[3],P[2],P[1],P[0]);
    or GoutOr(Gout,G[7],wP7G6,wP7P6G5,wP7P6P5G4,wP7P6P5P4G3,wP7P6P5P4P3G2,wP7P6P5P4P3P2G1,wP7P6P5P4P3P2P1G0);

    //Overflow
    xor Overflow(overflowC,C[6],Cout);

endmodule