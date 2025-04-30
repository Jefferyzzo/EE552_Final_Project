`timescale 1ns/1ps

import SystemVerilogCSP::*;

module output_ctrl #(
    parameter WIDTH_packet = 14,
    parameter FL = 2, BL = 1
) (
    interface in1,in2, out
);
    //parameter WIDTH_packet = 14
    //parameter FL = 2, BL = 1;
    

    //Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) out();
    //Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) out2();
    
    arbiter_merge arb1(in1,in2,out);
    //arbiter_2to1 arb2(in3,in4,out2);
    //arbiter_2to1 final_out(out1,out2,out);
    initial begin
        $display("[%0t] output_ctrl instance started", $time);
        
            #1; // Wait a moment to allow status change detection

           //if (in1.status != idle)
                $display("[%0t] output_ctrl %m: packet arriving on in1", $time);
           //if (in2.status != idle)
                $display("[%0t] output_ctrl %m: packet arriving on in2", $time);
           // if (out.status != idle)
                $display("[%0t] output_ctrl %m: packet sent to out", $time);
        
    end


endmodule