`timescale 1ns/1ns
// TODO : How to arrange FL???
import SystemVerilogCSP::*;
// ************************************************** packet orgnization ***********************************************************************
//                |       HEADER          |                        |                                   3*FILTER_WIDTH                                       |
//  Address       [0:1]       [2:3]  [4]    [5]        [6:8]        [9]         [10:11]        [12:8+2*filter_width]      [9+2*filter_width:8+3*filter_width]    
//                direction   x-hop  y-hop  timestep   000          outspike    PE node         0s                          residue or 0s for timestep1  
// *********************************************************************************************************************************************
module packetizer #(
parameter FILTER_WIDTH	= 8 ,
parameter FL	= 2 ,
parameter BL	= 1 ,
parameter DIRECTION = 0,
parameter X_HOP = 0,
parameter Y_HOP = 0,
parameter PE_NODE = 0 
) (
interface  L0    ,  //timestep
interface  L1    , //residue
interface  L2    , //outspike
interface  R 
); 

    logic [8+3*FILTER_WIDTH:0] packet;
    logic [FILTER_WIDTH-1:0] residue;
    logic outspike;
    logic timestep;


    always begin
        L0.Receive(timestep);
        #FL;
        if (timestep=0) begin
            L2.Receive(outspike);
            packet = {'0,PE_NODE,outspike,4'b0000,Y_HOP,X_HOP,DIRECTION};
        end else begin
            fork
                L1.Receive(residue);
                L2.Receive(outspike);
            join
            packet = {residue,(2*FILTER_WIDTH-3){1b'0},PE_NODE,outspike,4'b0000,Y_HOP,X_HOP,DIRECTION};
        end
        R.Send(packet);
        #BL;
    end 
endmodule