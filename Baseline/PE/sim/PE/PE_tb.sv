`timescale 1ns/1ns

import SystemVerilogCSP::*;

module data_generator (interface r);

    parameter WIDTH = 8;
    parameter FL = 0; // ideal environment no forward delay

    logic [1:0]  counter = 2'b00; // used to alternate values
    logic timestep_counter = 1'b0;
    logic [23:0] rand_part [0:3];
    logic [27:0] rand_values [0:3];
    logic [WIDTH-1:0] SendValue = 0;

    always begin
        rand_values[0] = {$random() % (2**24), 4'b0110}; // filter row 1
        rand_values[1] = {$random() % (2**24), 4'b1010}; // filter row 2
        rand_values[2] = {$random() % (2**24), 4'b1110}; // filter row 3
        rand_values[3] = {$random() % (2**24), 4'b0000}; // ifmap

        if (counter == 2'b00) begin
            SendValue = rand_values[0];      // Send filter row 1
        end else if(counter == 2'b01) begin
            SendValue = rand_values[1];      // Send filter row 2
        end else if(counter == 2'b10) begin
            SendValue = rand_values[2];      // Send filter row 3
        end else if(counter == 2'b11) begin
            SendValue = rand_values[3];      // Send ifmap
            SendValue[0] = timestep_counter; 
        end else begin
            SendValue = 0;                   // Default case, should not occur
        end

        if (counter < 2'b11) begin
            counter = counter + 1; 
        end else begin
            counter = 2'b11;
            timestep_counter = ~timestep_counter; // toggle timestep counter
        end

        #FL;
        r.Send(SendValue);
        $display("DG %m sends input data = %h @ %t", SendValue, $time);
        // $display("Counter = %d", counter);
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

module PE_tb ();

    parameter FILTER_WIDTH = 8;
    parameter IFMAP_SIZE   = 9;
    parameter OUTPUT_WIDTH  = 12;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+4), .hsProtocol(P4PhaseBD)) Packet_in ();
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_out ();
    // Channel #(.WIDTH(1), .hsProtocol(P4PhaseBD)) OutSpike ();
    // Channel #(.WIDTH(OUTPUT_WIDTH), .hsProtocol(P4PhaseBD)) Residue_copy0 ();
    // Channel #(.WIDTH(OUTPUT_WIDTH), .hsProtocol(P4PhaseBD)) Residue_copy1 ();

    // Instantiate DUT
    data_generator #(.WIDTH(3*FILTER_WIDTH+4), .FL(0)) dg_content (Packet_in); 
    PE pe (.Packet_in(Packet_in), .Packet_out(Packet_out));
    // data_bucket #(.WIDTH(1), .BL(0)) db_spike (OutSpike);
    // data_bucket #(.WIDTH(OUTPUT_WIDTH), .BL(0)) db_residue0 (Residue_copy0);
    // data_bucket #(.WIDTH(OUTPUT_WIDTH), .BL(0)) db_residue1 (Residue_copy1);
    data_bucket #(.WIDTH(3*FILTER_WIDTH+9), .BL(0)) db_content (Packet_out);

    initial begin
        $display("Start simulation!!!");
        #70
        $finish;
    end

endmodule
