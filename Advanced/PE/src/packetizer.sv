// ************************************************** packet orgnization *******************************************************************************************************
//             |         HEADER          |                        |                                            3*FILTER_WIDTH                                                  |
//  Address    [0:1]        [2:3]    [4]      [5]         [6:8]    [9]         [10:11]    [12:8+3*filter_width-output_width]    [9+3*filter_width-output_width:8+3*filter_width]    
//             direction    x-hop    y-hop    timestep    000      outspike    PE node    0s                                    residue  
// *****************************************************************************************************************************************************************************

`timescale 1ns/1ns
import SystemVerilogCSP::*;

module packetizer #(
    parameter FILTER_WIDTH = 8,
    parameter OUTPUT_WIDTH = 12,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter DIRECTION    = 0,
    parameter X_HOP        = 0,
    parameter Y_HOP        = 0,
    parameter PE_NODE      = 0 
) (
    interface  Timestep,  
    interface  Residue, 
    interface  Outspike,
    interface  Packet 
); 

    logic outspike;
    logic timestep;
    logic [1:0] direction = DIRECTION;
    logic [1:0] x_hop     = X_HOP;
    logic       y_hop     = Y_HOP;
    logic [1:0] pe_node   = PE_NODE;
    logic [OUTPUT_WIDTH-1:0]   residue;
    logic [8+3*FILTER_WIDTH:0] packet;
    
    always begin
        fork
            Timestep.Receive(timestep);
            Residue.Receive(residue);
            Outspike.Receive(outspike);
        join
        #FL;
        packet = {residue, {(3*FILTER_WIDTH-OUTPUT_WIDTH-3){1'b0}}, pe_node, outspike, 3'b000, timestep, y_hop, x_hop, direction};
        Packet.Send(packet);
        #BL;
    end

endmodule