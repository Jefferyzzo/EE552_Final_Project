`timescale 1ns/1ps

// import SystemVerilogCSP::*;

// module input_ctrl #(
//     parameter WIDTH_packet = 14,
//     parameter FL = 2,
//     parameter BL = 1,
//     parameter MASK = 3'b111
// ) (interface in, out1, out2);

//     logic [WIDTH_packet-1:0] packet;

//     always begin
        
//         in.Receive(packet);
//         #FL;

//         if(packet[10:8]&& MASK == 1) begin
//             out1.Send(packet);
//             #BL;
//         end
//         else begin
//             out2.Send(packet);
//             #BL;
//         end
//     end

//     // packet_in1 = 14'b10101100101001;
//     // packet_in2 = 14'b01011001010010;



// endmodule

module input_ctrl #(
    parameter WIDTH_packet = 14,
    parameter FL = 2,
    parameter BL = 1,
    parameter ROUTER_ID = 3'b000,
    parameter ROUTER_MASK = 3'b110  // e.g., match top 2 bits
)(
    interface in,
    interface out1,  // to local child
    interface out2   // to parent router
);

    logic [WIDTH_packet-1:0] packet;
    logic [2:0] dest;

    initial begin
        forever begin
            $display("[%0t] input_ctrl waiting for packet...", $time);
            in.Receive(packet);
            #FL;

            //logic [2:0] dest;
            dest = packet[10:8];

            if ((dest & ROUTER_MASK) == ROUTER_ID) begin
                $display("[%0t] input_ctrl forwarding to LOCAL (out1), dest=%b", $time, dest);
                out1.Send(packet);  // send to local child
            end else begin
                $display("[%0t] input_ctrl forwarding UPWARD (out2), dest=%b", $time, dest);
                out2.Send(packet);  // send to parent
            end

            #BL;
        end
    end
endmodule