`timescale 1ns/1ns

import SystemVerilogCSP::*;


module Filter_Inst_Generator #(
    parameter WIDTH	= 15 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    )(
        interface I,
        interface O_FIFO
    );

    logic [2:0] fil_size, i;
    logic [WIDTH-1:0] out_packet;

    initial begin
        out_packet = 0;
        out_packet[0] = 1;
    end
    

    always begin
        I.Receive(fil_size);
        #FL;
        for(i = 0; i < fil_size; i++) begin
            if(i < fil_size) out_packet[14] = 1'b0;
            else out_packet[14] = 1'b1;

            out_packet[3:1] = i;
            O_FIFO.Send(out_packet);
            #BL;
        end
    end

endmodule