`timescale 1ns/1ns

import SystemVerilogCSP::*;

module conditional_copy #(
    parameter WIDTH	= 4,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  Timestep,
    interface  R0,
    interface  R1    
); 

    logic [WIDTH-1:0] packet;
    logic timestep;
    always begin
        fork
    	    L.Receive(packet); 
            Timestep.Receive(timestep);
        join
        #FL;
        if(timestep==0) begin
            fork
                R0.Send(packet); 
                R1.Send(packet);
            join
        #BL;
        end else begin 
            R0.Send(packet);
        end
    end

endmodule