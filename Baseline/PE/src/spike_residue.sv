`timescale 1ns/1ns

import SystemVerilogCSP::*;

module spike_residue #(
    parameter FILTER_WIDTH	= 8,
    parameter THRESHOLD = 64,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L,
    interface  R0,
    interface  R1     
); 

    logic [FILTER_WIDTH-1:0] data;
    logic [5:0]              threshold = THRESHOLD;
    logic                    outspike;
    logic [FILTER_WIDTH-1:0] residue;
    always begin
        L.Receieve(data);
        if(data > threshold) begin
            outspike = 1;
            residue = data - threshold;
        end else begin
            outspike = 0;
            residue = data;
        end

        fork
            R0.Send(outspike);
            R1.Send(residue);
        join
    end

endmodule