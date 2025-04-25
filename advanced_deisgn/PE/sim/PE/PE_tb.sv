`timescale 1ns/1ns

import SystemVerilogCSP::*;

module data_generator (interface r);

    parameter FILTER_WIDTH  = 8;
    parameter PACKET_NUMBER = 7;
    parameter FL = 0;

    logic [$clog2(PACKET_NUMBER)-1:0] counter = 0;
    logic [5*FILTER_WIDTH+4:0] SendValue;
    logic [5*FILTER_WIDTH+4:0] Packet [0:PACKET_NUMBER-1];

    initial begin
        $readmemb("./scnn_script/combined_packets.txt", Packet);
    end

    always begin
        SendValue = Packet[counter];
        #FL;
        r.Send(SendValue);
        $display("DG %m sends data = %b @ %t", SendValue, $time);
        if (counter < PACKET_NUMBER-1)
            counter = counter + 1;
        else
            counter = counter - 1;
    end

endmodule

module data_bucket (interface r);
    parameter WIDTH = 8;
    parameter OUTPUT_WIDTH = 12;
    parameter BL    = 0;

    logic [WIDTH-1:0] ReceiveValue = 0;

    // Variables to store the read-in values
    logic [OUTPUT_WIDTH-1:0] L1_residue_t1;
    logic [OUTPUT_WIDTH-1:0] L1_residue_t2;
    logic L1_out_spike_t1;
    logic L1_out_spike_t2;

    initial begin
        integer file;
        // Read L1_residue_t1
        file = $fopen("./scnn_script/L1_residue_t1.txt", "r");
        if (file) $fscanf(file, "%d\n", L1_residue_t1);
        $fclose(file);

        // Read L1_residue_t2
        file = $fopen("./scnn_script/L1_residue_t2.txt", "r");
        if (file) $fscanf(file, "%d\n", L1_residue_t2);
        $fclose(file);

        // Read L1_out_spike_t1
        file = $fopen("./scnn_script/L1_out_spike_t1.txt", "r");
        if (file) $fscanf(file, "%d\n", L1_out_spike_t1);
        $fclose(file);

        // Read L1_out_spike_t2
        file = $fopen("./scnn_script/L1_out_spike_t2.txt", "r");
        if (file) $fscanf(file, "%d\n", L1_out_spike_t2);
        $fclose(file);

        // Print values to verify
        // $display("Read L1_residue_t1 = %0d", L1_residue_t1);
        // $display("Read L1_residue_t2 = %0d", L1_residue_t2);
        // $display("Read L1_out_spike_t1 = %0d", L1_out_spike_t1);
        // $display("Read L1_out_spike_t2 = %0d", L1_out_spike_t2);
    end

    always begin
        r.Receive(ReceiveValue);
        $display("DB %m receives output data = %b @ %t", ReceiveValue, $time);
        if (ReceiveValue[8] == 1'b0) begin
            if (ReceiveValue[26:14] == L1_residue_t1 && ReceiveValue[9] == L1_out_spike_t1) begin
                $display("\n==================================================== Congratulations ====================================================");
                $display("Golden value             for L1_residue_t1 = %d and L1_out_spike_t1 = %b", L1_residue_t1, L1_out_spike_t1);
                $display("DB %m received L1_residue_t1 = %d and L1_out_spike_t1 = %b @ %t", ReceiveValue[26:14], ReceiveValue[9], $time);
                $display("==================================================== Congratulations ====================================================\n");
            end else begin
                $display("\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
                $display("Golden value             for L1_residue_t1 = %d and L1_out_spike_t1 = %b", L1_residue_t1, L1_out_spike_t1);
                $display("DB %m received L1_residue_t1 = %d and L1_out_spike_t1 = %b @ %t", ReceiveValue[26:14], ReceiveValue[9], $time);
                $display("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
            end
        end else begin
            if (ReceiveValue[1:0] == 2'b11) begin
                if (ReceiveValue[26:14] == L1_residue_t2 && ReceiveValue[9] == L1_out_spike_t2) begin
                    $display("\n==================================================== Congratulations ====================================================");
                    $display("Golden value             for L1_residue_t2 = %d and L1_out_spike_t2 = %b", L1_residue_t2, L1_out_spike_t2);
                    $display("DB %m received L1_residue_t2 = %d and L1_out_spike_t2 = %b @ %t", ReceiveValue[26:14], ReceiveValue[9], $time);
                    $display("==================================================== Congratulations ====================================================\n");
                end else begin
                    $display("\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
                    $display("Golden value             for L1_residue_t2 = %d and L1_out_spike_t2 = %b", L1_residue_t2, L1_out_spike_t2);
                    $display("DB %m received L1_residue_t2 = %d and L1_out_spike_t2 = %b @ %t", ReceiveValue[26:14], ReceiveValue[9], $time);
                    $display("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
                end
            end
        end
        #BL;
    end

endmodule


module PE_tb ();

    parameter FILTER_WIDTH  = 8;
    parameter IFMAP_SIZE    = 25;
    parameter OUTPUT_WIDTH  = 13;
    parameter THRESHOLD     = 64;
    parameter FL	        = 2;
    parameter BL	        = 1;
    parameter DIRECTION_OUT = 3;
    parameter X_HOP_OUT     = 0;
    parameter Y_HOP_OUT     = 0;
    parameter PE_NODE       = 0;
    parameter X_HOP_ACK     = 0;
    parameter Y_HOP_ACK     = 0;
    parameter DIRECTION_ACK = 0;
    parameter PACKET_NUMBER = 6;

    // Instantiate interfaces  
    Channel #(.WIDTH(5*FILTER_WIDTH+5), .hsProtocol(P4PhaseBD)) Packet_in ();
    Channel #(.WIDTH(5*FILTER_WIDTH+13), .hsProtocol(P4PhaseBD)) Packet_out ();

    // Instantiate DUT
    data_generator #(.FILTER_WIDTH(FILTER_WIDTH), .PACKET_NUMBER(PACKET_NUMBER), .FL(0)) data_generator (Packet_in);

    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),	        
        .BL(BL),        
        .DIRECTION_OUT(DIRECTION_OUT),
        .X_HOP_OUT(X_HOP_OUT),     
        .Y_HOP_OUT(Y_HOP_OUT),    
        .PE_NODE(PE_NODE),       
        .X_HOP_ACK(X_HOP_ACK),     
        .Y_HOP_ACK(Y_HOP_ACK),    
        .DIRECTION_ACK(DIRECTION_ACK)
    ) PE (
        .Packet_in(Packet_in), 
        .Packet_out(Packet_out)
    );

    data_bucket #(.WIDTH(5*FILTER_WIDTH+13), .BL(0)) data_bucket (Packet_out);

    initial begin
        $display("Start simulation!!!");
        #75;
        $finish;
    end

endmodule
