

`timescale 1ns/1ps
import SystemVerilogCSP::*;

module input_ctrl_tb #(
    parameter WIDTH_packet = 14,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL = 2,
    parameter BL = 1,
    parameter MASK = 3'b110,
    parameter LEVEL = 0,
    parameter is_parent = 0,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000
);

    //parameter WIDTH_packet = 14;

    // Channels
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R0();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R1();

    // CSPInterfaces
    // CSPInterface L  = new ch_gen_to_ctrl;
    // CSPInterface R0 = new ch_ctrl_to_r0;
    // CSPInterface R1 = new ch_ctrl_to_r1;

    // Instantiate input_ctrl DUT
    input_ctrl #(
        .WIDTH_packet(14),
        .WIDTH_dest(3),
        .WIDTH_addr(3),
        .FL(2),
        .BL(1),
        .MASK(3'b110),
        .LEVEL(2),
        .is_parent(0),
        .NUM_NODE(8),
        .ADDR(3'b000)
    ) dut (
        .in(L),
        .out1(R0),
        .out2(R1)
    );

    // Generator (sends 2 fixed packets)
    data_generator #(
        .WIDTH_packet(WIDTH_packet)
    ) gen (
        .r(L)
    );

    // Buckets (passively receive and print)
    data_bucket #(
        .WIDTH_packet(WIDTH_packet),
        .NODE(0)
    ) bucket0 (
        .r(R0)
    );

    data_bucket #(
        .WIDTH_packet(WIDTH_packet),
        .NODE(1)
    ) bucket1 (
        .r(R1)
    );

    // Simulation control
    initial begin
        $display("*** input_ctrl_tb simulation starts ***");
        #500;
        $display("*** Simulation ends ***");
        $stop;
    end

endmodule
