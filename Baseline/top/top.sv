module top #(
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_SIZE   = 9,
    parameter OUTPUT_WIDTH = 12,
    parameter THRESHOLD    = 64,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter ROW          = 2,
    parameter COL          = 3
) (
    interface Packet_in, 
    interface Packet_out
);

    Channel #(.WIDTH(9+3*FILTER_WIDTH), .hsProtocol(P4PhaseBD)) PEi [0:ROW-1][0:COL-1] ();
    Channel #(.WIDTH(9+3*FILTER_WIDTH-(4+1)), .hsProtocol(P4PhaseBD)) PEo [0:ROW-1][0:COL-1] ();

    mesh #(
        .WIDTH(9+3*FILTER_WIDTH), // packet size
        .FL(FL),
        .BL(BL),
        .ROW(ROW),
        .COL(COL),
        .X_HOP_LOC(3),
        .Y_HOP_LOC(4)
    ) (
        .PEi(PEi),
        .PEo(PEo)
    );

    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION(3), // SE
        .X_HOP(2'b10),
        .Y_HOP(1'b1),
        .PE_NODE(0)
    ) pe0 (
        .Packet_in(PEo[1][1]), 
        .Packet_out(PEi[1][1])
    );

    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION(3), // SE
        .X_HOP(2'b00),
        .Y_HOP(1'b1),
        .PE_NODE(1)
    ) pe1 (
        .Packet_in(PEo[1][2]), 
        .Packet_out(PEi[1][2])
    );

    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION(3), // SE
        .X_HOP(2'b11),
        .Y_HOP(1'b0),
        .PE_NODE(2)
    ) pe2 (
        .Packet_in(PEo[0][0]), 
        .Packet_out(PEi[0][0])
    );

    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION(3), // SE
        .X_HOP(2'b10),
        .Y_HOP(1'b0),
        .PE_NODE(3)
    ) pe3 (
        .Packet_in(PEo[0][1]), 
        .Packet_out(PEi[0][1])
    );

    buffer #(
        .FL(FL),
        .BL(BL),
        .WIDTH(9+3*FILTER_WIDTH) // packet size
    ) buffer_in (
        .left(Packet_in), 
        .right(PEi[1][0])
    );

    buffer #(
        .FL(FL),
        .BL(BL),
        .WIDTH(9+3*FILTER_WIDTH) // packet size
    ) buffer_out (
        .left(PEo[0][2]), 
        .right(Packet_out)
    );

endmodule