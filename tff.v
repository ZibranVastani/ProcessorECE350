module tff(q,t,clock,en,clr);
    input t,clock,en,clr;
    output q;

    wire wRgate, wLgate, wTgate;
    and Rgate(wRgate,~t,q);
    and Lgate(wLgate, t,~q);

    or Tgate(wTgate,wRgate,wLgate);

    //dffe_ref (q, d, clk, en, clr);
    dffe_ref pee(q,wTgate,clock,en,clr);
endmodule
