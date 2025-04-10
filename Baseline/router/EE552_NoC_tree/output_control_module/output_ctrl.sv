`timescale 1ns/1ps

import SystemVerilogCSP::*;

module output_ctrl #(
    parameter MASK = 3'b001,
    parameter WIDTH_packet = 14
) (
    interface in1,in2, out
);
    //parameter WIDTH_packet = 14
    parameter FL = 2, BL = 1;
    

    //Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) out();
    //Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) out2();
    
    arbiter_merge arb1(in1,in2,out);
    //arbiter_2to1 arb2(in3,in4,out2);
    //arbiter_2to1 final_out(out1,out2,out);
    initial begin
        $display("[%0t] output_ctrl instance started, MASK = %b", $time, MASK);
    end


endmodule