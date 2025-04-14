`timescale 1ns/1ps

import SystemVerilogCSP::*;

module tree_tb #(
    parameter WIDTH_packet = 14,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL = 2,
    parameter BL = 1,
    parameter LEVEL = 1,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000,
    parameter IS_PARENT = 1
);

Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L0();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L1();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L2();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L3();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L4();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L5();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L6();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L7();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R0();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R1();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R2();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R3();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R4();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R5();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R6();
Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R7();


tree #(
    .WIDTH_packet(14),
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
data_generator #(
    .WIDTH_packet(WIDTH_packet)
) gen0 (
    .r(L0)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet)
) gen1 (
    .r(L1)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet)
) gen2 (
    .r(L2)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet)
) gen3 (
    .r(L3)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet),
    .SENDVALUE1(14'b01010111111110)
) gen4 (
    .r(L4)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet)
) gen5 (
    .r(L5)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet)

) gen6 (
    .r(L6)
);

data_generator #(
    .WIDTH_packet(WIDTH_packet) 
) gen7 (
    .r(L7)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket0 (
    .r(R0)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket1 (
    .r(R1)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket2 (
    .r(R2)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket3 (
    .r(R3)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket4 (
    .r(R4)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket5 (
    .r(R5)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket6 (
    .r(R6)
);

data_bucket #(
    .WIDTH_packet(WIDTH_packet),
    .NODE(1)
) bucket7 (
    .r(R7)
);

    // Simulation control
initial begin
    $display("*** input_ctrl_tb simulation starts ***");
    #500;
    $display("*** Simulation ends ***");
    $stop;
end






    
endmodule