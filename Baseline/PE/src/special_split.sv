
`timescale 1ns/1ns
import SystemVerilogCSP::*;

module special_split #(
    parameter FILTER_WIDTH = 8,
    parameter FL	       = 2,
    parameter BL	       = 1,
) (
    // input
    interface  Data,  
    interface  Ifmapb_filter, 
    interface  Filter_row,
    // output
    interface  Ifmap,
    interface  Filter_row1,
    interface  Filter_row2,
    interface  Filter_row3
); 

    logic [3*FILTER_WIDTH-1:0] data;
    logic                      ifmapb_filter;
    logic       [2:0]          filter_row;
    logic       [8:0]          ifmap_data;
    
    always begin
        fork
            Data.Receive(data);
            Ifmapb_filter.Receive(ifmapb_filter);
            Filter_row.Receive(filter_row);
        join
        #FL;
        if(ifmapb_filter == 0) begin    // ifmap send
            ifmap_data[8:0] = data[8:0];
            Ifmap.Send(ifmap_data);
        end else begin
            if(filter_row = 2'b00) begin //row1
                Filter_row1.Send(data);
                #BL;
            end else if(filter_row = 2'b01) begin //row2
                Filter_row2.Send(data);
                #BL;
            end else begin //row3
                Filter_row3.Send(data);
                #BL;
            end
        end
    end

endmodule