`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Input Filter Packet Format***********************************************************************************************
//  Address    [13:4]     [3:1]       [0]                 
//             0s         filter_row  ifmap(0)_filter(1)  
// **********************************************************************************************************************************************************************


// ************************************************** Input Ifmap Packet Format***********************************************************************************************
//  Address    [13:8]           [7:2]           [1]         [0]                 
//             if_mem_loc_y     if_mem_loc_x    timestep    ifmap(0)_filter(1) 
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
        interface O_arb
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
        $display("At %t, FIFO %d wp = %h, rp = %h, wp - rp = %h, (wp-rp) != DEPTH) = %b", $time, PE_node, wp, rp, (wp-rp), (wp-rp) != DEPTH);
        I_inst.Receive(data[wp[3:0]]);
        $display("At %t, FIFO %d finish storing Inst %b", $time, PE_node, data[wp]);
        #FL;
        wp++;
    end


    // Read Operation
    always begin
        wait((wp-rp) != 0);
        if(data[rp][1:0] == 2'b00) begin // for a new set of ifmap data, wait unti PE ack to send it
            // $display("%m start receive a token at %t", $time);
            I_ack.Receive(ack_dummy);
            // $display("%m finish receive a token at %t", $time);
            #FL;
        end
        // $display("At %t, %m start sending Inst %h to Arb", $time, {data[rp], PE_node[3:0]});
        O_arb.Send({data[rp[3:0]], PE_node[3:0]}); 
        // $display("At %t, %m finishes sending Inst %h to Arb", $time, {data[rp], PE_node[3:0]});
        #BL;
        rp++;
    end
endmodule

