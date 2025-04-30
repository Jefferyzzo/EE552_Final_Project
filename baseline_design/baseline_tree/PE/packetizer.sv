// ************************************************** packet orgnization *******************************************************************************************************
//             |         HEADER          |                            |                                            3*FILTER_WIDTH                                                  |
//  Address       [2:0]        [5:3]            [6]           [7:9]       [10]           [11:12]     [13:9+3*filter_width-output_width]    [10+3*filter_width-output_width:9+3*filter_width]    
//                dest         addr            timestep        000       outspike         PE node          0s                                    residue  
// *****************************************************************************************************************************************************************************

`timescale 1ns/1ns
import SystemVerilogCSP::*;

module packetizer #(
    parameter FILTER_WIDTH = 8,
    parameter OUTPUT_WIDTH = 12,
    parameter IFMAP_SIZE   = 9,
    parameter THRESHOLD    = 16,

    parameter WIDTH_packet = 28,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL	       = 2,
    parameter BL	       = 1,


    parameter WIDTH = WIDTH_packet + WIDTH_addr +WIDTH_dest,
    parameter PE_NODE      = 0 
) (
    interface  Timestep,  
    interface  Residue, 
    interface  Outspike,
    //interface Packet_in,
    interface  Packet 
); 

    logic outspike;
    logic timestep;
    //logic [1:0] direction = DIRECTION;
    logic [WIDTH_dest-1:0] dest;
    logic [WIDTH_addr-1:0] addr;
    logic [WIDTH_addr-1:0] new_addr;
    logic [WIDTH_dest-1:0] new_dest;
    logic [1:0] pe_node   = PE_NODE;
    logic [OUTPUT_WIDTH-1:0]   residue;
    logic [9+3*FILTER_WIDTH:0] packet;
    
    always begin
        fork
            Timestep.Receive(timestep);
            Residue.Receive(residue);
            Outspike.Receive(outspike);
            //Packet_in.Receive(packet);
        join
        #FL;
                // Modify fields
        new_addr = PE_NODE + 1;       // New addr = previous dest
        new_dest = 3'b101;     // New dest = fixed 101
        packet = {residue, {(3*FILTER_WIDTH-OUTPUT_WIDTH-3){1'b0}}, pe_node, outspike, 3'b000, timestep, new_addr, new_dest};
        Packet.Send(packet);
        $display("!!!!!2PE (%m): Sent packet:%0d", packet);
        #BL;
    end

endmodule