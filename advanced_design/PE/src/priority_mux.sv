`timescale 1ns/1ns

import SystemVerilogCSP::*;

module priority_mux #(
    parameter WIDTH	= 8,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L0, // L0 has the highest priority
    interface  L1,
    interface  R     
); 

    logic [WIDTH-1:0] data, data_dummy;

    always begin
        wait((L0.status != idle) || (L1.status != idle));
        if (L0.status != idle) begin
            L0.Receive(data);
            // $display("%m L0 received data: %0h @ %t", data, $time);
            #FL; 
        end else begin
            L1.Receive(data);
            // $display("%m L1 received data: %0h @ %t", data, $time);
            #FL;
        end
        R.Send(data);
        // $display("%m R sent data: %0h @ %t", data, $time);
        #BL;
    end

endmodule