// // `timescale 1ns/1ns
// // import SystemVerilogCSP::*;



// // module router_tb ();

// //     // Parameter definitions
// //     parameter WIDTH_packet = 14;
    
// //     // Clock signal
// //     reg clk;
// //     initial begin
// //         clk = 0;
// //         forever #5 clk = ~clk; // 10ns clock period
// //         #200;
// //         $stop;
// //     end
    
// //     // Interface signals
// //     logic [WIDTH_packet-1:0] packet_0, packet_1, packet_2, packet_3,packet_4,packet_5;
    
// //     // Instantiate interfaces  
// //     Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L0 ();
// //     Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L1 ();
// //     Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L2 ();
// //     Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) R0 ();
// //     Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) R1 ();
// //     Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) R2 ();
    
// //     // Instantiate DUT
// //     router #(.WIDTH_packet(WIDTH_packet)) dut (
// //         .parent_in(L0),
// //         .parent_out(R0),
// //         .child1_in(L1),
// //         .child1_out(R1),
// //         .child2_in(L2),
// //         .child2_out(R2)
// //     );
// //     // Monitor outputs
// //     data_bucket #(.WIDTH_packet(WIDTH_packet)) db1(.r(R0));
// //     data_bucket #(.WIDTH_packet(WIDTH_packet)) db2(.r(R1));
// //     data_bucket #(.WIDTH_packet(WIDTH_packet)) db3(.r(R2));

// //     // Stimulus generation
// //     always begin
// //         // Initialize signals
// //         packet_0 = 14'b10100000100000;
// //         packet_1 = 14'b01011111000000;
// //         packet_2 = 14'b01101010111110;
// //         packet_3 = 14'b11000100111110;
// //         packet_4 = 14'b01100101111101;
// //         packet_5 = 14'b11000101111110;
        
// //         #10;
// //         L0.Send(packet_0); // L0 makes a request
// //         #10;
// //         L1.Send(packet_1); // L1 makes a request
// //         #20;
// //         L2.Send(packet_3);
// //         #10;
// //         fork
// //             L0.Send(packet_2); // L0 makes a request
// //             L1.Send(packet_3); // L1 makes a request
// //             L2.Send(packet_5);
// //         join
// //         #20;
// //         fork
// //             L0.Send(packet_0); // L0 makes a request
// //             L1.Send(packet_1); // L1 makes a request
// //         join
// //         #20;
// //         //$stop;
// //     end
    


// // endmodule

// `timescale 1ns/1ns
// import SystemVerilogCSP::*;

// module router_tb ();

//     // Parameter definitions
//     parameter WIDTH_packet = 14;
//     parameter FL = 2;
//     parameter BL = 1;

//     // Clock signal
//     reg clk;
//     initial begin
//         clk = 0;
//         forever #5 clk = ~clk;
//     end

//     // Channels: test 1 router in tree NoC
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L0();  // parent_in
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L1();  // child1_in
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L2();  // child2_in
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R0();  // parent_out
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R1();  // child1_out
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R2();  // child2_out

//     // Instantiate Router Under Test (responsible for 000 and 001)
//     router #(
//         .WIDTH_packet(14),
//         .WIDTH_dest(3),
//         .WIDTH_addr(3),
//         .FL(2),
//         .BL(1),
//         .MASK(3'b110),
//         .LEVEL(2),
//         .NUM_NODE(8),
//         .ADDR(3'b000)  // match top 2 bits = 00 => 000, 001
//     ) dut (
//         .parent_in(L0),
//         .parent_out(R0),
//         .child1_in(L1),
//         .child1_out(R1),
//         .child2_in(L2),
//         .child2_out(R2)
//     );

//     // Monitor outputs
//     data_bucket #(.WIDTH_packet(WIDTH_packet), .NODE(0)) db0(.r(R0));
//     data_bucket #(.WIDTH_packet(WIDTH_packet), .NODE(1)) db1(.r(R1));
//     data_bucket #(.WIDTH_packet(WIDTH_packet), .NODE(2)) db2(.r(R2));

//     // Stimulus generation
//     initial begin
//         $display("*** router_tb simulation starts ***");
//         #1000;
//         $display("*** Simulation ends ***");
//         $stop;
//     end

//     initial begin
//         logic [WIDTH_packet-1:0] packet;

//         // Packet: dest=001 (should match ROUTER_ID)
//         packet = 14'b00001001000001; // dest=001
//         #10; L0.Send(packet);

//         // Packet: dest=000 (should go to child1)
//         packet = 14'b00000001000000; // dest=000
//         #20; L1.Send(packet);

//         // Packet: dest=010 (not match => go upward)
//         packet = 14'b00010010000010; // dest=010
//         #20; L2.Send(packet);

//         // Simulate concurrent sends
//         fork
//             L1.Send(14'b00000001111000); // to child1
//             L2.Send(14'b00000010111101); // to child2
//         join

//         #100;
//     end

// endmodule



`timescale 1ns/1ps
import SystemVerilogCSP::*;

module router_tb #(
    parameter WIDTH_packet = 14,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter FL = 2,
    parameter BL = 1,
    parameter MASK = 3'b110,
    parameter LEVEL = 0,
    parameter is_parent = 0,
    parameter NUM_NODE = 8,
    parameter ADDR = 3'b000
);

    //parameter WIDTH_packet = 14;

    // Channels
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L0();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L1();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L2();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R0();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R1();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R2();

    // CSPInterfaces
    // CSPInterface L  = new ch_gen_to_ctrl;
    // CSPInterface R0 = new ch_ctrl_to_r0;
    // CSPInterface R1 = new ch_ctrl_to_r1;

    // Instantiate input_ctrl DUT
    router #(
        .WIDTH_packet(14),
        .WIDTH_dest(3),
        .WIDTH_addr(3),
        .FL(2),
        .BL(1),
        .MASK(3'b110),
        .LEVEL(2),
        .NUM_NODE(8),
        .ADDR(3'b000)
    ) dut (
        .parent_in(L0), 
        .parent_out(R0),
        .child1_in(L1), 
        .child1_out(R1),
        .child2_in(L2), 
        .child2_out(R2)
    );

    // Generator (sends 2 fixed packets)
    data_generator #(
        .WIDTH_packet(WIDTH_packet)
    ) gen0 (
        .r(L0)
    );

    data_generator #(
        .WIDTH_packet(WIDTH_packet)
    ) gen1 (
        .r(L1)
    );

    data_generator #(
        .WIDTH_packet(WIDTH_packet)
    ) gen2 (
        .r(L2)
    );

    // Buckets (passively receive and print)
    data_bucket #(
        .WIDTH_packet(WIDTH_packet),
        .NODE(0)
    ) bucket0 (
        .r(R0)
    );

    data_bucket #(
        .WIDTH_packet(WIDTH_packet),
        .NODE(1)
    ) bucket1 (
        .r(R1)
    );

    data_bucket #(
        .WIDTH_packet(WIDTH_packet),
        .NODE(1)
    ) bucket2 (
        .r(R2)
    );

    // Simulation control
    initial begin
        $display("*** input_ctrl_tb simulation starts ***");
        #500;
        $display("*** Simulation ends ***");
        $stop;
    end

endmodule



