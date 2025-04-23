`timescale 1ns/1ns

import SystemVerilogCSP::*;

module data_generator (interface r);

    parameter WIDTH = 8;
    parameter FL    = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0; 

    // File handle for dumping SendValue
    integer send_file;

    // Open the file at the start of simulation
    initial begin
        send_file = $fopen("send_values.txt", "w");
        if (send_file == 0) begin
            $display("Error: Could not open send_values.txt for writing.");
            $finish;
        end
    end

    always begin 
        SendValue = $random() % (2**WIDTH); // random number in the range [0, 2^WIDTH-1]
        #FL;   
        r.Send(SendValue);
        // Dump value to the file along with the simulation time.
        $fdisplay(send_file, "Time: %0t - Sent Value: %b", $time, SendValue);
    end

    // Optionally close the file at the end of simulation if you want to make sure the dump is complete.
    final begin
        $fclose(send_file);
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

module data_bucket3 (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; // ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    // File handle for dumping ReceiveValue
    integer recv_file;

    // Open the file at the start of simulation
    initial begin
        recv_file = $fopen("recv_data.txt", "w");
        if (recv_file == 0) begin
            $display("Error: Could not open recv_data.txt for writing.");
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

module depacketizer_tb ();

    parameter FILTER_WIDTH = 8;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+4),.hsProtocol(P4PhaseBD)) Packet ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Ifmapb_filter ();
    Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) Filter_row ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Data ();
    
    // Instantiate DUT
    data_generator #(.WIDTH(3*FILTER_WIDTH+4), .FL(0)) dg (Packet);
    depacketizer #(.FILTER_WIDTH(FILTER_WIDTH)) dp (.Packet(Packet), .Timestep(Timestep), .Ifmapb_filter(Ifmapb_filter), .Filter_row(Filter_row), .Data(Data));
    data_bucket0 #(.WIDTH(1), .BL(0)) timestep (Timestep);
    data_bucket1 #(.WIDTH(1), .BL(0)) ifmapb_filter (Ifmapb_filter);
    data_bucket2 #(.WIDTH(2), .BL(0)) filter_row (Filter_row);
    data_bucket3 #(.WIDTH(3*FILTER_WIDTH), .BL(0)) data (Data);

    initial begin
        $display("Start simulation!!!");
        #50
        $finish;
    end

endmodule
