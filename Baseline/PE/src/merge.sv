`timescale 1ns/1ns

import SystemVerilogCSP::*;

module merge #(
    parameter WIDTH	= 8,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L0,
    interface  L1,
    interface  S,
    interface  R     
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