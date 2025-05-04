`timescale 1ns/1ns

import SystemVerilogCSP::*;


module Allocate #(
    parameter WIDTH_FIL	= 15 ,
    parameter WIDTH_IF	= 18 ,
    parameter WIDTH_OUT	= 14 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I_fil,
        interface I_if,
        interface O[13:0]
    );

    logic sel;
    logic [2:0] row, i;
    logic [WIDTH_FIL-1:0] packet_fil;
    logic [WIDTH_IF-1:0] packet_if;
    integer j;

    initial begin
        sel = 0;
    end
    

    always begin

        if(sel == 0) begin  // cause problem???????????
            I_fil.Receive(packet_fil);
            // $display("At %t, alloc receives filgen packet %b", $time, packet_fil);
            #FL;
            sel = packet_fil[WIDTH_FIL-1];
            fork
                O[0].Send(packet_fil[WIDTH_OUT-1:0]);
                O[1].Send(packet_fil[WIDTH_OUT-1:0]);
                O[2].Send(packet_fil[WIDTH_OUT-1:0]);
                O[3].Send(packet_fil[WIDTH_OUT-1:0]);
                O[4].Send(packet_fil[WIDTH_OUT-1:0]);
                O[5].Send(packet_fil[WIDTH_OUT-1:0]);
                O[6].Send(packet_fil[WIDTH_OUT-1:0]);
                O[7].Send(packet_fil[WIDTH_OUT-1:0]);
                O[8].Send(packet_fil[WIDTH_OUT-1:0]);
                O[9].Send(packet_fil[WIDTH_OUT-1:0]);
                O[10].Send(packet_fil[WIDTH_OUT-1:0]);
                O[11].Send(packet_fil[WIDTH_OUT-1:0]);
                O[12].Send(packet_fil[WIDTH_OUT-1:0]);
                O[13].Send(packet_fil[WIDTH_OUT-1:0]);
            join
            // $display("At %t, alloc finished sending to FIFO %b", $time, packet_fil[WIDTH_OUT-1:0]);
            #BL;
        end
        else begin
            I_if.Receive(packet_if);
            // $display("At %t, alloc receives ifgen packet %b", $time, packet_if);
            #FL;
            // $display("At %t, alloc send packet if to node %b", $time, packet_if[WIDTH_IF-1:WIDTH_OUT]);
            case (packet_if[WIDTH_IF-1:WIDTH_OUT])
                4'd0 : O[0].Send(packet_if[WIDTH_OUT-1:0]);
                4'd1 : O[1].Send(packet_if[WIDTH_OUT-1:0]);
                4'd2 : O[2].Send(packet_if[WIDTH_OUT-1:0]);
                4'd3 : O[3].Send(packet_if[WIDTH_OUT-1:0]);
                4'd4 : O[4].Send(packet_if[WIDTH_OUT-1:0]);
                4'd5 : O[5].Send(packet_if[WIDTH_OUT-1:0]);
                4'd6 : O[6].Send(packet_if[WIDTH_OUT-1:0]);
                4'd7 : O[7].Send(packet_if[WIDTH_OUT-1:0]);
                4'd8 : O[8].Send(packet_if[WIDTH_OUT-1:0]);
                4'd9 : O[9].Send(packet_if[WIDTH_OUT-1:0]);
                4'd10: O[10].Send(packet_if[WIDTH_OUT-1:0]);
                4'd11: O[11].Send(packet_if[WIDTH_OUT-1:0]);
                4'd12: O[12].Send(packet_if[WIDTH_OUT-1:0]);
                4'd13: O[13].Send(packet_if[WIDTH_OUT-1:0]);
                default: ; 
            endcase
            #BL;
        end
    end

endmodule