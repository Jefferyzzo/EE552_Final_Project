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
    interface  L2,
    interface  L3,
    interface  O     
); 


    logic [FILTER_WIDTH*3-1:0] filter_row1;
    logic [FILTER_WIDTH*3-1:0] filter_row2;
    logic [FILTER_WIDTH*3-1:0] filter_row3;
    logic [9*IFMAP_WIDTH-1:0]  ifmap;
    logic [OUTPUT_WIDTH-1:0] output;

    always begin
        fork 
            L0.Receive(filter_row1);
            L1.Receive(filter_row2);
            L2.Receive(filter_row3);
            L3.Receieve(ifmap);
        join
        #FL;

        output = (ifmap[0]? filter_row1[FILTER_WIDTH-1: 0]:16'd0) +
                 (ifmap[1]? filter_row1[2*FILTER_WIDTH-1:1*FILTER_WIDTH]:16'd0) +
                 (ifmap[2]? filter_row1[3*FILTER_WIDTH-1:2*FILTER_WIDTH]:16'd0) +
                 (ifmap[3]? filter_row2[FILTER_WIDTH-1: 0]:16'd0) +
                 (ifmap[4]? filter_row2[2*FILTER_WIDTH-1:1*FILTER_WIDTH]:16'd0) +
                 (ifmap[5]? filter_row2[3*FILTER_WIDTH-1:2*FILTER_WIDTH]:16'd0) +
                 (ifmap[6]? filter_row3[FILTER_WIDTH-1: 0]:16'd0) +
                 (ifmap[7]? filter_row3[2*FILTER_WIDTH-1:1*FILTER_WIDTH]:16'd0) +
                 (ifmap[8]? filter_row3[3*FILTER_WIDTH-1:2*FILTER_WIDTH]:16'd0);
        #BL;
        O.Send(output);
    end
    
endmodule
