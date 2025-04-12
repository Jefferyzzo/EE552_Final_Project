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

module spike_residue_tb ();

    parameter WIDTH = 8;
    parameter THRESHOLD = 64;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) L ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) OutSpike ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) Residue ();
    
    // Instantiate DUT
    data_generator #(.WIDTH(WIDTH), .FL(0)) dg_data (L);
    spike_residue #(.WIDTH(WIDTH), .THRESHOLD(THRESHOLD)) sr (.L(L), .OutSpike(OutSpike), .Residue(Residue));
    data_bucket #(.WIDTH(1), .BL(0)) db_spike (OutSpike);
    data_bucket #(.WIDTH(WIDTH), .BL(0)) db_residue (Residue);

    initial begin
        $display("Start simulation!!!");
        #50
        $finish;
    end

endmodule
