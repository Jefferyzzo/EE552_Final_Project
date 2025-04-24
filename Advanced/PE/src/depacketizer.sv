// ************************************************** filter content orgnization **********************************************
//  Address    [5*FILTER_WIDTH+4:5]    [4:2]         [1]                    [0]     
//             filter_data             filter_row    ifmapb(0)_filter(1)    timestep
// ****************************************************************************************************************************

// ************************************************** ifmap content orgnization ***********************************************
//  Address    [5*FILTER_WIDTH+4:5*FILTER_WIDTH-20]    [5*FILTER_WIDTH-21:5]    [4:2]         [1]                    [0]     
//             ifmap_data                              conv_loc                 filter_row    ifmapb(0)_filter(1)    timestep
// ****************************************************************************************************************************

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

    logic [5*FILTER_WIDTH+4:0] packet;
    logic [5*FILTER_WIDTH-1:0] data;
    logic timestep;
    logic ifmapb_filter; // 0->ifmap; 1->filter
    logic [2:0] filter_row;

    always begin
    	Packet.Receive(packet); 
    	#FL;
        timestep      = packet[0];
        ifmapb_filter = packet[1];
        filter_row    = packet[4:2];
        data          = packet[5*FILTER_WIDTH+4:5];
        $display("%m timestep: %0d, ifmapb_filter: %0d, filter_row: %0d, data: %0h", timestep, ifmapb_filter, filter_row, data);
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