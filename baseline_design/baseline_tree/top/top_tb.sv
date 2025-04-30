`timescale 1ns/1ps

import SystemVerilogCSP::*;

module top_tb #(
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_SIZE   = 9,
    parameter OUTPUT_WIDTH = 12,
    parameter THRESHOLD    = 16,
    parameter WIDTH_packet = 28,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest, 
    parameter FL = 2,
    parameter BL = 1,
    parameter LEVEL = 1,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000,
    parameter IS_PARENT = 1
);

Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L0();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L1();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L2();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L3();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L4();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L5();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L6();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) L7();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R0();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R1();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R2();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R3();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R4();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R5();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R6();
Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) R7();


tree #(
    .WIDTH_packet(28),
    .WIDTH_dest(3),
    .WIDTH_addr(3),
    .FL(2),
    .BL(1),//MASK shouldn't exist
    .LEVEL(1),
    .NUM_NODE(8)
) dut (
    .PE0_in(L0),
    .PE0_out(R0),
    .PE1_in(L1),
    .PE1_out(R1),
    .PE2_in(L2),
    .PE2_out(R2),
    .PE3_in(L3),
    .PE3_out(R3),
    .PE4_in(L4),
    .PE4_out(R4),
    .PE5_in(L5),
    .PE5_out(R5),
    .PE6_in(L6),
    .PE6_out(R6),
    .PE7_in(L7),
    .PE7_out(R7)
);

    // Generator (sends 2 fixed packets)
input_buffer #(
    .WIDTH_packet(28),
    .WIDTH_addr(3),
    .WIDTH_dest(3),
    .NUM_PACKETS(20)  //pe3->pe7
) inbuf (
    .r(L0)
);

PE #(
    .FILTER_WIDTH(FILTER_WIDTH),
    .IFMAP_SIZE(IFMAP_SIZE),
    .OUTPUT_WIDTH(OUTPUT_WIDTH),
    .THRESHOLD(16),
    .FL(FL),
    .BL(BL),
    .PE_NODE(1)
) pe1 (
    .Packet_in(R1), 
    .Packet_out(L1)
);

// dummy #(
//     .WIDTH_packet(28),
//     .WIDTH_addr(3),
//     .WIDTH_dest(3)
// ) dum1 (
//     .l(R1),
//     .r(L1)
// );

// dummy #(
//     .WIDTH_packet(28),
//     .WIDTH_addr(3),
//     .WIDTH_dest(3)
// ) dum2 (
//     .l(R2),
//     .r(L2)
// );
PE #(
    .FILTER_WIDTH(FILTER_WIDTH),
    .IFMAP_SIZE(IFMAP_SIZE),
    .OUTPUT_WIDTH(OUTPUT_WIDTH),
    .THRESHOLD(16),
    .FL(FL),
    .BL(BL),
    .PE_NODE(1)
) pe2 (
    .Packet_in(R2), 
    .Packet_out(L2)
);

PE #(
    .FILTER_WIDTH(FILTER_WIDTH),
    .IFMAP_SIZE(IFMAP_SIZE),
    .OUTPUT_WIDTH(OUTPUT_WIDTH),
    .THRESHOLD(16),
    .FL(FL),
    .BL(BL),
    .PE_NODE(1)
) pe3 (
    .Packet_in(R3), 
    .Packet_out(L3)
);

PE #(
    .FILTER_WIDTH(FILTER_WIDTH),
    .IFMAP_SIZE(IFMAP_SIZE),
    .OUTPUT_WIDTH(OUTPUT_WIDTH),
    .THRESHOLD(16),
    .FL(FL),
    .BL(BL),
    .PE_NODE(1)
) pe4 (
    .Packet_in(R4), 
    .Packet_out(L4)
);
// dummy #(
//     .WIDTH_packet(28),
//     .WIDTH_addr(3),
//     .WIDTH_dest(3)
// ) dum3 (
//     .l(R3),
//     .r(L3)
// );
// dummy #(
//     .WIDTH_packet(28),
//     .WIDTH_addr(3),
//     .WIDTH_dest(3)
// ) dum4 (
//     .l(R4),
//     .r(L4)
// );

output_buffer #(
    .WIDTH_packet(28),
    .WIDTH_addr(3),
    .WIDTH_dest(3),
    .NUM_PACKETS(20)  //pe3->pe7
) outbuf (
    .l(R5)
);







    // Simulation control
initial begin
    $display("*** tree simulation starts ***");
    #2000;
    $display("*** Simulation ends ***");
    $stop;
end






    
endmodule