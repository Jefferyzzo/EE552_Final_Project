`timescale 1ns/1ns

import SystemVerilogCSP::*;

module token_buffer #(
    parameter FL = 2,
    parameter BL = 2,
    parameter WIDTH = 8,
    parameter INIT_VALUE = 0
    
) (
    interface l, 
    interface r
);

    logic [WIDTH-1:0] data;
    
    initial begin
        // $display("%m start sending a token at %t", $time);
        r.Send(INIT_VALUE);
        // $display("%m finish sending a token at %t", $time);
        #BL;
        forever begin
            l.Receive(data);
            #FL; 
            r.Send(data);
            #BL;
        end
    end
    
endmodule