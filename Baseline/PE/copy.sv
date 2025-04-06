//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module copy #(
parameter WIDTH	= 4 ,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L    ,
interface  R0   ,
interface  R1    
); 

logic [WIDTH-1:0] packet;

always begin
	L.Receive(packet); 
	#FL;
    fork
        R0.Send(packet); 
        R1.Send(packet);
		#BL;
    join
end

endmodule