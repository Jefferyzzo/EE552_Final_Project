`timescale 1ns/1ns

import SystemVerilogCSP::*;

module split #(
parameter WIDTH	= 8 ,
parameter FL	= 2 ,
parameter BL	= 1 
) (
interface  L    ,
interface  S    ,
interface  R0   , 
interface  R1    
); 

logic [WIDTH-1:0] packet;
logic sel;


 always begin
    fork
        S.Receive(sel);
        L.Receive(packet);
    join
    #FL;
    if (sel == 0) begin
        R0.Send(packet);
    end else begin
        R1.Send(packet);
    end
	#BL;
end
endmodule