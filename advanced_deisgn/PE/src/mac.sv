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
    interface  Size,
    interface  Out    
); 

    logic [FILTER_WIDTH*5-1:0] filter_row1;
    logic [FILTER_WIDTH*5-1:0] filter_row2;
    logic [FILTER_WIDTH*5-1:0] filter_row3;
    logic [FILTER_WIDTH*5-1:0] filter_row4;
    logic [FILTER_WIDTH*5-1:0] filter_row5;
    logic [25*IFMAP_WIDTH-1:0] ifmap;
    logic [1:0]                size;
    logic [OUTPUT_WIDTH-1:0]   out;

    always begin
        Size.Receive(size);
        #FL;
        // $display("%m Received Size: %d @ %t", size, $time);

        case (size)
            2'b00: begin // 2x2
                fork 
                    Filter_row1.Receive(filter_row1);
                    Filter_row2.Receive(filter_row2);
                    filter_row3 = {(5*FILTER_WIDTH){1'b0}};
                    filter_row4 = {(5*FILTER_WIDTH){1'b0}};
                    filter_row5 = {(5*FILTER_WIDTH){1'b0}};
                    Ifmap.Receive(ifmap);
                join
                #FL;
            end
            2'b01: begin // 3x3
                fork 
                    Filter_row1.Receive(filter_row1);
                    Filter_row2.Receive(filter_row2);
                    Filter_row3.Receive(filter_row3);
                    filter_row4 = {(5*FILTER_WIDTH){1'b0}};
                    filter_row5 = {(5*FILTER_WIDTH){1'b0}};
                    Ifmap.Receive(ifmap);
                join
                #FL;
            end
            2'b10: begin // 4x4
                fork 
                    Filter_row1.Receive(filter_row1);
                    Filter_row2.Receive(filter_row2);
                    Filter_row3.Receive(filter_row3);
                    Filter_row4.Receive(filter_row4);
                    filter_row5 = {(5*FILTER_WIDTH){1'b0}};
                    Ifmap.Receive(ifmap);
                join
                #FL;
            end
            2'b11: begin // 5x5
                fork 
                    Filter_row1.Receive(filter_row1);
                    Filter_row2.Receive(filter_row2);
                    Filter_row3.Receive(filter_row3);
                    Filter_row4.Receive(filter_row4);
                    Filter_row5.Receive(filter_row5);
                    Ifmap.Receive(ifmap);
                join
                #FL;
            end
            default: $display("Error: Invalid size");
        endcase

        // $display("Filter_row1: %h", filter_row1);
        // $display("Filter_row2: %h", filter_row2);
        // $display("Filter_row3: %h", filter_row3);
        // $display("Filter_row4: %h", filter_row4);
        // $display("Filter_row5: %h", filter_row5);
        // $display("Ifmap: %b", ifmap);

        case (size)
            2'b00: begin // 2x2
                out = (ifmap[2] ? filter_row1[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[3] ? filter_row1[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +

                      (ifmap[0] ? filter_row2[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[1] ? filter_row2[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}});
            end
            2'b01: begin // 3x3
                out = (ifmap[6] ? filter_row1[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[7] ? filter_row1[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[8] ? filter_row1[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +

                      (ifmap[3] ? filter_row2[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[4] ? filter_row2[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[5] ? filter_row2[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +

                      (ifmap[0] ? filter_row3[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[1] ? filter_row3[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[2] ? filter_row3[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}});
            end
            2'b10: begin // 4x4
                out = (ifmap[12] ? filter_row1[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[13] ? filter_row1[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[14] ? filter_row1[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[15] ? filter_row1[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +

                      (ifmap[8]  ? filter_row2[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[9]  ? filter_row2[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[10] ? filter_row2[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[11] ? filter_row2[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +

                      (ifmap[4]  ? filter_row3[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[5]  ? filter_row3[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[6]  ? filter_row3[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[7]  ? filter_row3[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}}) +

                      (ifmap[0]  ? filter_row4[FILTER_WIDTH*1-1:FILTER_WIDTH*0] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[1]  ? filter_row4[FILTER_WIDTH*2-1:FILTER_WIDTH*1] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[2]  ? filter_row4[FILTER_WIDTH*3-1:FILTER_WIDTH*2] : {(FILTER_WIDTH){1'b0}}) +
                      (ifmap[3]  ? filter_row4[FILTER_WIDTH*4-1:FILTER_WIDTH*3] : {(FILTER_WIDTH){1'b0}});
            end
            2'b11: begin // 5x5
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
            end
            default: $display("Error: Invalid size");
        endcase
            

        Out.Send(out);
        // $display("%m Sending out: %d @ %t", out, $time);
        #BL;

    end
    
endmodule
