// `timescale 1ns/1ps
// import SystemVerilogCSP::*;

// module output_ctrl_tb;

//     parameter WIDTH_packet = 14;

//     // Channels
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) in1();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) in2();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) out();

//     // Interfaces
//     //CSPInterface in1 = new ch_in1;
//     //CSPInterface in2 = new ch_in2;
//     //CSPInterface out = new ch_out;

//     // Instantiate DUT
//     output_ctrl #(
//         .MASK(3'b001)  // 这个参数目前不影响 arbiter_2to1 行为，可留作扩展用途
//     ) dut (
//         .in1(in1),
//         .in2(in2),
//         .out(out)
//     );

//     // Instantiate two generators
//     data_generator #(
//         .WIDTH_packet(14),
//         .FL(2)
//       ) gen1 (
//         .r(in1)
//       );
      
//       data_generator #(
//         .WIDTH_packet(14),
//         .FL(2) 
//       ) gen2 (
//         .r(in2)
//       );

//     // Output receiver
//     data_bucket #(
//         .WIDTH_packet(WIDTH_packet),
//         .NODE(99) // 自定义 node id 表示接收端
//     ) bucket (
//         .r(out)
//     );

//     // Control simulation runtime
//     initial begin
//         $display("*** output_ctrl_tb simulation starts ***");
//         #2000;
//         $display("*** Simulation ends ***");
//         $stop;
//     end

// endmodule

`timescale 1ns/1ns
import SystemVerilogCSP::*;



module output_ctrl_tb ();

    // Parameter definitions
    parameter WIDTH_packet = 14;
    
    // Clock signal
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
        #200;
        $stop;
    end
    
    // Interface signals
    logic [WIDTH_packet-1:0] packet_0, packet_1, packet_2, packet_3;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L0 ();
    Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) L1 ();
    Channel #(.WIDTH(WIDTH_packet),.hsProtocol(P4PhaseBD)) R ();
    
    // Instantiate DUT
    output_ctrl #(.WIDTH_packet(WIDTH_packet)) dut (
        .in1(L0),
        .in2(L1),
        .out(R)
    );
    // Monitor outputs
    data_bucket #(.WIDTH_packet(WIDTH_packet)) db(.r(R));

    // Stimulus generation
    always begin
        // Initialize signals
        packet_0 = 14'b10100000100000;
        packet_1 = 14'b01011111000000;
        packet_2 = 14'b01101010111110;
        packet_3 = 14'b11000100111110;
        
        #10;
        L0.Send(packet_0); // L0 makes a request
        #10;
        L1.Send(packet_1); // L1 makes a request
        #20;
        fork
            L0.Send(packet_2); // L0 makes a request
            L1.Send(packet_3); // L1 makes a request
        join
        #20;
        fork
            L0.Send(packet_0); // L0 makes a request
            L1.Send(packet_1); // L1 makes a request
        join
        #20;
        //$stop;
    end
    


endmodule

// `timescale 1ns/1ps
// import SystemVerilogCSP::*;

// module output_ctrl_tb;

//     parameter WIDTH_packet = 14;

//     // 通道定义
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L0 ();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) L1 ();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) R ();

//     // DUT
//     output_ctrl #(.WIDTH_packet(WIDTH_packet)) dut (
//         .in1(L0),
//         .in2(L1),
//         .out(R)
//     );

//     // 输出端 bucket
//     data_bucket #(.WIDTH_packet(WIDTH_packet)) db(.r(R));

//     logic [WIDTH_packet-1:0] pkt = $urandom_range(0, 2**WIDTH_packet - 1);
//     int target = $urandom_range(0, 1); // 0: L0, 1: L1

//     // 随机发包逻辑
//     initial begin
//         $display("*** output_ctrl_tb simulation starts ***");
        
            
//             #($urandom_range(2, 10)); // 加一点随机延迟

//             if (target == 0) begin
//                 $display("[%0t] Sending packet %b to L0", $time, pkt);
//                 L0.Send(pkt);
//             end else begin
//                 $display("[%0t] Sending packet %b to L1", $time, pkt);
//                 L1.Send(pkt);
//             end
        
//     end

//     // 控制仿真时间
//     initial begin
//         #20000; // 模拟20,000ns
//         $display("*** Simulation ends ***");
//         $stop;
//     end

// endmodule


