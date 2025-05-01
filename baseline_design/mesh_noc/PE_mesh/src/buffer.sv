`timescale 1ns/1ns

import SystemVerilogCSP::*;

module buffer #(
    parameter FL = 2,
    parameter BL = 1,
    parameter WIDTH = 8
) (
    interface left, 
    interface right
);

    logic [WIDTH-1:0] data;
    
    always begin
        left.Receive(data);
        #FL; 
        right.Send(data);
        #BL;
    end
    
endmodule