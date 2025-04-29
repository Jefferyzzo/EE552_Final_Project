`timescale 1ns/1ns

import SystemVerilogCSP::*;


module merge_sp #(
    parameter WIDTH	= 14 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I_fil,
        interface I_if,
        interface I_fil_done,
        interface O
    );

    logic sel;
    logic [2:0] row, i;
    logic [WIDTH-1:0] packet;

    initial begin
        sel = 0;
    end

    always begin
        I_fil_done.Receive();
        sel = 1;
        #FL; // ???????? acceptable?
    end
    

    always begin

        if(sel == 0) begin  // ???????? acceptable?
            I_fil.Receive(packet);
            #FL;
            O.Send(packet);
            #BL;
        end
        else begin
            I_if.Receive(packet);
            #FL;
            O.Send(packet);
            #BL;
        end
    end

endmodule