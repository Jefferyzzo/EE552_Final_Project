//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module arbiter_merge #(
parameter WIDTH_packet	= 14 ,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L0   ,
interface  L1   ,
interface  R     
); 

Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L0cp0();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L1cp0();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L0cp1();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L1cp1();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) winner();
//Channel #(.WIDTH(1), .hsProtocol(P4PhaseBD)) merge_sel(); // Selection signal should be 1-bit

copy #(.WIDTH_packet(WIDTH_packet), .FL(FL), .BL(BL)) copy_L0 (
    .L(L0),
    .R0(L0cp0),
    .R1(L0cp1)
);

copy #(.WIDTH_packet(WIDTH_packet), .FL(FL), .BL(BL)) copy_L1 (
    .L(L1),
    .R0(L1cp0),
    .R1(L1cp1)
);

// Instantiate Arbiter Module
arbiter #(.WIDTH_packet(WIDTH_packet), .FL(FL), .BL(BL)) arb (
    .L0(L0cp0), 
    .L1(L1cp0), 
    .W(winner)   // Selection signal for merge module
);

// Instantiate Merge Module
merge #(.WIDTH_packet(WIDTH_packet), .FL(FL), .BL(BL)) merge_inst (
    .L0(L0cp1), 
    .L1(L1cp1), 
    .S(winner), 
    .R(R)  // Final Output
);


endmodule