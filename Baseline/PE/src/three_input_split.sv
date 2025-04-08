`timescale 1ns/1ns

import SystemVerilogCSP::*;

module three_input_split #(
    parameter FILTER_WIDTH	= 8,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  S,
    interface  R0, 
    interface  R1,
    interface  R2  
); 

    logic [3*FILTER_WIDTH-1:0] packet;
    logic [1:0] sel;
    
    always begin
        fork
            S.Receive(sel);
            L.Receive(packet);
        join
        #FL;
        if (sel == 2'b00) begin
            R0.Send(packet);
        end else if(sel == 2'b01)begin
            R1.Send(packet);
        end else if(sel == 2'b10) begin
            R2.Send(packet);
        end else begin
            $display("ERROR: Not defined sel signal!")
        end
    	#BL;
    end

endmodule