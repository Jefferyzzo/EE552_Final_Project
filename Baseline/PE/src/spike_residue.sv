`timescale 1ns/1ns

import SystemVerilogCSP::*;

module spike_residue #(
    parameter FILTER_WIDTH	= 8,
    parameter THRESHOLD = 63,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  R0,
    interface  R1     
); 

    logic [FILTER_WIDTH-1:0] data;

     always begin
        L.Receieve(data);
        
    end

endmodule