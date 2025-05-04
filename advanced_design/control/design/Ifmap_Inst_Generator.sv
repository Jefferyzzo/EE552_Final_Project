`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Ifmap FIFO Inst Format***********************************************************************************************
//  Address    [17:14]  [13:8]           [7:2]           [1]         [0]                 
//             PE node  if_mem_loc_y     if_mem_loc_x    timestep    ifmap(0)_filter(1) 
// **********************************************************************************************************************************************************************


module Ifmap_Inst_Generator #(
    parameter WIDTH_OUT	= 18 ,
    parameter WIDTH_CONV	= 6 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I,
        interface O_FIFO
    );

    logic [WIDTH_CONV-1:0] i, j, conv_size;
    logic [3:0] PE_node;
    logic [WIDTH_OUT-1:0] out_packet;

    initial begin
        out_packet = 0;
        out_packet[0] = 0;
        PE_node = 0;
    end
    

    always begin
        I.Receive(conv_size);
        // $display("At %t, ifgen receives conv size %d", $time, conv_size);
        #FL;
        for(i = 0; i < conv_size; i++) begin  // send ifmap data for each conv location to different PE
            for(j = 0; j < conv_size; j++) begin
                out_packet[13:8] = i; // y dir
                out_packet[7:2] = j; // x dir
                out_packet[1] = 1'b0;
                out_packet[17:14] = PE_node[3:0];
                // $display("At %t, ifgen gen inst for loc y = %d, x = %d", $time, i, j);
                O_FIFO.Send(out_packet);
                #BL;
                out_packet[1] = 1'b1;
                O_FIFO.Send(out_packet);
                #BL;

                if(PE_node[3:0] == 4'd13)
                    PE_node = 0;
                else
                    PE_node = PE_node + 1;

            end
        end
    end

endmodule


