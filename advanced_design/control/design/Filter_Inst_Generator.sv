`timescale 1ns/1ns

import SystemVerilogCSP::*;


// ************************************************** Input Content ***********************************************************************************************
//  Address    [3]     [2:0]       
//             done    filter_row  
// **********************************************************************************************************************************************************************


// ************************************************** Output Filter Inst Format***********************************************************************************************
//  Address    [14]     [13:4]     [3:1]       [0]                 
//             done     0s         filter_row  ifmap(0)_filter(1)  
// **********************************************************************************************************************************************************************

//
module Filter_Inst_Generator #(
    parameter WIDTH	= 15 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I,
        interface O_FIFO
    );

    logic [3:0] in_packet;
    logic [2:0] fil_row, i;
    logic [WIDTH-1:0] out_packet;

    initial begin
        out_packet = 0;
        out_packet[0] = 1'b1;
    end
    

    always begin
        I.Receive(in_packet);
        #FL;
        out_packet[0] = 1'b1; 
        out_packet[WIDTH-1] = in_packet[3];
        out_packet[3:1] = in_packet[2:0];
        // $display("At %t, filgen sends to alloc: %b", $time, out_packet);
        O_FIFO.Send(out_packet);
        #BL;
    end

endmodule