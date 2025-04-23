`timescale 1ns/1ns

import SystemVerilogCSP::*;

module copy #(
    parameter WIDTH	= 4,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  R0,
    interface  R1    
); 

    logic [WIDTH-1:0] packet;
    initial begin
        fork
            R0.Send((WIDTH){1'b0});
            R1.Send((WIDTH){1'b0});
        join
    end
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