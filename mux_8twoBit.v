module mux_8twoBit(out, select, in0, in1, in2, in3,in4,in5,in6,in7);
    input [2:0] select;
    input[1:0]  in0, in1, in2, in3, in4, in5, in6, in7;
    output[1:0]  out;
    wire[1:0]  w1, w2;
    mux_4twoBit first_top(w1, select[1:0], in0, in1, in2, in3);
    mux_4twoBit first_bottom(w2, select[1:0], in4, in5, in6, in7);
    mux_2twoBit second(out, select[2], w1, w2);
endmodule