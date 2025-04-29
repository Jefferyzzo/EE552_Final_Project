//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module merge #(
parameter WIDTH	= 4 ,
parameter FL	= 0 ,
parameter BL	= 0 
) (
interface  L0   ,//A in the diagram
interface  L1   ,//B in the diagram
interface  S    ,
interface  R     //O in the diagram
); 

logic [WIDTH-1:0] packet;
logic sel;

always begin
    // ******************* Display start of operation
    //$display("Start of merge operation at time: %t", $time);

    // ******************* Receive selector value from S
    S.Receive(sel); 
    //$display("Received selector value: %0d at time: %t", sel, $time);

    // ******************* Depending on selector, choose packet from L0 or L1
    if (sel == 1'b0) begin
        //$display("Receiving packet from L0 at time: %t", $time);
        L0.Receive(packet);
    end else begin
        //$display("Receiving packet from L1 at time: %t", $time);
        L1.Receive(packet);
    end

    // ******************* Simulate forward latency
    #FL;

    // ******************* Send the packet to R
    //$display("Sending packet to R: %0h at time: %t", packet, $time);
    R.Send(packet);

    // ******************* Simulate backward latency
    #BL;

    // ******************* End of operation
    //$display("End of merge operation at time: %t", $time);
end

endmodule