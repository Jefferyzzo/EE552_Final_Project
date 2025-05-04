`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** General Input Format ***********************************************************************************************
//  Address    [17:4]       [3:0]              
//             FIFO_content PE_node 
// **********************************************************************************************************************************************************************

// ************************************************** FIFO content for filter***********************************************************************************************
//  Address    [13:4]     [3:1]       [0]                 
//             0s         filter_row  ifmap(0)_filter(1)  
// **********************************************************************************************************************************************************************


// ************************************************** FIFO content for ifmap***********************************************************************************************
//  Address    [13:8]           [7:2]           [1]         [0]                 
//             if_mem_loc_y     if_mem_loc_x    timestep    ifmap(0)_filter(1) 
// **********************************************************************************************************************************************************************

module packetizer_cu #(
    parameter WIDTH_IN	= 18,
    parameter WIDTH_OUT	= 53,
    parameter WIDTH_FIL_DATA	= 40,
    parameter WIDTH_IF_DATA	= 25,
    parameter FL	= 2 ,
    parameter BL	= 2
    ) (
    interface   I_FIFO,
    interface   I_fil_size,
    interface   Fil_addr,
    interface   Fil_data,
    interface   If_addr,
    interface   If_data,
    interface   O
    );
    logic [WIDTH_IN-1:0] in_packet;
    logic [WIDTH_OUT-1:0] out_packet;
    logic [WIDTH_FIL_DATA-1:0] data_fil;
    logic [WIDTH_IF_DATA-1:0] data_if;
    logic [1:0] fil_size;
    integer i;

    initial begin
        fil_size = 2'b0;
    end
    always begin
        I_fil_size.Receive(fil_size);
        #FL;
    end


    always begin 
        out_packet = 0;
        I_FIFO.Receive(in_packet);
        //$display("At %t, pkt receives packet %h", $time, in_packet);
        #FL;
        case(in_packet[3:0]) // generate header
            4'b0000: out_packet[7:0] = 8'b1110_0011;
            4'b0001: out_packet[7:0] = 8'b1111_0011;
            4'b0010: out_packet[7:0] = 8'b1111_1011;
            4'b0011: out_packet[7:0] = 8'b1100_0011;
            4'b0100: out_packet[7:0] = 8'b1101_0011;
            4'b0101: out_packet[7:0] = 8'b1101_1011;
            4'b0110: out_packet[7:0] = 8'b1101_1111;
            4'b0111: out_packet[7:0] = 8'b1000_0011;
            4'b1000: out_packet[7:0] = 8'b1001_0011;
            4'b1001: out_packet[7:0] = 8'b1001_1011;
            4'b1010: out_packet[7:0] = 8'b1001_1111;
            4'b1011: out_packet[7:0] = 8'b0001_0011;
            4'b1100: out_packet[7:0] = 8'b0001_1011;
            4'b1101: out_packet[7:0] = 8'b0001_1111;
            default: out_packet[7:0] = 8'b1110_0011;
        endcase
        if(in_packet[4] == 1'b1) begin  // fetch filter data and send instructions
            out_packet[12:10] = in_packet[7:5];
            out_packet[9] = 1'b1;
            //$display("At %t, pkt sends filter addr %h", $time, in_packet[7:5]);
            Fil_addr.Send(in_packet[7:5]);
            #BL;
            Fil_data.Receive(data_fil);
            //$display("At %t, pkt recieves filter data %h", $time, data_fil);
            #FL;
            out_packet[WIDTH_OUT-1:13] = data_fil;
            O.Send(out_packet);
            //$display("At %t, pkt sends filter inst %h", $time, out_packet);
        end
        else begin // fetch ifmap data and send instructions
            out_packet[8] = in_packet[5];
            out_packet[9] = 1'b0;
            out_packet[12:10] = 3'b0;
            out_packet[14:13] = fil_size;
            out_packet[26:15] = in_packet[17:6];
            //$display("At %t, pkt sends ifmap addr %h", $time, in_packet[17:5]);
            If_addr.Send(in_packet[17:5]);
            #BL;
            If_data.Receive(data_if);
            //$display("At %t, pkt recieves ifmap data %h", $time, data_if);
            out_packet[52:28] = data_if;
            #FL;
            O.Send(out_packet);
        end
    end

endmodule


