

`timescale 1ns/1ps
import SystemVerilogCSP::*;

module input_ctrl_tb;

    parameter WIDTH_packet = 14;

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
        .WIDTH_packet(WIDTH_packet),
        .MASK(3'b001)
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
        #1000;
        $display("*** Simulation ends ***");
        $stop;
    end

endmodule
