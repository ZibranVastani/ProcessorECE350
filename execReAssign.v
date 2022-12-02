module execReAssign (immVal,romOutLatchDec);
    input[31:0] romOutLatchDec;
    output[31:0] immVal;

    assign immVal[16:0] = romOutLatchDec[16:0];
    assign immVal[31] = romOutLatchDec[16];
    assign immVal[30] = romOutLatchDec[16];
    assign immVal[29] = romOutLatchDec[16];
    assign immVal[28] = romOutLatchDec[16];
    assign immVal[27] = romOutLatchDec[16];
    assign immVal[26] = romOutLatchDec[16];
    assign immVal[25] = romOutLatchDec[16];
    assign immVal[24] = romOutLatchDec[16];
    assign immVal[23] = romOutLatchDec[16];
    assign immVal[22] = romOutLatchDec[16];
    assign immVal[21] = romOutLatchDec[16];
    assign immVal[20] = romOutLatchDec[16];
    assign immVal[19] = romOutLatchDec[16];
    assign immVal[18] = romOutLatchDec[16];
    assign immVal[17] = romOutLatchDec[16];
endmodule