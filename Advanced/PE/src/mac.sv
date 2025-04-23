`timescale 1ns/1ns

import SystemVerilogCSP::*;

module mac #(
    parameter OUTPUT_WIDTH = 12, // TODO: change in M2
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_WIDTH  = 1,
    parameter FL	       = 2,
    parameter BL	       = 1 
) (
    interface  Filter_row1,
    interface  Filter_row2,
    interface  Filter_row3,
    interface  Filter_row4,
    interface  Filter_row5,
    interface  Ifmap,
    interface  Out    
); 


    logic [FILTER_WIDTH*5-1:0]  filter_row1;
    logic [FILTER_WIDTH*5-1:0]  filter_row2;
    logic [FILTER_WIDTH*5-1:0]  filter_row3;
    logic [FILTER_WIDTH*5-1:0]  filter_row4;
    logic [FILTER_WIDTH*5-1:0]  filter_row5;
    logic [25*IFMAP_WIDTH-1:0]  ifmap;
    logic [OUTPUT_WIDTH-1:0]    out;

    always begin
        fork 
            Filter_row1.Receive(filter_row1);
            Filter_row2.Receive(filter_row2);
            Filter_row3.Receive(filter_row3);
            Filter_row3.Receive(filter_row4);
            Filter_row2.Receive(filter_row5);
            Ifmap.Receive(ifmap);
        join
        // $display("Filter_row1: %h", filter_row1);
        // $display("Filter_row2: %h", filter_row2);
        // $display("Filter_row3: %h", filter_row3);
        // $display("Ifmap: %b", ifmap);
        #FL;

        // out = (ifmap[6] ? filter_row1[FILTER_WIDTH-1:0]                : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[7] ? filter_row1[2*FILTER_WIDTH-1:1*FILTER_WIDTH] : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[8] ? filter_row1[3*FILTER_WIDTH-1:2*FILTER_WIDTH] : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[3] ? filter_row2[FILTER_WIDTH-1:0]                : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[4] ? filter_row2[2*FILTER_WIDTH-1:1*FILTER_WIDTH] : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[5] ? filter_row2[3*FILTER_WIDTH-1:2*FILTER_WIDTH] : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[0] ? filter_row3[FILTER_WIDTH-1:0]                : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[1] ? filter_row3[2*FILTER_WIDTH-1:1*FILTER_WIDTH] : {(FILTER_WIDTH){1'b0}}) +
        //       (ifmap[2] ? filter_row3[3*FILTER_WIDTH-1:2*FILTER_WIDTH] : {(FILTER_WIDTH){1'b0}});

        out = (ifmap[20] ? filter_row1[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[21] ? filter_row1[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[22] ? filter_row1[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[23] ? filter_row1[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[24] ? filter_row1[FILTER_WIDTH*5-1:FILTER_WIDTH*4] : {(FILTER_WIDTH){1'b0}}) +
          
              (ifmap[15] ? filter_row2[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[16] ? filter_row2[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[17] ? filter_row2[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[18] ? filter_row2[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[19] ? filter_row2[FILTER_WIDTH*5-1:FILTER_WIDTH*4] : {(FILTER_WIDTH){1'b0}}) +
          
              (ifmap[10] ? filter_row3[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[11] ? filter_row3[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[12] ? filter_row3[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[13] ? filter_row3[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[14] ? filter_row3[FILTER_WIDTH*5-1:FILTER_WIDTH*4] : {(FILTER_WIDTH){1'b0}}) +
          
              (ifmap[5]  ? filter_row4[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[6]  ? filter_row4[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[7]  ? filter_row4[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[8]  ? filter_row4[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[9]  ? filter_row4[FILTER_WIDTH*5-1:FILTER_WIDTH*4] : {(FILTER_WIDTH){1'b0}}) +
           
              (ifmap[0]  ? filter_row5[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[1]  ? filter_row5[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[2]  ? filter_row5[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[3]  ? filter_row5[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +
              (ifmap[4]  ? filter_row5[FILTER_WIDTH*5-1:FILTER_WIDTH*4] : {(FILTER_WIDTH){1'b0}});
        #BL;
        Out.Send(out);

    end
    
endmodule
