`timescale 1ns/1ps

import SystemVerilogCSP::*;
module router_test #(
    parameter FL = 2,
    parameter BL = 1,
    parameter WIDTH_packet = 14
) ;

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) in[2:0]();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) out[2:0]();

    router DUT(
        in[0],out[0],//parent
        in[1],out[1],//child1
        in[2],out[2]//child2
    );

    data_bucket parent_bucket(out[0]);
    data_bucket child1_bucket(out[1]);
    data_bucket child2_bucket(out[2]);

    logic [WIDTH_packet-1:0] packet;

    initial begin
        //parent to child1
            packet[13:11] = 3'b100;
            packet[10:8] = 3'b000;
            packet[7:0] = 8'b10100011;

            #FL;
            in[0].Send(packet);
            $display("send: %b",packet);
            #BL;
        //parents to child2
            packet[13:11] = 3'b011;
            packet[10:8] = 3'b001;
            packet[7:0] = 8'b10100011;
            #FL;
            in[0].Send(packet);
            $display("send: %b",packet);
            #BL;
        //child1 to parent
            packet[13:11] = 3'b000;
            packet[10:8] = 3'b010;
            packet[7:0] = 8'b10100011;
            #FL;
            in[1].Send(packet);
            $display("send: %b",packet);
            #BL;
        //child1 to child2
            packet[13:11] = 3'b000;
            packet[10:8] = 3'b001;
            packet[7:0] = 8'b10100011;
            #FL;
            in[1].Send(packet);
            $display("send: %b",packet);
            #BL;
        //child2 to parent
            packet[13:11] = 3'b001;
            packet[10:8] = 3'b011;
            packet[7:0] = 8'b10100011;
            #FL;
            in[2].Send(packet);
            $display("send: %b",packet);
            #BL;
        //child2 to child1
            packet[13:11] = 3'b001;
            packet[10:8] = 3'b000;
            packet[7:0] = 8'b10100011;
            #FL;
            in[2].Send(packet);
            $display("send: %b",packet);
            #BL;
    end
    initial begin
        #100;
        $display("*** Router start ***");
        $stop;
    end

    
endmodule