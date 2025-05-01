`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Input DATA Format***********************************
//  Address    [5*FILTER_WIDTH+3]   [5*FILTER_WIDTH+2:5*FILTER_WIDTH]   [5*FILTER_WIDTH-1:0]       
//             done                 fil_row                             fil_data
// *******************************************************************************************************
module Filter_Mem #(
    parameter WIDTH	= 40, // total size of filter data
    parameter DEPTH = 5 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    ) (
    interface   W,
    interface   R_req,
    interface   R_data
    );
    logic [WIDTH-1:0] data [DEPTH-1:0];
    logic [WIDTH+3:0] in_packet;
    logic [2:0] row;
    logic done;
    initial begin
        done = 0;
    end


    always begin // Write Operation
        W.Receive(in_packet); // receive write address and data
        #FL;
        data[in_packet[WIDTH+2:WIDTH]] = in_packet[WIDTH-1:0];
        done  = in_packet[WIDTH+3];
    end

    always begin // Read Operation
        wait(done);
        R_req.Receive(row);
        #FL;
        R_data.Send(data[row]);
        #BL;
    end
endmodule


