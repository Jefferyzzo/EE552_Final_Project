`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Input Filter Packet Format***********************************************************************************************
//  Address    [5*FILTER_WIDTH+4:5]     [4:3]       [2]         [1]                 [0]              
//             filter_data              filter_size timestep    ifmap(0)_filter(1)  ack(0)_input(1)  
// **********************************************************************************************************************************************************************


// ************************************************** Input Ifmap Packet Format***********************************************************************************************
//  Address    [5*FILTER_WIDTH+4:9]     [8:3]       [2]         [1]                 [0]              
//             ifmap_data               ifmap_size  timestep    ifmap(0)_filter(1)  ack(0)_input(1)  
// **********************************************************************************************************************************************************************
// ifmap_data width is 36 bits

// ************************************************** Input Ack Packet Format***********************************************************************************************
//             
//  Address    [5*FILTER_WIDTH+4:5]     [4:1]       [0]               
//             0s                       PE_node     ack(0)_input(1)  
// **********************************************************************************************************************************************************************

// ************************************************** Output Pakcet Data***********************************************************************************************
//             
//  Address    [5*FILTER_WIDTH+12:13]       [12:10]     [9]                 [8]       [7:5]    [4:2]    [1:0]            
//             data                         filter_row  ifmap(0)_filter(1)  timestep  y-hop    x-hop    direction 
//  data format for ifmap data:
//  Address    [5*FILTER_WIDTH+12:5*FILTER_WIDTH-12]    [5*FILTER_WIDTH-13] [26:21]     [20:15]         [14:13]
//             ifmap data                               0                   con_loc_x   conv_loc_y      size
// *****************************************************************************************************************************************************************************

// e.g for data field under 3*3 filter: 0, 0, filter2, filter1, filter0
// e.g for ifmap data: 0, 0, ..., if3, if2, if1, if0
// FILTER_WIDTH = 8, maximum conv size is (2^5)^2, maximum ifmap size is (2*5+4)^2

module Instr_Decoder #(
    parameter WIDTH	= 45 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    ) (
    interface   I,  // input packet
    interface   O_if_data, // to ifmap data memoryr
    interface   O_fil_data, // to filter data memory
    // interface   O_fil_inst, // to filter instruction generator
    interface   O_packetizer, // to packetizer
    interface   PE_ack [13:0] // to instruction FIFOs
    );

    logic   [WIDTH-1:0] in_packet;
    logic   [1:0]   size_filter;
    logic   [5:0]   size_ifmap;
    logic   [11:0]  num_ifmap;
    logic   [2:0]   filter_row = 3'b0;
    logic   [11:0]  if_count = 11'd0; // count collected ifmap data
    logic   fil_done;
    logic   [3:0] PE_node;
    

    always begin
        // wait(I.status != idle);
        // $display("at %t module= %m,width = %d, I_data = %h, inpacket = %h", $time, WIDTH, I.data, in_packet);
        I.Receive(in_packet);
        // $display("at %t , module= %m,I_data = %h, inpacket = %h", $time, I.data, in_packet);
        // $display("width = %d, in_packet = %h, I_data = %h", WIDTH, in_packet, I.data1);
        #FL;
        if(in_packet[0]) begin // if packet comes from external input
            if(in_packet[1]) begin // filter packet
                size_filter = in_packet[4:3]; // get filter size information
                // $display("(filter_row + 3'b001)= %b, (3'b010 + size_filter) = %b", (filter_row + 3'b001), (3'b010 + size_filter));
                if((filter_row + 3'b001) == (3'b010 + size_filter)) fil_done = 1'b1;  // sending the last row of data
                else fil_done = 1'b0;
                // $display("At %t, start sending filter size %b to packetizer", $time, size_filter);
                fork
                    O_packetizer.Send(size_filter); // inform packetizer of filter size
                    O_fil_data.Send({fil_done, filter_row, in_packet[WIDTH-1:5]}); // write to filter data memory
                join
                // $display("At %t, finish sending filter size %b to packetizer", $time, size_filter);
                // O_fil_inst.Send({fil_done,filter_row}); // call filter instr gen to generate instructions
                #BL;
                filter_row = filter_row + 1;
                // $display("AT %t, %m ends BL", $time);
            end
            else begin // ifmap packet
                size_ifmap = in_packet[8:3]; // get ifmap size information
                num_ifmap = size_ifmap * size_ifmap;
                // $display("At %t, num_ifmap = %d", $time, num_ifmap);
                if(((if_count + 36)< num_ifmap) || (!in_packet[2])) begin // ifmap data not finish sending
                    // $display("At %t, ifmap data doesn't finish sending, send to ifmem %b", $time, {1'b0, size_filter, in_packet[WIDTH-1:2]});
                    O_if_data.Send({1'b0, size_filter, in_packet[WIDTH-1:2]}); 
                    // includes done(whether ifmap finishes), filter size, data, timestep and ifmap size, the latter two determine write address
                    #BL;
                    if((if_count + 36) < num_ifmap)
                        if_count = if_count + 36;
                    else
                        if_count = 11'd0;
                end
                else begin // ifmap data finish sending
                    // $display("At %t, ifmap data finishes sending, send to ifmem %b", $time, {1'b1, size_filter, in_packet[WIDTH-1:2]});
                    O_if_data.Send({1'b1, size_filter, in_packet[WIDTH-1:2]}); 
                    #BL;
                    if_count = 11'd36;
                end
            end
        end
        else begin // if packet is ack from PE
            case (in_packet[4:1])
                4'd0 : PE_ack[0].Send(1'b1);
                4'd1 : PE_ack[1].Send(1'b1);
                4'd2 : PE_ack[2].Send(1'b1);
                4'd4 : PE_ack[3].Send(1'b1);
                4'd5 : PE_ack[4].Send(1'b1);
                4'd6 : PE_ack[5].Send(1'b1);
                4'd7 : PE_ack[6].Send(1'b1);
                4'd8 : PE_ack[7].Send(1'b1);
                4'd9 : PE_ack[8].Send(1'b1);
                4'd10 : PE_ack[9].Send(1'b1);
                4'd11: PE_ack[10].Send(1'b1);
                4'd13: PE_ack[11].Send(1'b1);
                4'd14: PE_ack[12].Send(1'b1);
                4'd15: PE_ack[13].Send(1'b1);
                default: ; 
            endcase
            #BL;
        end
        // $display("At %t, finish instruction decoding for : %b", $time, in_packet);
    end


endmodule

