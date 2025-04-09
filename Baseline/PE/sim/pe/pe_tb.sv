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

module data_bucket0 (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; // ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    // File handle for dumping ReceiveValue
    integer recv_file;

    // Open the file at the start of simulation
    initial begin
        recv_file = $fopen("recv_timestep.txt", "w");
        if (recv_file == 0) begin
            $display("Error: Could not open recv_timestep.txt for writing.");
            $finish;
        end
    end

    always begin
        r.Receive(ReceiveValue);
        // Dump value to the file along with the simulation time.
        $fdisplay(recv_file, "Time: %0t - Received Value: %b", $time, ReceiveValue);
        #BL;
    end

    // Optionally close the file at the end of simulation.
    final begin
        $fclose(recv_file);
    end

endmodule

module data_bucket1 (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; // ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    // File handle for dumping ReceiveValue
    integer recv_file;

    // Open the file at the start of simulation
    initial begin
        recv_file = $fopen("recv_ifmapb_filter.txt", "w");
        if (recv_file == 0) begin
            $display("Error: Could not open recv_ifmapb_filter.txt for writing.");
            $finish;
        end
    end

    always begin
        r.Receive(ReceiveValue);
        // Dump value to the file along with the simulation time.
        $fdisplay(recv_file, "Time: %0t - Received Value: %b", $time, ReceiveValue);
        #BL;
    end

    // Optionally close the file at the end of simulation.
    final begin
        $fclose(recv_file);
    end

endmodule

module data_bucket2 (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; // ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    // File handle for dumping ReceiveValue
    integer recv_file;

    // Open the file at the start of simulation
    initial begin
        recv_file = $fopen("recv_filter_row.txt", "w");
        if (recv_file == 0) begin
            $display("Error: Could not open recv_filter_row.txt for writing.");
            $finish;
        end
    end


module pe_tb ();

    parameter FILTER_WIDTH = 8;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+4),.hsProtocol(P4PhaseBD)) Packet ();
    
    // Instantiate DUT

    data_generator #(.WIDTH(3*FILTER_WIDTH+4), .FL(0)) dg_content (Packet); 
    pe pe (.Packet(Packet), .(), .(), .());
    data_bucket0 #(.WIDTH(WIDTH), .BL(0)) db (R);
    data_bucket1 #(.WIDTH(WIDTH), .BL(0)) db (R);
    data_bucket2 #(.WIDTH(WIDTH), .BL(0)) db (R);

    initial begin
        $display("Start simulation!!!");
        #50
        $finish;
    end

endmodule
