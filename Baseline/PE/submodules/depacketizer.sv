`timescale 1ns/1ns

import SystemVerilogCSP::*;

module depacketizer #(
parameter WIDTH	= 28 ,
parameter DATA_WIDTH = 24;
parameter FL	= 2 ,
parameter BL	= 1 
) (
interface  L    ,
interface  R0   ,
interface  R1   ,
interface  R2   ,
interface  R3   
); 

logic [WIDTH-1:0] packet;
logic [DATA_WIDTH-1:0] data;
logic timestep;
logic ifmapb_filter; //0->ifmap; 1->filter
logic [1:0] filter_row;

always begin
	L.Receive(packet); 
	#FL;
    data=packet[DATA_WIDTH-1:0];
    timestep=packet[WIDTH-1];
    ifmapb_filter=packet[WIDTH-2];
    filter_row=packet[WIDTH-3:DATA_WIDTH];
    fork
        R0.Send(data);
        R1.Send(filter_row);
        R2.Send(ifmapb_filter);
        R3.Send(timestep);
    join
end

endmodule