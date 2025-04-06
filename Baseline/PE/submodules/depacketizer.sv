`timescale 1ns/1ns

import SystemVerilogCSP::*;
// ************************************************** content orgnization **************************************************
//  Address       [0]         [1]                    [2:3]          [4:3*filter_width+3] 
//                timestep    ifmapb_filter          filter_row     3*fliter_width
// *************************************************************************************************************************
module depacketizer #(
parameter FILTER_WIDTH	= 8 , //default is 8 bits
parameter FL	= 2 ,
parameter BL	= 1 
) (
interface  L    ,
interface  R0   ,
interface  R1   ,
interface  R2   ,
interface  R3   
); 

logic [3*FILTER_WIDTH+3:0] packet;
logic [3*FILTER_WIDTH-1:0] data;
logic timestep;
logic ifmapb_filter; //0->ifmap; 1->filter
logic [1:0] filter_row;

always begin
	L.Receive(packet); 
	#FL;
    data=packet[3*FILTER_WIDTH+3:4];
    timestep=packet[0];
    ifmapb_filter=packet[1];
    filter_row=packet[2:3];
    fork
        R0.Send(data);
        R1.Send(filter_row);
        R2.Send(ifmapb_filter);
        R3.Send(timestep);
    join
end

endmodule