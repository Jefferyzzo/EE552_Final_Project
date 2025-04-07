`timescale 1ns/1ns

import SystemVerilogCSP::*;

module 2_input_adder #(
    parameter WIDTH	= 8,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L0,
    interface  L1,
    interface  R      
); 

    logic [WIDTH-1:0] in1;
    logic [WIDTH-1:0] in2;
    logic [WIDTH-1:0] out;
    
    always begin
        fork
            L0.Receive(in1);
            L1.Receive(in2);
        join
        #FL;
        out=in1+in2;
        R.Send(out);
    	#BL;
    end

endmodule