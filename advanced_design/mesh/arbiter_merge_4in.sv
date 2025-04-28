//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module arbiter_merge_4in #(
parameter WIDTH	= 4 ,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L0   ,
interface  L1   ,
interface  L2   ,
interface  L3   ,
interface  R     
); 

Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb0_out();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb1_out();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) arb2_sel();

//Channel #(.WIDTH(1), .hsProtocol(P4PhaseBD)) merge_sel(); // Selection signal should be 1-bit

arbiter_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb0 (
    .L0(L0),
    .L1(L1),
    .R(arb0_out)
);

arbiter_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb1 (
    .L0(L2),
    .L1(L3),
    .R(arb1_out)
);

arbiter_merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) arb2 (
    .L0(arb0_out),
    .L1(arb1_out),
    .R(R)
);


endmodule