

`timescale 1ns/1ns
import SystemVerilogCSP::*;



module output_ctrl_tb ();

    // Parameter definitions
    parameter WIDTH_packet = 14;
    
    // Clock signal
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
        #20;
        //$stop;
    end

    initial begin
        #2000; // Run for a fixed duration (adjust as needed)
        //$display("Simulation finished at time %t", $time);
        $stop;
    end
    
    // Interface signals
    logic [WIDTH_packet-1:0] packet_0, packet_1, packet_2, packet_3;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L0 ();
    Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L1 ();
    Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) R ();
    
    // Instantiate DUT
    output_ctrl #(.WIDTH_packet(WIDTH_packet)) dut (
        .in1(L0),
        .in2(L1),
        .out(R)
    );
    // Monitor outputs
    data_bucket #(.WIDTH_packet(WIDTH_packet)) db(.r(R));

    // Stimulus generation
    always begin
        // Initialize signals
        packet_0 = 14'b10100000100000;
        packet_1 = 14'b01011111000000;
        packet_2 = 14'b01101010111110;
        packet_3 = 14'b11000100111110;
        
        #10;
        L0.Send(packet_0); // L0 makes a request
        #10;
        L1.Send(packet_1); // L1 makes a request
        #20;
        fork
            L0.Send(packet_2); // L0 makes a request
            L1.Send(packet_3); // L1 makes a request
        join
        #20;
        fork
            L0.Send(packet_0); // L0 makes a request
            L1.Send(packet_1); // L1 makes a request
        join
        #20;
        //$stop;
    end
    


endmodule




