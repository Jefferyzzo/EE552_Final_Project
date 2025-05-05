`timescale 1ns/1ps
import SystemVerilogCSP::*;

module dummy_dg #(parameter WIDTH = 15) (interface r);
    // Dummy generator that does not send data
    initial forever begin
        // No transaction logic (idle)
        #10;
    end
endmodule

module dummy_db #(parameter WIDTH = 15) (interface r);
    // Dummy generator that does not send data
    initial forever begin
        // No transaction logic (idle)
        #10;
    end
endmodule


