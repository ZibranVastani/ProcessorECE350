module counter(count,t,clock,en,clr);
    input clock,en,clr,t;
    output[5:0] count;

    wire wZero1,wOne2,wTwo3,wThree4,wFour5;
    //tff(q,t,clock,en,clr);
    tff tOne(count[0],t,clock,en,clr);

    tff tTwo(count[1],count[0],clock,en,clr);
    and zero1(wZero1,count[1],count[0]);

    tff tFour(count[2],wZero1,clock,en,clr);
    and one2(wOne2,count[2],wZero1);

    tff tEight(count[3],wOne2,clock,en,clr);
    and two3(wTwo3,count[3],wOne2);

    tff tSixteen(count[4],wTwo3,clock,en,clr);
    and three4(wThree4,count[4],wTwo3);

    tff tThirtyTwo(count[5],wThree4,clock,en,clr);
    and four5(wFour5,count[5],wThree4);

endmodule