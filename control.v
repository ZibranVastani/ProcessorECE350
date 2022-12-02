module control(plusOrMin,shift,ProdIn);
    input[63:0] ProdIn;
    output[1:0] plusOrMin; //00 Nothing, 01 minus, 10 plus
    output shift; // 0 no shift 1 shift
    wire[2:0] select;
    wire[1:0] w000PM,w001PM,w010PM,w011PM,w100PM,w101PM,w110PM,w111PM;
    wire w000S,w001S,w010S,w011S,w100S,w101S,w110S,w111S;

    //000 Case Do nothing
    assign w000PM = 2'b0;
    assign w000S = 1'b0;

    //001 Case add multiplicand
    assign w001PM = 2'b10;
    assign w001S = 1'b0;

    //010 Case add multiplicand
    assign w010PM = 2'b10;
    assign w010S = 1'b0;

    //011 Case add multiplicand<<1
    assign w011PM = 2'b10;
    assign w011S = 1'b1;

    //100 Case subtract multiplicand<<1
    assign w100PM = 2'b01;
    assign w100S = 1'b1;


    //101 Case Subract multiplicand
    assign w101PM = 2'b01;
    assign w101S = 1'b0;


    //110 Case subtract multiplicand
    assign w110PM = 2'b01;
    assign w110S = 1'b0;

    //111 Case
    assign w111PM = 2'b0;
    assign w111S = 1'b0;

    //Get last 3 bytes of data from product
    assign select[0] = ProdIn[0];
    assign select[1] = ProdIn[1];
    assign select[2] = ProdIn[2];

    //mux_8(out, select, in0, in1, in2, in3,in4,in5,in6,in7);
    mux_8twoBit plusMin(plusOrMin,select,w000PM,w001PM,w010PM,w011PM,w100PM,w101PM,w110PM,w111PM);
    mux_8oneBit shifter(shift,select,w000S,w001S,w010S,w011S,w100S,w101S,w110S,w111S);

endmodule