// ************************************************** PE packet orgnization *******************************************************
//             
//  Address    [5*FILTER_WIDTH+12:27]    [26:14]    [13:10]    [9]        [8]         [7:5]    [4:2]    [1:0]            
//             conv_loc                  residue    PE node    outspike   timestep    y-hop    x-hop    direction 
// ********************************************************************************************************************************

// ************************************************** ACK packet orgnization ******************************************************
//             
//  Address    [5*FILTER_WIDTH+12:13]    [12:9]    [8]       [7:5]    [4:2]    [1:0]            
//             0s                        PE node   ack(0)    y-hop    x-hop    direction 
// ********************************************************************************************************************************

`timescale 1ns/1ns

import SystemVerilogCSP::*;

module packetizer #(
    parameter FILTER_WIDTH  = 8,
    parameter OUTPUT_WIDTH  = 13,
    parameter FL	        = 2,
    parameter BL	        = 1,
    parameter DIRECTION_OUT = 0,
    parameter X_HOP_OUT     = 0,
    parameter Y_HOP_OUT     = 0,
    parameter PE_NODE       = 0,
    parameter X_HOP_ACK     = 0,
    parameter Y_HOP_ACK     = 0,
    parameter DIRECTION_ACK = 0
) (
    interface Timestep,  
    interface Residue, 
    interface Outspike,
    interface Conv_Loc,
    interface Packet
); 

    logic outspike;
    logic timestep;
    logic [1:0] direction_out = DIRECTION_OUT;
    logic [1:0] direction_ack = DIRECTION_ACK;
    logic [2:0] x_hop_out     = X_HOP_OUT;
    logic [2:0] y_hop_out     = Y_HOP_OUT;
    logic [2:0] x_hop_ack     = X_HOP_ACK;
    logic [2:0] y_hop_ack     = Y_HOP_ACK;
    logic [3:0] pe_node       = PE_NODE;
    logic [OUTPUT_WIDTH-1:0]    residue;
    logic [5*FILTER_WIDTH-15:0] conv_loc;
    logic [12+5*FILTER_WIDTH:0] packet_out;
    logic [12+5*FILTER_WIDTH:0] packet_ack;
    
    always begin
        fork
            Timestep.Receive(timestep);
            Residue.Receive(residue);
            Outspike.Receive(outspike);
            Conv_Loc.Receive(conv_loc);
        join
        // $display("Packetizer: Received timestep %b, residue %d, outspike %b, conv_loc %b", timestep, residue, outspike, conv_loc);
        #FL;
        
        packet_out = {conv_loc, residue, pe_node, outspike, timestep, y_hop_out, x_hop_out, direction_out};
        packet_ack = {{(5*FILTER_WIDTH){1'b0}}, pe_node, 1'b0, y_hop_ack, x_hop_ack, direction_ack};

        if (timestep == 1'b1) begin        
            Packet.Send(packet_out);
            #BL;
            Packet.Send(packet_ack);
            #BL;
        end else begin
            Packet.Send(packet_out);
            #BL;
        end
    end

endmodule
