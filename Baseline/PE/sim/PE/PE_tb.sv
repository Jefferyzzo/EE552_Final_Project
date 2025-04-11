`timescale 1ns/1ns

import SystemVerilogCSP::*;

module data_generator (interface r);

    parameter WIDTH = 8;
    parameter FL = 0; // ideal environment no forward delay

    logic [WIDTH-1:0] SendValue = 0;
    logic [1:0]  counter = 2'b00; // used to alternate values
    logic [23:0] rand_part [0:3];
    logic [27:0] rand_values [0:3];

    always begin
        rand_values[0] = {$random() % (2**24), 4'b0110}; // filter row 1
        rand_values[1] = {$random() % (2**24), 4'b1010}; // filter row 2
        rand_values[2] = {$random() % (2**24), 4'b1110}; // filter row 3
        rand_values[3] = {$random() % (2**24), 4'b0000}; // ifmap

        if (counter == 2'b00) begin
            SendValue = rand_values[0];
        end else if(counter == 2'b01) begin
            SendValue = rand_values[1];
        end else if(counter == 2'b10) begin
            SendValue = rand_values[2];
        end else if(counter == 2'b11) begin
            SendValue = rand_values[3];
        end else begin
            SendValue = 0; // Default case, should not occur
        end

        if (counter < 2'b11) begin
            counter = counter + 1; 
        end else begin
            counter = 2'b11; 
        end

        #FL;
        r.Send(SendValue);
        $display("DG %m sends input data = %b @ %t", SendValue, $time);
    end

endmodule

module data_bucket (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; //ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    always begin
        r.Receive(ReceiveValue);
        $display("DB %m receives output data = %b @ %t", ReceiveValue, $time);
        #BL;
    end

endmodule

module PE_tb ();

    parameter FILTER_WIDTH = 8;
    parameter IFMAP_SIZE   = 9;
    parameter OUTPUT_WIDTH  = 12;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+4), .hsProtocol(P4PhaseBD)) Packet ();
    // Channel #(.WIDTH(3*FILTER_WIDTH), .hsProtocol(P4PhaseBD)) Filter_row1_data_copy0 ();
    // Channel #(.WIDTH(3*FILTER_WIDTH), .hsProtocol(P4PhaseBD)) Filter_row2_data_copy0 ();
    // Channel #(.WIDTH(3*FILTER_WIDTH), .hsProtocol(P4PhaseBD)) Filter_row3_data_copy0 ();
    // Channel #(.WIDTH(IFMAP_SIZE), .hsProtocol(P4PhaseBD)) Ifmap_data ();
    Channel #(.WIDTH(OUTPUT_WIDTH), .hsProtocol(P4PhaseBD)) Out ();
    // Instantiate DUT

    data_generator #(.WIDTH(3*FILTER_WIDTH+4), .FL(0)) dg_content (Packet); 
    pe pe (.Packet(Packet), .Out(Out));
    data_bucket #(.WIDTH(OUTPUT_WIDTH), .BL(0)) db (Out);
    // data_bucket #(.WIDTH(3*FILTER_WIDTH), .BL(0)) db_row2 (Filter_row2_data_copy0);
    // data_bucket #(.WIDTH(3*FILTER_WIDTH), .BL(0)) db_row3 (Filter_row3_data_copy0);
    // data_bucket #(.WIDTH(IFMAP_SIZE), .BL(0)) db_ifmap (Ifmap_data);

    initial begin
        $display("Start simulation!!!");
        #50
        $finish;
    end

endmodule
