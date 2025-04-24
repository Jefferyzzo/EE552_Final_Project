`timescale 1ns/1ns

import SystemVerilogCSP::*;

module data_generator (interface r);

    parameter WIDTH = 8;
    parameter FL    = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0; 

    always begin 
        SendValue = $random() % (2**WIDTH); // the range of random number is from 0 to 2^WIDTH
        #FL;   
        r.Send(SendValue);
        $display("DG %m sends input data = %d @ %t", SendValue, $time);
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

module priority_mux_tb ();

    parameter WIDTH = 8;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) L0 ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) L1 ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) R ();
    
    // Instantiate DUT
    data_generator #(.WIDTH(WIDTH), .FL(4)) dg_data0 (L0); 
    data_generator #(.WIDTH(WIDTH), .FL(0)) dg_data1 (L1); 
    priority_mux #(.WIDTH(WIDTH)) pm (.L0(L0), .L1(L1), .R(R));
    data_bucket #(.WIDTH(WIDTH), .BL(0)) db (R);

    initial begin
        $display("Start simulation!!!");
        #50
        $finish;
    end

endmodule
