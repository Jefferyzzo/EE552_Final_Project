`timescale 1ns/1ns

import SystemVerilogCSP::*;

module mac #(
    parameter OUTPUT_WIDTH = 8,
    parameter FILTER_WIDTH = 72,
    parameter IFMAP_WIDTH  = 9,
    parameter FL	       = 2,
    parameter BL	       = 1 
) (
    interface  L0,
    interface  L1,
    interface  O     
); 

    logic [FILTER_WIDTH-1:0] filter;
    logic [IFMAP_WIDTH-1:0]  ifmap;
    logic [OUTPUT_WIDTH-1:0] output;

    always begin
        fork 
            L0.Receive(filter);
            L1.Receieve(ifmap);
        join
        #FL;
        output = (ifmap[0]? filter[ 7: 0]:16'd0) +
                 (ifmap[1]? filter[15: 8]:16'd0) +
                 (ifmap[2]? filter[23:16]:16'd0) +
                 (ifmap[3]? filter[31:24]:16'd0) +
                 (ifmap[4]? filter[39:32]:16'd0) +
                 (ifmap[5]? filter[47:40]:16'd0) +
                 (ifmap[6]? filter[55:48]:16'd0) +
                 (ifmap[7]? filter[63:56]:16'd0) +
                 (ifmap[8]? filter[71:64]:16'd0);
        #BL;
        O.Send(output);
    end
    
endmodule