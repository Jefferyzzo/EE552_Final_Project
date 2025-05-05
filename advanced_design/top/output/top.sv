`timescale 1ns/1ns
import SystemVerilogCSP::*;

/*TODO: 1.the width of each parameter
        2.control unit
        3.output memory
*/
module top#(
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_SIZE   = 25,
    parameter OUTPUT_WIDTH = 13,
    parameter THRESHOLD    = 64,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter ROW          = 4,
    parameter COL          = 4,
    parameter WIDTH        = 13 + 5*FILTER_WIDTH
    parameter Y_HOP_LOC    = 7,
    parameter X_HOP_LOC    = 4,
) (
    interface Packet_in,
    interface Packet_out
);

    // Declare Channels
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) PEi [0:15] ();
    Channel #(.WIDTH(WIDTH-(8)), .hsProtocol(P4PhaseBD)) PEo [0:15] (); 
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [0:19] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [0:19] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [0:19] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [0:19] ();

    // Dummy generators and buckets on edges
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W0 (.r(W2E[0]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E0 (.r(E2W[4]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W0 (.r(E2W[0]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E0 (.r(W2E[4]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W1 (.r(W2E[5]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E1 (.r(E2W[9]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W1 (.r(E2W[5]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E1 (.r(W2E[9]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W2 (.r(W2E[10]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E2 (.r(E2W[14]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W2 (.r(E2W[10]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E2 (.r(W2E[14]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W3 (.r(W2E[15]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E3 (.r(E2W[19]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W3 (.r(E2W[15]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E3 (.r(W2E[19]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N0 (.r(N2S[16]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S0 (.r(S2N[0]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N0 (.r(S2N[16]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S0 (.r(N2S[0]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N1 (.r(N2S[17]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S1 (.r(S2N[1]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N1 (.r(S2N[17]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S1 (.r(N2S[1]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N2 (.r(N2S[18]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S2 (.r(S2N[2]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N2 (.r(S2N[18]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S2 (.r(N2S[2]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N3 (.r(N2S[19]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S3 (.r(S2N[3]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N3 (.r(S2N[19]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S3 (.r(N2S[3]));
    
    // Router + PE per node


    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(0), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_0_0 (
        .Wi(W2E[0]),
        .Wo(E2W[0]),
        .Ei(E2W[1]),
        .Eo(W2E[1]),
        .Ni(N2S[4]),
        .No(S2N[4]),
        .Si(S2N[0]),
        .So(N2S[0]),
        .PEi(PEi[0]),
        .PEo(PEo[0])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b111),  
        .Y_HOP_OUT(3'b000),  
        .PE_NODE(0),
        .X_HOP_ACK(3'b000), 
        .Y_HOP_ACK(3'b111),
        .DIRECTION_ACK(0)
    ) pe0_0 (
        .Packet_in(PEo[0]),
        .Packet_out(PEi[0])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(1), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_0_1 (
        .Wi(W2E[1]),
        .Wo(E2W[1]),
        .Ei(E2W[2]),
        .Eo(W2E[2]),
        .Ni(N2S[5]),
        .No(S2N[5]),
        .Si(S2N[1]),
        .So(N2S[1]),
        .PEi(PEi[1]),
        .PEo(PEo[1])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b110),  
        .Y_HOP_OUT(3'b000),  
        .PE_NODE(1),
        .X_HOP_ACK(3'b100), 
        .Y_HOP_ACK(3'b111),
        .DIRECTION_ACK(0)
    ) pe0_1 (
        .Packet_in(PEo[1]),
        .Packet_out(PEi[1])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(2), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_0_2 (
        .Wi(W2E[2]),
        .Wo(E2W[2]),
        .Ei(E2W[3]),
        .Eo(W2E[3]),
        .Ni(N2S[6]),
        .No(S2N[6]),
        .Si(S2N[2]),
        .So(N2S[2]),
        .PEi(PEi[2]),
        .PEo(PEo[2])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b100),  
        .Y_HOP_OUT(3'b000),  
        .PE_NODE(2),
        .X_HOP_ACK(3'b110), 
        .Y_HOP_ACK(3'b111),
        .DIRECTION_ACK(0)
    ) pe0_2 (
        .Packet_in(PEo[2]),
        .Packet_out(PEi[2])
    );





    // Router (bottom right) - output to Packet_out
    // output port
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_PEi3 (.r(PEi[3]));
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(3), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_0_3 (
        .Wi(W2E[3]),
        .Wo(E2W[3]),
        .Ei(E2W[4]),
        .Eo(W2E[4]),
        .Ni(N2S[7]),
        .No(S2N[7]),
        .Si(S2N[3]),
        .So(N2S[3]),
        .PEi(PEi[3]),
        .PEo(Packet_out)
    );








    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(4), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_1_0 (
        .Wi(W2E[5]),
        .Wo(E2W[5]),
        .Ei(E2W[6]),
        .Eo(W2E[6]),
        .Ni(N2S[8]),
        .No(S2N[8]),
        .Si(S2N[4]),
        .So(N2S[4]),
        .PEi(PEi[4]),
        .PEo(PEo[4])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b111),  
        .Y_HOP_OUT(3'b100),  
        .PE_NODE(4),
        .X_HOP_ACK(3'b000), 
        .Y_HOP_ACK(3'b110),
        .DIRECTION_ACK(0)
    ) pe1_0 (
        .Packet_in(PEo[4]),
        .Packet_out(PEi[4])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(5), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_1_1 (
        .Wi(W2E[6]),
        .Wo(E2W[6]),
        .Ei(E2W[7]),
        .Eo(W2E[7]),
        .Ni(N2S[9]),
        .No(S2N[9]),
        .Si(S2N[5]),
        .So(N2S[5]),
        .PEi(PEi[5]),
        .PEo(PEo[5])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b110),  
        .Y_HOP_OUT(3'b100),  
        .PE_NODE(5),
        .X_HOP_ACK(3'b100), 
        .Y_HOP_ACK(3'b110),
        .DIRECTION_ACK(0)
    ) pe1_1 (
        .Packet_in(PEo[5]),
        .Packet_out(PEi[5])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(6), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_1_2 (
        .Wi(W2E[7]),
        .Wo(E2W[7]),
        .Ei(E2W[8]),
        .Eo(W2E[8]),
        .Ni(N2S[10]),
        .No(S2N[10]),
        .Si(S2N[6]),
        .So(N2S[6]),
        .PEi(PEi[6]),
        .PEo(PEo[6])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b100),  
        .Y_HOP_OUT(3'b100),  
        .PE_NODE(6),
        .X_HOP_ACK(3'b110), 
        .Y_HOP_ACK(3'b110),
        .DIRECTION_ACK(0)
    ) pe1_2 (
        .Packet_in(PEo[6]),
        .Packet_out(PEi[6])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(7), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_1_3 (
        .Wi(W2E[8]),
        .Wo(E2W[8]),
        .Ei(E2W[9]),
        .Eo(W2E[9]),
        .Ni(N2S[11]),
        .No(S2N[11]),
        .Si(S2N[7]),
        .So(N2S[7]),
        .PEi(PEi[7]),
        .PEo(PEo[7])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b000),  
        .Y_HOP_OUT(3'b100),  
        .PE_NODE(7),
        .X_HOP_ACK(3'b111), 
        .Y_HOP_ACK(3'b110),
        .DIRECTION_ACK(0)
    ) pe1_3 (
        .Packet_in(PEo[7]),
        .Packet_out(PEi[7])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(8), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_2_0 (
        .Wi(W2E[10]),
        .Wo(E2W[10]),
        .Ei(E2W[11]),
        .Eo(W2E[11]),
        .Ni(N2S[12]),
        .No(S2N[12]),
        .Si(S2N[8]),
        .So(N2S[8]),
        .PEi(PEi[8]),
        .PEo(PEo[8])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b111),  
        .Y_HOP_OUT(3'b110),  
        .PE_NODE(8),
        .X_HOP_ACK(3'b000), 
        .Y_HOP_ACK(3'b100),
        .DIRECTION_ACK(0)
    ) pe2_0 (
        .Packet_in(PEo[8]),
        .Packet_out(PEi[8])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(9), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_2_1 (
        .Wi(W2E[11]),
        .Wo(E2W[11]),
        .Ei(E2W[12]),
        .Eo(W2E[12]),
        .Ni(N2S[13]),
        .No(S2N[13]),
        .Si(S2N[9]),
        .So(N2S[9]),
        .PEi(PEi[9]),
        .PEo(PEo[9])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b110),  
        .Y_HOP_OUT(3'b110),  
        .PE_NODE(9),
        .X_HOP_ACK(3'b100), 
        .Y_HOP_ACK(3'b100),
        .DIRECTION_ACK(0)
    ) pe2_1 (
        .Packet_in(PEo[9]),
        .Packet_out(PEi[9])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(10), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_2_2 (
        .Wi(W2E[12]),
        .Wo(E2W[12]),
        .Ei(E2W[13]),
        .Eo(W2E[13]),
        .Ni(N2S[14]),
        .No(S2N[14]),
        .Si(S2N[10]),
        .So(N2S[10]),
        .PEi(PEi[10]),
        .PEo(PEo[10])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b100),  
        .Y_HOP_OUT(3'b110),  
        .PE_NODE(10),
        .X_HOP_ACK(3'b110), 
        .Y_HOP_ACK(3'b100),
        .DIRECTION_ACK(0)
    ) pe2_2 (
        .Packet_in(PEo[10]),
        .Packet_out(PEi[10])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(11), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_2_3 (
        .Wi(W2E[13]),
        .Wo(E2W[13]),
        .Ei(E2W[14]),
        .Eo(W2E[14]),
        .Ni(N2S[15]),
        .No(S2N[15]),
        .Si(S2N[11]),
        .So(N2S[11]),
        .PEi(PEi[11]),
        .PEo(PEo[11])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b000),  
        .Y_HOP_OUT(3'b110),  
        .PE_NODE(11),
        .X_HOP_ACK(3'b111), 
        .Y_HOP_ACK(3'b100),
        .DIRECTION_ACK(0)
    ) pe2_3 (
        .Packet_in(PEo[11]),
        .Packet_out(PEi[11])
    );





    // Router (right bottom) - input from Packet_in
    //control unit
    //************************************************************************************
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(12), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_3_0 (
        .Wi(W2E[15]),
        .Wo(E2W[15]),
        .Ei(E2W[16]),
        .Eo(W2E[16]),
        .Ni(Packet_in),
        .No(S2N[16]),
        .Si(S2N[12]),
        .So(N2S[12]),
        .PEi(PEi[12]),
        .PEo(PEo[12])
    );
    
    control_unit #(
        .FL(FL),
        .BL(BL)
    ) cu (
        .I(PEo[12]),
        .O(PEi[12])
    ); 





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(13), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_3_1 (
        .Wi(W2E[16]),
        .Wo(E2W[16]),
        .Ei(E2W[17]),
        .Eo(W2E[17]),
        .Ni(N2S[17]),
        .No(S2N[17]),
        .Si(S2N[13]),
        .So(N2S[13]),
        .PEi(PEi[13]),
        .PEo(PEo[13])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b110),  
        .Y_HOP_OUT(3'b111),  
        .PE_NODE(13),
        .X_HOP_ACK(3'b100), 
        .Y_HOP_ACK(3'b000),
        .DIRECTION_ACK(0)
    ) pe3_1 (
        .Packet_in(PEo[13]),
        .Packet_out(PEi[13])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(14), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_3_2 (
        .Wi(W2E[17]),
        .Wo(E2W[17]),
        .Ei(E2W[18]),
        .Eo(W2E[18]),
        .Ni(N2S[18]),
        .No(S2N[18]),
        .Si(S2N[14]),
        .So(N2S[14]),
        .PEi(PEi[14]),
        .PEo(PEo[14])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b100),  
        .Y_HOP_OUT(3'b111),  
        .PE_NODE(14),
        .X_HOP_ACK(3'b110), 
        .Y_HOP_ACK(3'b000),
        .DIRECTION_ACK(0)
    ) pe3_2 (
        .Packet_in(PEo[14]),
        .Packet_out(PEi[14])
    );





    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(15), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) router_3_3 (
        .Wi(W2E[18]),
        .Wo(E2W[18]),
        .Ei(E2W[19]),
        .Eo(W2E[19]),
        .Ni(N2S[19]),
        .No(S2N[19]),
        .Si(S2N[15]),
        .So(N2S[15]),
        .PEi(PEi[15]),
        .PEo(PEo[15])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT(3'b000),  
        .Y_HOP_OUT(3'b111),  
        .PE_NODE(15),
        .X_HOP_ACK(3'b111), 
        .Y_HOP_ACK(3'b000),
        .DIRECTION_ACK(0)
    ) pe3_3 (
        .Packet_in(PEo[15]),
        .Packet_out(PEi[15])
    );




endmodule
