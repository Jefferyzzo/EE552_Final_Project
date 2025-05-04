//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module arbiter_14in #(
parameter WIDTH	= 18 ,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L[13:0],
interface  R     
); 

Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb0_out();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb1_out();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb2_out();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb3_out();

arbiter_merge_4in #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb0 (
    .L0(L[0]),
    .L1(L[1]),
    .L2(L[2]),
    .L3(L[3]),
    .R(arb0_out)
);

arbiter_merge_4in #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb1 (
    .L0(L[4]),
    .L1(L[5]),
    .L2(L[6]),
    .L3(L[7]),
    .R(arb1_out)
);

arbiter_merge_4in #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb2 (
    .L0(L[8]),
    .L1(L[9]),
    .L2(L[10]),
    .L3(L[11]),
    .R(arb2_out)
);


arbiter_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb3 (
    .L0(L[12]),
    .L1(L[13]),
    .R(arb3_out)
);


arbiter_merge_4in #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb4 (
    .L0(arb0_out),
    .L1(arb1_out),
    .L2(arb2_out),
    .L3(arb3_out),
    .R(R)
);

endmodule