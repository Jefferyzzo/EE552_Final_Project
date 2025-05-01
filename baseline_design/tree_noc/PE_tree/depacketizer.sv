// ************************************************** content orgnization **************************************************
//  Address    [0]         [1]                    [2:3]         [4:3*filter_width+3] 
//             [6]         [7]                    [8:9]         [10:3*filter_width+9]
//             timestep    ifmapb(0)_filter(1)    filter_row    3*fliter_width
// *************************************************************************************************************************

`timescale 1ns/1ns

import SystemVerilogCSP::*;

module depacketizer #(
    parameter FILTER_WIDTH = 8, 
    parameter IFMAP_SIZE   = 9,
    parameter OUTPUT_WIDTH = 12,
    parameter THRESHOLD    = 16,

    parameter WIDTH_packet = 28,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL           = 2,
    parameter BL           = 1 
) (
    interface  Packet,
    interface  Timestep,
    interface  Ifmapb_filter,
    interface  Filter_row,
    interface  Data   
); 

    logic [3*FILTER_WIDTH+9:0] packet;
    logic [3*FILTER_WIDTH-1:0] data;
    logic timestep;
    logic ifmapb_filter; // 0->ifmap; 1->filter
    logic [1:0] filter_row;

    always begin
        wait(Packet.status != idle);
    	Packet.Receive(packet); 
    	#FL;
        timestep      = packet[6];
        ifmapb_filter = packet[7];
        filter_row    = packet[9:8];
        data          = packet[3*FILTER_WIDTH+9:10];
        //$display("timestep: %0d, ifmapb_filter: %0d, filter_row: %0d, data: %0b", timestep, ifmapb_filter, filter_row, data);
        $display("!!!!!PE (%m): Received packet:%b, timestep: %b, ifmapb_filter: %b, filter_row: %b, data: %b", packet,ifmapb_filter,timestep, ifmapb_filter, filter_row, data);
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