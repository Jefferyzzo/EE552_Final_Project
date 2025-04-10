// `timescale 1ns/1ps
// import SystemVerilogCSP::*;


//  module router #(
//     parameter WIDTH = 14,
//     parameter WIDTH_addr = 3,
//     parameter WIDTH_dest =3,
//     parameter data = 8,
//     parameter WIDTH_packet = 14,
//     parameter FL = 2,
//     parameter BL = 1,
//     parameter MASK = 3'b001
//  ) (
//     interface parent_in, parent_out,
//     child1_in, child1_out,
//     child2_in, child2_out
//  );

//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) parent_child1();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) parent_child2();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child1_parent();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child1_child2();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child2_parent();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child2_child1();

//     //logic [WIDTH_packet-1:0]
//     //input output variables
//     logic [WIDTH_packet-1:0] in_packet, out_packet;
    

//     input_ctrl #(.MASK(MASK)) pin(
//         .in(parent_in),
//         .out1(parent_child1),
//         .out2(parent_child2)
//     );

//     output_ctrl #(.MASK(MASK)) pout(
//         .in1(child1_parent),
//         .in2(child2_parent),
//         .out(parent_out)
//     );

//     input_ctrl #(.MASK(MASK)) c1in(
//         .in(child1_in),
//         .out1(child1_parent),
//         .out2(child1_child2)
//     );

//     output_ctrl #(.MASK(MASK)) c1out(
//         .in1(parent_child1),
//         .in2(child2_child1),
//         .out(child1_out)
//     );

//     input_ctrl #(.MASK(MASK)) c2in(
//         .in(child2_in),
//         .out1(child2_child1),
//         .out2(child2_parent)
//     );

//     output_ctrl #(.MASK(MASK)) c2out(
//         .in1(child1_child2),
//         .in2(parent_child2),
//         .out(child2_out)
//     );
//     initial begin
//         $display("[%t] Router waiting for packet...", $time);
//     end


    
//  endmodule

// `timescale 1ns/1ps
// import SystemVerilogCSP::*;

// module router #(
//     parameter WIDTH_packet = 14,
//     parameter FL = 2,
//     parameter BL = 1,

//     // 地址判断参数
//     parameter ROUTER_ID   = 3'b000,
//     parameter ROUTER_MASK = 3'b000
// )(
//     interface parent_in, parent_out,
//     child1_in, child1_out,
//     child2_in, child2_out
// );

//     // 中间通道：parent <-> child1/child2
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) parent_child1();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) parent_child2();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child1_parent();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child2_parent();

//     // === parent input: 接收上层来的包，判断是发给哪个 child
//     input_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL),
//         .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
//     ) parent_input (
//         .in(parent_in),
//         .out1(parent_child1),  // 发给 child1
//         .out2(parent_child2)   // 发给 child2
//     );

//     // === parent output: 汇聚两个 child 的包 → 发给上层
//     output_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL)
//     ) parent_output (
//         .in1(child1_parent),
//         .in2(child2_parent),
//         .out(parent_out)
//     );

//     // === child1 input: 判断是发给我（parent），还是要继续往下发
//     input_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL),
//         .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
//     ) child1_input (
//         .in(child1_in),
//         .out1(child1_parent),  // 发给 parent
//         .out2()                // 没有 child 的 child，不连接
//     );

//     // === child1 output: parent 发来的包 → 发给 child1 node
//     output_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL)
//     ) child1_output (
//         .in1(parent_child1),
//         .in2(),               // 不需要第二个输入
//         .out(child1_out)
//     );

//     // === child2 input
//     input_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL),
//         .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
//     ) child2_input (
//         .in(child2_in),
//         .out1(child2_parent),
//         .out2()
//     );

//     // === child2 output
//     output_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL)
//     ) child2_output (
//         .in1(parent_child2),
//         .in2(),
//         .out(child2_out)
//     );

//     initial begin
//         $display("[%t] Router (%b) initialized", $time, ROUTER_ID);
//     end

// endmodule

// `timescale 1ns/1ps
// import SystemVerilogCSP::*;

// module router #(
//     parameter WIDTH_packet = 14,
//     parameter FL = 2,
//     parameter BL = 1,

//     // 地址判断参数
//     parameter ROUTER_ID   = 3'b000,
//     parameter ROUTER_MASK = 3'b000
// )(
//     interface parent_in, parent_out,
//     child1_in, child1_out,
//     child2_in, child2_out
// );

//     // 中间通道：parent <-> child1/child2
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) parent_child1();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) parent_child2();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child1_parent();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child2_parent();
//     Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) dummy();

//     // === parent input: 接收上层来的包，判断是发给哪个 child
//     input_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL),
//         .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
//     ) parent_input (
//         .in(parent_in),
//         .out1(parent_child1),  // 发给 child1
//         .out2(parent_child2)   // 发给 child2
//     );

//     // === parent output: 汇聚两个 child 的包 → 发给上层
//     output_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL)
//     ) parent_output (
//         .in1(child1_parent),
//         .in2(child2_parent),
//         .out(parent_out)
//     );

//     // === child1 input: 判断是发给我（parent），还是要继续往下发
//     input_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL),
//         .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
//     ) child1_input (
//         .in(child1_in),
//         .out1(child1_parent),  // 发给 parent
//         .out2(dummy)           // 占位 dummy
//     );

//     // === child1 output: parent 发来的包 → 发给 child1 node
//     output_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL)
//     ) child1_output (
//         .in1(parent_child1),
//         .in2(dummy),
//         .out(child1_out)
//     );

//     // === child2 input
//     input_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL),
//         .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
//     ) child2_input (
//         .in(child2_in),
//         .out1(child2_parent),
//         .out2(dummy)
//     );

//     // === child2 output
//     output_ctrl #(
//         .WIDTH_packet(WIDTH_packet),
//         .FL(FL), .BL(BL)
//     ) child2_output (
//         .in1(parent_child2),
//         .in2(dummy),
//         .out(child2_out)
//     );

//     initial begin
//         $display("[%t] Router (%b) initialized", $time, ROUTER_ID);
//     end

// endmodule

`timescale 1ns/1ps
import SystemVerilogCSP::*;

module router #(
    parameter WIDTH_packet = 14,
    parameter FL = 2,
    parameter BL = 1,

    // 地址判断参数
    parameter ROUTER_ID   = 3'b000,
    parameter ROUTER_MASK = 3'b000
)(
    interface parent_in, parent_out,
    child1_in, child1_out,
    child2_in, child2_out
);

    // 中间通道：parent <-> child1/child2
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) parent_child1();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) parent_child2();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child1_parent();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child2_parent();

    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) dummy_c1in();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) dummy_c1out();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) dummy_c2in();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) dummy_c2out();

    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child1_to_parent_buf();
    Channel #(.WIDTH(WIDTH_packet), .hsProtocol(P4PhaseBD)) child2_to_parent_buf();

    // === parent input: 接收上层来的包，判断是发给哪个 child
    input_ctrl #(
        .WIDTH_packet(WIDTH_packet),
        .FL(FL), .BL(BL),
        .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
    ) parent_input (
        .in(parent_in),
        .out1(parent_child1),
        .out2(parent_child2)
    );

    // === parent output: 汇聚两个 child 的包 → 发给上层
    output_ctrl #(
        .WIDTH_packet(WIDTH_packet),
        .FL(FL), .BL(BL)
    ) parent_output (
        .in1(child1_to_parent_buf),
        .in2(child2_to_parent_buf),
        .out(parent_out)
    );

    // === child1 input
    input_ctrl #(
        .WIDTH_packet(WIDTH_packet),
        .FL(FL), .BL(BL),
        .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
    ) child1_input (
        .in(child1_in),
        .out1(child1_to_parent_buf),
        .out2(dummy_c1in)
    );

    // === child1 output
    output_ctrl #(
        .WIDTH_packet(WIDTH_packet),
        .FL(FL), .BL(BL)
    ) child1_output (
        .in1(parent_child1),
        .in2(dummy_c1out),
        .out(child1_out)
    );

    // === child2 input
    input_ctrl #(
        .WIDTH_packet(WIDTH_packet),
        .FL(FL), .BL(BL),
        .ROUTER_ID(ROUTER_ID), .ROUTER_MASK(ROUTER_MASK)
    ) child2_input (
        .in(child2_in),
        .out1(child2_to_parent_buf),
        .out2(dummy_c2in)
    );

    // === child2 output
    output_ctrl #(
        .WIDTH_packet(WIDTH_packet),
        .FL(FL), .BL(BL)
    ) child2_output (
        .in1(parent_child2),
        .in2(dummy_c2out),
        .out(child2_out)
    );

    // === dummy sink logic
    initial begin
        fork
            forever begin
                logic [WIDTH_packet-1:0] sink_data;
                dummy_c1in.Receive(sink_data);
                #1;
            end
            forever begin
                logic [WIDTH_packet-1:0] sink_data;
                dummy_c1out.Receive(sink_data);
                #1;
            end
            forever begin
                logic [WIDTH_packet-1:0] sink_data;
                dummy_c2in.Receive(sink_data);
                #1;
            end
            forever begin
                logic [WIDTH_packet-1:0] sink_data;
                dummy_c2out.Receive(sink_data);
                #1;
            end
        join_none
        $display("[%t] Router (%b) initialized", $time, ROUTER_ID);
    end

endmodule












