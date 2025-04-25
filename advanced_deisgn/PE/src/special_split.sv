`timescale 1ns/1ns

import SystemVerilogCSP::*;

module special_split #(
    parameter FILTER_WIDTH = 8,
    parameter FL	       = 2,
    parameter BL	       = 1
) (
    // input
    interface  Data,  
    interface  Ifmapb_filter, 
    interface  Filter_row,  
    // output
    interface  Ifmap,
    interface  Size,
    interface  Conv_Loc,
    interface  Filter_row1,
    interface  Filter_row2,
    interface  Filter_row3,
    interface  Filter_row4,
    interface  Filter_row5
); 
    
    logic [5*FILTER_WIDTH-1:0]  data;
    logic                       ifmapb_filter;
    logic [2:0]                 filter_row;
    logic [1:0]                 size;     
    logic [24:0]                ifmap_data;
    logic [5*FILTER_WIDTH-26:0] conv_loc;
    
    always begin
        fork
            Data.Receive(data);
            Ifmapb_filter.Receive(ifmapb_filter);
            Filter_row.Receive(filter_row);
        join
        // $display("%m Data: %h, Ifmapb_filter: %b, Filter_row: %d", data, ifmapb_filter, filter_row);
        #FL;
        if (ifmapb_filter == 0) begin               // send ifmap data
            ifmap_data = data[5*FILTER_WIDTH-1:5*FILTER_WIDTH-25];
            conv_loc   = data[5*FILTER_WIDTH-26:2];
            size       = data[1:0];
            // $display("ifmap_data: %b", ifmap_data);
            fork
                Ifmap.Send(ifmap_data);
                Conv_Loc.Send(conv_loc);
                Size.Send(size);
            join
            #BL;
        end else begin                               // send filter data
            if (filter_row == 3'b001) begin          // row1
                Filter_row1.Send(data);
                #BL;
            end else if (filter_row == 3'b010) begin // row2
                Filter_row2.Send(data);
                #BL;
            end else if (filter_row == 3'b011) begin // row3
                Filter_row3.Send(data);
                #BL;
            end else if (filter_row == 3'b100) begin // row4
                Filter_row4.Send(data);
                #BL;
            end else if (filter_row == 3'b101) begin // row5
                Filter_row5.Send(data);
                #BL;
            end else begin 
                $display("Error: filter_row is not valid");
            end
        end
    end

endmodule