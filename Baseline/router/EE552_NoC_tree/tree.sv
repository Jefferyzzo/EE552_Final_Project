`timescale 1ns/1ps

import SystemVerilogCSP::*;

module tree #(
    parameter WIDTH_packet = 14,
    parameter FL = 2,
    parameter BL = 1
) (
    interface node1_lchild,node1_rchild,
    node2_parent, node2_lchild, node2_rchild,
    node3_parent, node3_lchild, node3_rchild,
    node4_parent, node4_lchild, node4_rchild,
    node5_parent, node5_lchild, node5_rchild,
    node6_parent, node6_lchild, node6_rchild,
);

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node1_1();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node1_2();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_1();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_2();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node2_3();//parent
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_1();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_2();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node3_3();//parent
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_1();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_2();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node4_3();//parent
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_1();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_2();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node5_3();//parent
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_1();//lchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_2();//rchild
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) node6_3();//parent

    router #(.MASK(100)) node1 (
        .child1(node1_1),
        .child2(node1_2),
        .parent()
    );

    router #(.MASK(010)) node2 (
        .child1(node2_1),
        .child2(node2_2),
        .parent(node2_3)
    );

    router #(.MASK(010)) node3 (
        .child1(node3_1),
        .child2(node3_2),
        .parent(node3_3)
    );

    router #(.MASK(001)) node4 (
        .child1(node4_1),
        .child2(node4_2),
        .parent(node4_3)
    );

    router #(.MASK(001)) node5 (
        .child1(node5_1),
        .child2(node5_2),
        .parent(node5_3)
    );

    router #(.MASK(001)) node6 (
        .child1(node6_1),
        .child2(node6_2),
        .parent(node6_3)
    );



    
endmodule