`timescale 1ns/1ns

import SystemVerilogCSP::*;
// L0 has the highest priority
module priority #(
    parameter WIDTH	= 8,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L0,
    interface  L1,
    interface  R     
); 

    logic [WIDTH-1:0] data;

    always begin
        if(L0.status != idle) begin
            #FL;
            L0.Receieve(data);
        end else begin
            #FL;
            L1.Receieve(data);
        end
        R.Send(data);
        #BL;
    end

endmodule