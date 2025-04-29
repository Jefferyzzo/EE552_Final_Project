`timescale 1ns/1ns

import SystemVerilogCSP::*;

module token_buffer #(
    parameter FL = 2,
    parameter BL = 2,
    parameter WIDTH = 8,
    parameter INIT_VALUE = 0
    
) (
    interface left, 
    interface right
);

    logic [WIDTH-1:0] data;
    
    initial begin
        right.Send(INIT_VALUE);
        #BL;
        forever begin
            left.Receive(data);
            #FL; 
            right.Send(data);
            #BL;
        end
    end
    
endmodule