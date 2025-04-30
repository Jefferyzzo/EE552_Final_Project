// ************************************************** content orgnization **************************************************
//  Address    [0]         [1]                    [2:3]         [4:3*filter_width+3] 
//             timestep    ifmapb(0)_filter(1)    filter_row    3*fliter_width
// *************************************************************************************************************************

`timescale 1ns/1ns

import SystemVerilogCSP::*;

module depacketizer #(
    parameter FILTER_WIDTH = 8, 
    parameter FL           = 2,
    parameter BL           = 1 
) (
    interface  Packet,
    interface  Timestep,
    interface  Ifmapb_filter,
    interface  Filter_row,
    interface  Data   
); 

    logic [3*FILTER_WIDTH+3:0] packet;
    logic [3*FILTER_WIDTH-1:0] data;
    logic timestep;
    logic ifmapb_filter; // 0->ifmap; 1->filter
    logic [1:0] filter_row;

    always begin
    	Packet.Receive(packet); 
    	#FL;
        timestep      = packet[0];
        ifmapb_filter = packet[1];
        filter_row    = packet[3:2];
        data          = packet[3*FILTER_WIDTH+3:4];
        // $display("timestep: %0d, ifmapb_filter: %0d, filter_row: %0d, data: %0b", timestep, ifmapb_filter, filter_row, data);
        if(ifmapb_filter == 0) begin 
            fork
                Ifmapb_filter.Send(ifmapb_filter);
                Filter_row.Send(filter_row);
                Data.Send(data);
                Timestep.Send(timestep);
            join
            #BL;
        end else begin 
            fork
                Ifmapb_filter.Send(ifmapb_filter);
                Filter_row.Send(filter_row);
                Data.Send(data);
            join
            #BL;
        end
    end

endmodule