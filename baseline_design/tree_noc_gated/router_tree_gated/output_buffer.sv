`timescale 1ns/1ps
import SystemVerilogCSP::*;

module output_buffer #(
    parameter WIDTH_packet = 28,
    parameter WIDTH_addr = 3,
    parameter WIDTH_dest = 3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest, // 34 bits total
    parameter FILENAME = "scnn_script/received_values.txt",
    parameter NUM_PACKETS = 20
)(
    interface l
);

    logic [WIDTH_packet-1:0] buffer [0:NUM_PACKETS-1];
    integer file, i;
    integer index;
    logic [WIDTH-1:0] packet_in;
    logic [WIDTH_packet-1:0] data_part;

    initial begin
        index = 0;
    end

    always begin
        //wait (l.status != idle); // Wait until r has valid data

        if (index < NUM_PACKETS) begin
            l.Receive(packet_in);

            // Correct: extract low 28 bits [27:0]
            data_part = packet_in[34:6];
            buffer[index] = data_part;

            $display("!!!Output_buffer (%m): Received packet %b | extracted data %b", packet_in, data_part);
            file = $fopen(FILENAME, "w");
            if (file == 0) begin
                $display("ERROR: Cannot open output file %s", FILENAME);
                $finish;
            end

            $display("Writing only data part to %s...", FILENAME);
            for (i = 0; i < NUM_PACKETS; i = i + 1) begin
                $fdisplay(file, "%028b", buffer[i]);
            end

            $fclose(file);

            index = index + 1;
        end

        if (index == NUM_PACKETS) begin

            $display("Finished writing all data correctly.");
            wait(1);
            $stop;
        end
    end

endmodule
