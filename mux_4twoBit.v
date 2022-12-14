module mux_4twoBit(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input[1:0] in0, in1, in2, in3;
    output[1:0] out;
    wire[1:0] w1, w2;
    mux_2twoBit first_top(w1, select[0], in0, in1);
    mux_2twoBit first_bottom(w2, select[0], in2, in3);
    mux_2twoBit second(out, select[1], w1, w2);
endmodule