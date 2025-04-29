`timescale 1ns/1ns

import SystemVerilogCSP::*;


module Filter_Inst_Generator #(
    parameter WIDTH	= 14 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I,
        interface O_FIFO,
        interface O_done
    );

    logic [2:0] row, i;
    logic [WIDTH-1:0] out_packet;

    initial begin
        out_packet = 0;
        out_packet[0] = 1;
    end
    

    always begin
        I.Receive(row);
        #FL;
        for(i = 0; i < row; i++) begin
            out_packet[3:1] = i;
            O_FIFO.Send(out_packet);
            #BL;
        end
        O_done.Send();  // ????????????? ack condition
    end

endmodule