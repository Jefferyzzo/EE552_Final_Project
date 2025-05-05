//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module copy_tree #(
    parameter WIDTH_packet = 28,
    parameter WIDTH_addr = 3,
    parameter WIDTH_dest = 3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L    ,
interface  R0   ,
interface  R1    
); 

logic [WIDTH-1:0] packet;

always begin
    // ******************* Display start of operation
    //$display("Start of copy operation at time: %t", $time);

    // ******************* Receive data from input interface L
    //$display("Waiting to receive data from L at time: %t", $time);
    wait(L.status != idle) ;
    L.Receive(packet);
    //$display("Received data: %0h from L at time: %t", packet, $time);

    // ******************* Simulate forward latency
    #FL;

    // ******************* Send the received packet to R0
    //$display("Sending data to R0: %0h at time: %t", packet, $time);
    fork
    R0.Send(packet);

    // ******************* Send the received packet to R1
    //$display("Sending data to R1: %0h at time: %t", packet, $time);
    R1.Send(packet);
    join
    // ******************* Simulate backward latency
    #BL;

    // ******************* Display end of operation
    //$display("End of copy operation at time: %t", $time);
end

endmodule