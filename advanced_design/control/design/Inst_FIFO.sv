`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Input Filter Packet Format***********************************************************************************************
//  Address    [13:4]     [3:1]       [0]                 
//             0s         filter_row  ifmap(0)_filter(1)  
// **********************************************************************************************************************************************************************


// ************************************************** Input Ifmap Packet Format***********************************************************************************************
//  Address    [13:8]           [7:2]           [1]         [0]                 
//             if_mem_loc_x     if_mem_loc_y    timestep    ifmap(0)_filter(1) 
// **********************************************************************************************************************************************************************

// ************************************************** Output Format ***********************************************************************************************
//  Address    [17:4]       [3:0]              
//             FIFO_content PE_node 
// **********************************************************************************************************************************************************************

module Inst_FIFO  #(
    parameter WIDTH	= 14 ,
    parameter DEPTH = 16 ,
    parameter PE_node = 4'b0,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I_inst,
        interface I_ack,
        interface O
    );


    logic [4:0] rp, wp;
    logic [WIDTH-1:0] data [DEPTH-1:0];
    logic ack_dummy;

    initial begin
        rp = 0;
        wp = 0;
    end

    // Write Operation
    always begin
        wait((wp-rp) != DEPTH);  
        I.Receive(data[wp]);
        $display("At %t, FIFO %d finish storing Inst %b", $time, PE_node, data[wp]);
        #FL;
        wp++;
    end


    // Read Operation
    always begin
        wait((wp-rp) != 0);
        if(data[rp][1:0] == 2'b00) begin // for a new set of ifmap data, wait unti PE ack to send it
            I_ack.Receive(ack_dummy);
            #FL;
        end
        O.Send({data[rp], PE_node}); 
        #BL;
        rp++;
    end
endmodule

