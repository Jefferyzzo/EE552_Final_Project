`timescale 1ns/1ps

import SystemVerilogCSP::*;

module tree #(
    parameter WIDTH_packet = 14,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL = 2,
    parameter BL = 1,
    parameter LEVEL = 1,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000,
    parameter IS_PARENT = 1
) (
    interface PE0_in,PE0_out,
    PE1_in,PE1_out,
    PE2_in,PE2_out,
    PE3_in,PE3_out,
    PE4_in,PE4_out,
    PE5_in,PE5_out,
    PE6_in,PE6_out,
    PE7_in,PE7_out
);

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node1_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node1_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node1_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node1_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node7_1_in();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node7_1_out();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node7_2_in();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node7_2_out();//rchild

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) empty[1:0]();//rchild




    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(0)
    ) node1 (
        .parent_in(empty[0]),
        .parent_out(empty[1]),
        .child1_in(node1_1_in),
        .child1_out(node1_1_out),
        .child2_in(node1_2_in),
        .child2_out(node1_2_out)

    );

    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(1)
    ) node2 (
        .parent_in(node1_1_out),
        .parent_out(node1_1_in),
        .child1_in(node2_1_in),
        .child1_out(node2_1_out),
        .child2_in(node2_2_in),
        .child2_out(node2_2_out)

    );

    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(1)
    ) node3 (
        .parent_in(node1_2_out),
        .parent_out(node1_2_in),
        .child1_in(node3_1_in),
        .child1_out(node3_1_out),
        .child2_in(node3_2_in),
        .child2_out(node3_2_out)

    );

    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(2)
    ) node4 (
        .parent_in(node2_1_out),
        .parent_out(node2_1_in),
        .child1_in(PE0_in),
        .child1_out(PE0_out),
        .child2_in(PE1_in),
        .child2_out(PE1_out)

    );

    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(2)
    ) node5 (
        .parent_in(node2_2_out),
        .parent_out(node2_2_in),
        .child1_in(PE2_in),
        .child1_out(PE2_out),
        .child2_in(PE3_in),
        .child2_out(PE3_out)

    );

    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(2)
    ) node6 (
        .parent_in(node3_1_out),
        .parent_out(node3_1_in),
        .child1_in(PE4_in),
        .child1_out(PE4_out),
        .child2_in(PE5_in),
        .child2_out(PE5_out)

    );

    router #(
        .WIDTH_packet(WIDTH_packet),
        .WIDTH_dest(WIDTH_dest),
        .WIDTH_addr(WIDTH_addr),
        .FL(FL),
        .BL(BL),
        .LEVEL(2)
    ) node7 (
        .parent_in(node3_2_out),
        .parent_out(node3_2_in),
        .child1_in(PE6_in),
        .child1_out(PE6_out),
        .child2_in(PE7_in),
        .child2_out(PE7_out)

    );







    
endmodule