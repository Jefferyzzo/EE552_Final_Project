`timescale 1ns/1ns
// TODO : How to arrange FL???
import SystemVerilogCSP::*;
// ************************************************** packet orgnization **************************************************
//  Address       [31:30]     [29]   [28]   [27]        [26:24]      [23]         [22:8]      [7:0]    
//                direction   x-hop  y-hop  timestep    000          outspike     0*          residue or 0s for timestep1  
// *************************************************************************************************************************
module packetizer #(
parameter WIDTH	= 8 ,
parameter PACKET_WIDTH = 32; 
parameter FL	= 2 ,
parameter BL	= 1 ,
parameter DIRECTION = 0,
parameter X_HOP = 0,
parameter Y_HOP = 0;
) (
interface  L0    ,  //timestep
interface  L1    , //residue
interface  L2    , //outspike
interface  R 
); 

    logic [PACKET_WIDTH-1:0] packet;
    logic [WIDTH-1:0] residue;
    logic outspike;
    logic timestep;


    always begin
        L0.Receive(timestep);
        #FL;
        if (timestep=0) begin
            L2.Receive(outspike);
            packet = {DIRECTION, X_HOP, Y_HOP, 4'd0, outspike, 23'd0};
        end else begin
            L1.Receive(residue);
            L2.Receive(outspike);
            packet = {DIRECTION, X_HOP, Y_HOP, 1'b1, 3'd0, outspike, 15'd0, residue};
        end
        R.Send(packet);
        #BL;
    end 
endmodule