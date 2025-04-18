`timescale 1ns/1ns

import SystemVerilogCSP::*;

module data_generator (interface r);

    parameter FILTER_WIDTH = 8;
    parameter PACKET_WIDTH = 28;
    parameter FL = 0;

    logic [1:0] counter = 2'b00;
    logic timestep_counter = 1'b0;
    logic [FILTER_WIDTH-1:0] filter_part [0:8];   // 3x3 filter
    logic ifmap_t1_part [0:8]; // 3x3 ifmap t1
    logic ifmap_t2_part [0:8]; // 3x3 ifmap t2
    logic [PACKET_WIDTH-1:0] rand_values [0:4];  
    logic [PACKET_WIDTH-1:0] SendValue = 0;

    initial begin
        integer file0, status0, i;
        integer file1, status1;
        integer file2, status2;

        file0 = $fopen("./scnn_script/L1_filter.txt", "r");
        file1 = $fopen("./scnn_script/ifmap_t1.txt", "r");
        file2 = $fopen("./scnn_script/ifmap_t2.txt", "r");

        if (!file0) begin
            $display("ERROR: Could not open L1_filter.txt");
            $finish;
        end

        if (!file1) begin
            $display("ERROR: Could not open ifmap_t1.txt");
            $finish;
        end

        if (!file2) begin
            $display("ERROR: Could not open ifmap_t2.txt");
            $finish;
        end

        for (i = 0; i < 9; i = i + 1) begin
            status0 = $fscanf(file0, "%d\n", filter_part[i]);
            status1 = $fscanf(file1, "%d\n", ifmap_t1_part[i]);
            status2 = $fscanf(file2, "%d\n", ifmap_t2_part[i]);
        end

        $fclose(file0);
        $fclose(file1);
        $fclose(file2);

        rand_values[0] = {filter_part[0], filter_part[1], filter_part[2], 4'b0110}; // filter row 1
        rand_values[1] = {filter_part[3], filter_part[4], filter_part[5], 4'b1010}; // filter row 2
        rand_values[2] = {filter_part[6], filter_part[7], filter_part[8], 4'b1110}; // filter row 3
        rand_values[3] = {ifmap_t1_part[6], ifmap_t1_part[7], ifmap_t1_part[8], ifmap_t1_part[3], ifmap_t1_part[4], ifmap_t1_part[5], ifmap_t1_part[0], ifmap_t1_part[1], ifmap_t1_part[2], 4'b0000}; // ifmap t1
        rand_values[4] = {ifmap_t2_part[6], ifmap_t2_part[7], ifmap_t2_part[8], ifmap_t2_part[3], ifmap_t2_part[4], ifmap_t2_part[5], ifmap_t2_part[0], ifmap_t2_part[1], ifmap_t2_part[2], 4'b0001}; // ifmap t2
    end

    always begin

        if (counter == 2'b00) begin
            SendValue = rand_values[0];     // Send filter row 1
        end else if(counter == 2'b01) begin
            SendValue = rand_values[1];     // Send filter row 2
        end else if(counter == 2'b10) begin
            SendValue = rand_values[2];     // Send filter row 3
        end else if(counter == 2'b11 && timestep_counter == 1'b0) begin
            SendValue = rand_values[3];     // Send ifmap
        end else if(counter == 2'b11 && timestep_counter == 1'b1) begin
            SendValue = rand_values[4];     // Send ifmap
        end else begin
            SendValue = 0;
        end
        #FL;
        
        r.Send(SendValue);
        if (counter == 2'b00) begin
            $display("DG %m sends filter row 1 data = %h @ %t", SendValue, $time);
        end else if(counter == 2'b01) begin
            $display("DG %m sends filter row 2 data = %h @ %t", SendValue, $time);
        end else if(counter == 2'b10) begin
            $display("DG %m sends filter row 3 data = %h @ %t", SendValue, $time);
        end else if(counter == 2'b11) begin
            $display("DG %m sends ifmap data = %b @ %t", SendValue, $time);
        end else begin
            $display("Error!!!", SendValue, $time);
        end

        if (counter < 2'b11) begin
            counter = counter + 1;
        end else begin
            counter = 2'b11;
            timestep_counter = ~timestep_counter;
        end
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
        // $display("DB %m receives output data = %b @ %t", ReceiveValue, $time);
        if (ReceiveValue[5] == 1'b0) begin
            if (ReceiveValue[32:21] == L1_residue_t1 && ReceiveValue[9] == L1_out_spike_t1) begin
                $display("\n========================== Congratulations ==========================");
                $display("Golden value for L1_residue_t1 = %b and L1_out_spike_t1 = %b", L1_residue_t1, L1_out_spike_t1);
                $display("DB %m received L1_residue_t1 = %b and L1_out_spike_t1 = %b @ %t", ReceiveValue[32:21], ReceiveValue[9], $time);
                $display("========================== Congratulations ==========================\n");
            end else begin
                $display("\nxxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxx");
                $display("Golden value for L1_residue_t1 = %b and L1_out_spike_t1 = %b", L1_residue_t1, L1_out_spike_t1);
                $display("DB %m received L1_residue_t1 = %b and L1_out_spike_t1 = %b @ %t", ReceiveValue[32:21], ReceiveValue[9], $time);
                $display("xxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxx\n");
            end
        end else begin
            if (ReceiveValue[32:21] == L1_residue_t2 && ReceiveValue[9] == L1_out_spike_t2) begin
                $display("\n========================== Congratulations ==========================");
                $display("Golden value for L1_residue_t1 = %b and L1_out_spike_t1 = %b", L1_residue_t1, L1_out_spike_t1);
                $display("DB %m received L1_residue_t2 = %b and L1_out_spike_t2 = %b @ %t", ReceiveValue[32:21], ReceiveValue[9], $time);
                $display("========================== Congratulations ==========================\n");
            end else begin
                $display("\nxxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxx");
                $display("Golden value for L1_residue_t1 = %b and L1_out_spike_t1 = %b", L1_residue_t1, L1_out_spike_t1);
                $display("DB %m received L1_residue_t2 = %b and L1_out_spike_t2 = %b @ %t", ReceiveValue[32:21], ReceiveValue[9], $time);
                $display("xxxxxxxxxxxxxxxxxxxxxx Comparison Fail xxxxxxxxxxxxxxxxxxxxxx\n");
            end
        end
        #BL;
    end

endmodule


module PE_tb ();

    parameter FILTER_WIDTH = 8;
    parameter IFMAP_SIZE   = 9;
    parameter OUTPUT_WIDTH  = 12;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+4), .hsProtocol(P4PhaseBD)) Packet_in ();
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_out ();
    Channel #(.WIDTH(1), .hsProtocol(P4PhaseBD)) OutSpike ();
    Channel #(.WIDTH(OUTPUT_WIDTH), .hsProtocol(P4PhaseBD)) Residue_copy0 ();

    // Instantiate DUT
    data_generator #(.PACKET_WIDTH(3*FILTER_WIDTH+4), .FL(0)) dg_content (Packet_in);
    // PE pe (.Packet_in(Packet_in), .OutSpike(OutSpike), .Residue_copy0(Residue_copy0));
    PE pe (.Packet_in(Packet_in), .Packet_out(Packet_out));
    // data_bucket #(.WIDTH(1), .BL(0)) db_spike (OutSpike);
    // data_bucket #(.WIDTH(OUTPUT_WIDTH), .BL(0)) db_residue0 (Residue_copy0);
    data_bucket #(.WIDTH(3*FILTER_WIDTH+9), .BL(0)) db_content (Packet_out);

    initial begin
        $display("Start simulation!!!");
        #40
        $finish;
    end

endmodule
