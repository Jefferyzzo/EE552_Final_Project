`timescale 1ns/1ps

import SystemVerilogCSP::*;

module input_ctrl #(
    parameter WIDTH_packet = 14,
    parameter FL = 2,
    parameter BL = 1,
    parameter MASK = 3'b111
) (interface in, out1, out2);

    logic [WIDTH_packet-1:0] packet;

    always begin
        
        in.Receive(packet);
        #FL;

        if(packet[10:8]&& MASK == 1) begin
            out1.Send(packet);
            #BL;
        end
        else begin
            out2.Send(packet);
            #BL;
        end
    end

    // packet_in1 = 14'b10101100101001;
    // packet_in2 = 14'b01011001010010;



endmodule