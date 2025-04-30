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
            #BL;
        end
        else begin
            I_if.Receive(packet_if);
            #FL;
            O[packet_if[WIDTH_IF-1:WIDTH_OUT]].Send(packet_if[WIDTH_OUT-1:0]);
            #BL;
        end
    end

endmodule