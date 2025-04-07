module data_generator0 (interface r);

    parameter WIDTH = 8;
    parameter FL    = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0; 

    // File handle for dumping SendValue
    integer send_file;

    // Open the file at the start of simulation
    initial begin
        send_file = $fopen("send_timestep.txt", "w");
        if (send_file == 0) begin
            $display("Error: Could not open send_timestep.txt for writing.");
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

module data_generator1 (interface r);

    parameter WIDTH = 8;
    parameter FL    = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0; 

    // File handle for dumping SendValue
    integer send_file;

    // Open the file at the start of simulation
    initial begin
        send_file = $fopen("send_residue.txt", "w");
        if (send_file == 0) begin
            $display("Error: Could not open send_residue.txt for writing.");
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

module data_generator2 (interface r);

    parameter WIDTH = 8;
    parameter FL    = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0; 

    // File handle for dumping SendValue
    integer send_file;

    // Open the file at the start of simulation
    initial begin
        send_file = $fopen("send_outspike.txt", "w");
        if (send_file == 0) begin
            $display("Error: Could not open send_outspike.txt for writing.");
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


module packetizer_tb ();

    parameter FILTER_WIDTH = 8;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep ();
    Channel #(.WIDTH(FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Residue ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Outspike ();
    Channel #(.WIDTH(9+3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Packet ();
    
    // Instantiate DUT
    data_generator0 #(.WIDTH(1), .FL(0)) dg (Timestep);
    data_generator1 #(.WIDTH(FILTER_WIDTH), .FL(0)) dg (Residue);
    data_generator2 #(.WIDTH(1), .FL(0)) dg (Outspike);

    packetizer #(.FILTER_WIDTH(FILTER_WIDTH)) packet (.Timestep(Timestep), .Residue(Residue), .Outspike(Outspike));
    data_bucket #(.WIDTH(1), .BL(0)) timestep (Timestep);

    initial begin
        $display("Start simulation!!!");
        #50
        $finish;
    end

endmodule