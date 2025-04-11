`timescale 1ns/1ns

import SystemVerilogCSP::*;

module spike_residue #(
    parameter FILTER_WIDTH = 8,
    parameter THRESHOLD    = 64,
    parameter FL	       = 2,
    parameter BL	       = 1 
) (
    interface  L,
    interface  OutSpike,
    interface  Residue     
); 

    logic [FILTER_WIDTH-1:0] data;
    logic                    outspike;
    logic [FILTER_WIDTH-1:0] residue;

    always begin
        L.Receive(data);
        #FL;

        if (data > THRESHOLD) begin
            outspike = 1'b1;
            residue = data - THRESHOLD;
        end else begin
            outspike = 1'b0;
            residue = data;
        end

        fork
            OutSpike.Send(outspike);
            Residue.Send(residue);
        join
        #BL;
    end

endmodule