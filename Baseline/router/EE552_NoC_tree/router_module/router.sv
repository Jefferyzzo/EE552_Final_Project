`timescale 1ns/1ps
import SystemVerilogCSP::*;


 module router #(
    parameter WIDTH_packet = 14,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL = 2,
    parameter BL = 1,
    parameter MASK = 3'b110,
    parameter LEVEL = 0,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000
 ) (
   interface parent_in, parent_out,
    child1_in, child1_out,
    child2_in, child2_out 
 );

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) parent_child1();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) parent_child2();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child1_parent();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child1_child2();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child2_parent();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child2_child1();

    //logic [WIDTH_packet-1:0]
    //input output variables
    logic [WIDTH_packet-1:0] in_packet, out_packet;
    

    // input_ctrl #(.MASK(MASK)) pin(
    //     .in(parent_in),
    //     .out1(parent_child1),
    //     .out2(parent_child2)
    // );
    input_ctrl #(
        .WIDTH_packet(14),
        .WIDTH_dest(3),
        .WIDTH_addr(3),
        .FL(2),
        .BL(1),
        .MASK(3'b110),
        .LEVEL(2),
        .is_parent(1),
        .NUM_NODE(8),
        .ADDR(3'b000)
    ) pin (
        .in(parent_in),
        .out1(parent_child1),
        .out2(parent_child2)
    );

    output_ctrl #(.MASK(MASK)) pout(
        .in1(child2_parent),
        .in2(child1_parent),
        .out(parent_out)
    );

    // input_ctrl #(.MASK(MASK)) c1in(
    //     .in(child1_in),
    //     .out1(child1_parent),
    //     .out2(child1_child2)
    // );
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
    ) c1in (
        .in(child1_in),
        .out1(child1_parent),
        .out2(child1_child2)
    );

    output_ctrl #(.MASK(MASK)) c1out(
        .in1(parent_child1),
        .in2(child2_child1),
        .out(child1_out)
    );

    // input_ctrl #(.MASK(MASK)) c2in(
    //     .in(child2_in),
    //     .out1(child2_child1),
    //     .out2(child2_parent)
    // );
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
    ) c2in (
        .in(child2_in),
        .out1(child2_parent),
        .out2(child2_child1)
    );
    

    output_ctrl #(.MASK(MASK)) c2out(
        .in1(parent_child2),
        .in2(child1_child2),
        .out(child2_out)
    );
    initial begin
        $display("[%t] Router waiting for packet...", $time);
    end


    
  endmodule













