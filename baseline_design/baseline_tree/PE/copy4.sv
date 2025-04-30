`timescale 1ns/1ns

import SystemVerilogCSP::*;

module copy4 #(
    parameter WIDTH	= 4,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  R0,
    interface  R1,
    interface  R2,
    interface  R3 
); 

    logic [WIDTH-1:0] packet;
    
    always begin
    	L.Receive(packet); 
    	#FL;
        fork
            R0.Send(packet); 
            R1.Send(packet);
            R2.Send(packet);
            R3.Send(packet);
        join
        #BL;
    end

endmodule