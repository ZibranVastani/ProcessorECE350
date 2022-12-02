module procReg(clock, input_enable, rdE, out, in, clear);
    input[31:0] in;
    input clock, clear,input_enable, rdE;

    output[31:0] out;
    

    genvar i;
    generate
        for(i = 0; i<32; i=i+1) begin: loop4
            dffe_ref a_dff(out[i],in[i],clock,input_enable,clear);
        end
    endgenerate
endmodule