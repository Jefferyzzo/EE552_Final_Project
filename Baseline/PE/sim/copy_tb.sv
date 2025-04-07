`timescale 1ns/1ns

import SystemVerilogCSP::*;

// // data_bucket module
// module data_bucket (interface r);
//     parameter WIDTH = 8;
//     parameter BL = 0; //ideal environment no backward delay

//     logic [WIDTH-1:0] ReceiveValue = 0;

//     always begin
//         // $display("In module %m. Simulation time =%t",$time);
//         // $display("Start receiving in module %m. Simulation time =%t", $time);
//         r.Receive(ReceiveValue);
//         $display("Finished receiving in module %m. Simulation time =%t, data=%b", $time,ReceiveValue);
//         #BL;
//     end
// endmodule

module copy_tb ();

    // Parameter definitions
    parameter WIDTH = 4;
    
    // Clock signal
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Interface signals
    logic [WIDTH-1:0] packet_0, packet_1, packet_r;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) L ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) R0 ();
    Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) R1 ();
    
    // Instantiate DUT
    copy #(.WIDTH(WIDTH)) dut (
        .L(L),
        .R0(R0),
        .R1(R1)
    );
    // Monitor outputs
    // data_bucket #(.WIDTH(WIDTH)) db0(.r(R0));
    // data_bucket #(.WIDTH(WIDTH)) db1(.r(R1));

    // Stimulus generation
    initial begin
        // Initialize signals
        packet_0 = 4'b1010;
        packet_1 = 4'b0101;
        
        #10;
        L.Send(packet_0); 
        R0.Receive(packet_r);
        $display("Finished receiving R0. Simulation time =%t, data=%b", $time, packet_r);
        R1.Receive(packet_r);
        $display("Finished receiving R1. Simulation time =%t, data=%b", $time, packet_r);
        #20;
        L.Send(packet_1); 
        R1.Receive(packet_r);
        $display("Finished receiving R1. Simulation time =%t, data=%b", $time, packet_r);
        R0.Receive(packet_r);
        $display("Finished receiving R0. Simulation time =%t, data=%b", $time, packet_r);
        #20;
        $stop;
    end

endmodule
