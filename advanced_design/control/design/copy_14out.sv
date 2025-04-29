//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module copy_14out #(
parameter WIDTH	= 4 ,
parameter FL	= 2 ,
parameter BL	= 2 
) (
interface  L    ,
interface  R[13:0]   
); 

logic [WIDTH-1:0] packet;

always begin
    L.Receive(packet);
    #FL;
    fork
        R[0].Send(packet);
        R[1].Send(packet);
        R[2].Send(packet);
        R[3].Send(packet);
        R[4].Send(packet);
        R[5].Send(packet);
        R[6].Send(packet);
        R[7].Send(packet);
        R[8].Send(packet);
        R[9].Send(packet);
        R[10].Send(packet);
        R[11].Send(packet);
        R[12].Send(packet);
        R[13].Send(packet);
    join
    #BL;
end




endmodule