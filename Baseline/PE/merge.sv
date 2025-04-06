//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module merge #(
parameter WIDTH	= 4 ,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L0   ,//A in the diagram
interface  L1   ,//B in the diagram
interface  S    ,
interface  R     //O in the diagram
); 

logic [WIDTH-1:0] packet;
logic sel;


 always begin
 // *******************
        S.Receive(sel);
        if (sel == 0) begin
            L0.Receive(packet);
			#FL;
        end else begin
            L1.Receive(packet);
			#FL;
        end
        R.Send(packet);
		#BL;
    end
endmodule