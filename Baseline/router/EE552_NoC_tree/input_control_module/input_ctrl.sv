



// `timescale 1ns/1ps

// import SystemVerilogCSP::*;

// module input_ctrl #(
//     parameter WIDTH_packet = 14,
//     parameter WIDTH_dest = 3,
//     parameter WIDTH_addr =3,
//     parameter FL = 2,
//     parameter BL = 1,
//     parameter MASK = 3'b110,
//     parameter LEVEL = 0,
//     parameter is_parent = 0,
//     parameter NUM_NODE = 8,
//     parameter ADDR = 3'b000
// ) (interface in, out1, out2);

//     logic [WIDTH_packet-1:0] packet;
//     logic [WIDTH_dest-1:0] dest;
//     logic bit_index = 2-LEVEL;
//     logic dest_bit = dest[bit_index];

//     always begin

//         wait(in.status != idle) ;
        
//         in.Receive(packet);
//         #FL;

//         if(!is_parent) begin
        
//             if((packet[10:8] & MASK) != 0) begin
//                 out1.Send(packet);
//                 #BL;
//             end
//             else begin
//                 out2.Send(packet);
//                 #BL;
//             end
            
//         end
//         else begin
                    
//             dest_bit = packet[WIDTH_packet - WIDTH_addr - LEVEL];//WIDTH_packet - WIDTH_addr - LEVEL

//             if (dest_bit == 1'b0) begin
//                 out1.Send(packet);
//             end else begin
//                 out2.Send(packet);
//             end

//             #BL;
            
        
//         end

//     end





// endmodule

`timescale 1ns/1ps

import SystemVerilogCSP::*;

module input_ctrl #(
    parameter WIDTH_packet = 14,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr = 3,
    parameter FL = 2,
    parameter BL = 1,
    parameter LEVEL = 0,
    parameter is_parent = 0,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000
) (interface in, out1, out2);
//111

    logic [WIDTH_packet-1:0] packet; 
    logic [WIDTH_dest-1:0] dest = packet[WIDTH_packet-WIDTH_addr-1:WIDTH_packet-WIDTH_dest-WIDTH_addr];
    logic bit_index;
    logic dest_bit;
    logic [WIDTH_dest-1:0] MASK;

    always begin
        wait(in.status != idle);
        in.Receive(packet);
        #FL;

        dest = packet[10:8];

        if (!is_parent) begin
            // Generate MASK by extracting top LEVEL bits of dest  101
            MASK = 3'b111 << (WIDTH_dest - LEVEL -1);

            if ((MASK&dest) != 0) begin
                out1.Send(packet);
            end else begin
                out2.Send(packet);
            end

            #BL;
        end
        else begin
            bit_index = WIDTH_addr - 1 - LEVEL;
            dest_bit = packet[WIDTH_packet - WIDTH_addr + bit_index];

            if (dest_bit == 1'b0) begin
                out1.Send(packet);
            end else begin
                out2.Send(packet);
            end

            #BL;
        end

    end

endmodule











