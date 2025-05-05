`timescale 1ns/1ps
import SystemVerilogCSP::*;

module input_buffer #(
    parameter WIDTH_packet = 28,
    parameter WIDTH_addr = 3,
    parameter WIDTH_dest = 3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest,
    parameter FILENAME = "scnn_script/send_values_bin.txt",
    //parameter FILENAME = "test.txt",
    parameter NUM_PACKETS = 20
)(
    interface r
    //interface l,
    //output logic valid,
    //output logic [WIDTH-1:0] packet_out
);

    logic [WIDTH_packet-1:0] buffer [0:NUM_PACKETS-1];
    integer file, s, i;
    integer index;
    logic valid;
    logic [WIDTH_addr-1:0] addr;
    logic [WIDTH_dest-1:0] dest;
    logic [WIDTH-1:0] packet_out;

    initial begin
        file = $fopen(FILENAME, "r");
        if (file == 0) begin
            $display("ERROR: Cannot open file %s", FILENAME);
            $finish;
        end
        for (i = 0; i < NUM_PACKETS; i = i + 1) begin
            s = $fscanf(file, "%b\n", buffer[i]);
        end
        $fclose(file);
        index = 0;
        valid = 0;
        //#2000;
        //$stop;
    end

    always begin
        
        if (index < NUM_PACKETS) begin
            addr = 3'b000;  // Assign address as index (example)
            //dest = ~index[WIDTH_dest-1:0]; 
            case (index % 4)// Assign dest as inverted index (example)
                0: dest = 3'b001;
                1: dest = 3'b010;
                2: dest = 3'b011;
                3: dest = 3'b100;
                default: dest = 3'b001;
            endcase
            packet_out = { buffer[index],addr, dest};
            valid = 1;
            index = index + 1;
            $display("???Start send %d value %b ", index, packet_out);
            r.Send(packet_out);
            $display("???Input_buffer (%m): Sent %b", packet_out);
        end 
        else 
            #500;
        // if (index == NUM_PACKETS) begin
        //     $display("input_buffer: Finished sending all packets.");
            
        //     wait(1000);
        //     $stop; // Add this!
        // end
    end

endmodule
