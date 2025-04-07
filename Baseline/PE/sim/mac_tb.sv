`timescale 1ns/1ns

import SystemVerilogCSP::*;
//
module data_generator (interface r);

    parameter WIDTH = 8;
    parameter FL    = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0; 

    always begin 
        SendValue = $random() % (2**WIDTH); // the range of random number is from 0 to 2^WIDTH
        #FL;   
        r.Send(SendValue);
        $display("DG sends input data = %d @ %t", SendValue, $time);
    end

endmodule

module data_bucket (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; //ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    always begin
        r.Receive(ReceiveValue);
        $display("DB %m receives output data = %d @ %t", ReceiveValue, $time);
        #BL;
    end

endmodule

module mac_tb ();

    parameter FILTER_WIDTH = 8;
    parameter OUTPUT_WIDTH = 8,
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_WIDTH  = 1,

    // Instantiate interfaces  
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) L0 ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) L1 ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) R ();
    
    // Instantiate DUT
    data_generator #(.WIDTH(FILTER_WIDTH*9), .FL(0)) dg_filter (L0); 
    data_generator #(.WIDTH(IFMAP_WIDTH*9), .FL(0)) dg_ifmap (L1); 
    mac #(.WIDTH(WIDTH)) mac (
        .L0(L0),
        .L1(L1),
        .R(R)
    );
    data_bucket #(.OUTPUT_WIDTH(OUTPUT_WIDTH), .FILTER_WIDTH(FILTER_WIDTH), .IFMAP_WIDTH(IFMAP_WIDTH)) db (R);

    initial begin
        $display("Simulation started");
        #50
        $finish;
    end

endmodule
