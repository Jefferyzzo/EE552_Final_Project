`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Input Format***********************************
//  Address    [14:13]      [12:7]     [12:1]    [0]         
//             filter_size  x_loc      y_loc     timestep   
// ***************************************************************************************************
module Ifmap_Inst_Generator #(
    parameter WIDTH_OUT	= 18 ,
    parameter WIDTH_IN	= 8 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I,
        interface O_FIFO
    );

    logic [5:0] i, j, conv_size;
    logic [3:0] PE_node;
    logic [WIDTH_IN-1:0] in_packet;
    logic [WIDTH_OUT-1:0] out_packet;

    initial begin
        out_packet = 0;
        out_packet[0] = 0;
        PE_node = 0;
    end
    

    always begin
        I.Receive(in_packet);
        conv_size = in_packet[7:2] - in_packet[1:0] - 2;
        #FL;
        for(i = 0; i < conv_size; i++) begin
            for(j = 0; j < conv_size; j++) begin
                out_packet[13:8] = i;
                out_packet[7:2] = j;
                out_packet[1] = 1'b0;
                out_packet[17:14] = PE_node;
                O_FIFO.Send(out_packet);
                #BL;
                out_packet[1] = 1'b1;
                O_FIFO.Send(out_packet);
                #BL;

                if(PE_node == 4'd13)
                    PE_node = 0;
                else
                    PE_node = PE_node + 1;

            end
        end
    end

endmodule


