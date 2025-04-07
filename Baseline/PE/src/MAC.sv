`timescale 1ns/1ns


import SystemVerilogCSP::*;

module mac #(
    parameter OUTPUT_WIDTH = 8,
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_WIDTH  = 1,
    parameter FL	       = 2,
    parameter BL	       = 1 
) (
    interface  L0,
    interface  L1,
    interface  O     
); 

    logic [FILTER_WIDTH*9-1:0] filter;
    logic [9*IFMAP_WIDTH-1:0]  ifmap;
    logic [OUTPUT_WIDTH-1:0] output;

    always begin
        fork 
            L0.Receive(filter);
            L1.Receieve(ifmap);
        join
        #FL;

        output = (ifmap[0]? filter[FILTER_WIDTH-1: 0]:16'd0) +
                 (ifmap[1]? filter[2*FILTER_WIDTH-1:1*FILTER_WIDTH]:16'd0) +
                 (ifmap[2]? filter[3*FILTER_WIDTH-1:2*FILTER_WIDTH]:16'd0) +
                 (ifmap[3]? filter[4*FILTER_WIDTH-1:3*FILTER_WIDTH]:16'd0) +
                 (ifmap[4]? filter[5*FILTER_WIDTH-1:4*FILTER_WIDTH]:16'd0) +
                 (ifmap[5]? filter[6*FILTER_WIDTH-1:5*FILTER_WIDTH]:16'd0) +
                 (ifmap[6]? filter[7*FILTER_WIDTH-1:6*FILTER_WIDTH]:16'd0) +
                 (ifmap[7]? filter[8*FILTER_WIDTH-1:7*FILTER_WIDTH]:16'd0) +
                 (ifmap[8]? filter[9*FILTER_WIDTH-1:8*FILTER_WIDTH]:16'd0);
        #BL;
        O.Send(output);
    end
    
endmodule
