`timescale 1ns/1ns

import SystemVerilogCSP::*;

module copy #(
    parameter WIDTH_packet = 28,

    parameter WIDTH	= 4,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  R0,
    interface  R1    
); 

    logic [WIDTH-1:0] packet;
    
    always begin
    	L.Receive(packet); 
    	#FL;
        fork
            R0.Send(packet); 
            R1.Send(packet);
        join
        #BL;
    end

endmodule