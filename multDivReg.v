module multDivReg(out,in,clock,clear,input_enable);
    input[64:0] in; //65 bit input
    input clock, clear,input_enable;

    output[64:0] out; //65 bit input
    

    genvar i;
    generate
        for(i = 0; i<65; i=i+1) begin: loop4
            dffe_ref a_dff(out[i],in[i],clock,input_enable,clear);
        end
    endgenerate
endmodule