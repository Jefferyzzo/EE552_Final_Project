// `timescale 1ns/1ps

// import SystemVerilogCSP::*;

// module router_tb #(
//     parameter WIDTH = 14,
//     parameter WIDTH_addr = 3,
//     parameter WIDTH_dest =3,
//     parameter data = 8,
//     parameter WIDTH_packet = 14,
//     parameter FL = 2,
//     parameter BL = 1
// ) ;
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) dg1_parent();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) dg2_child1();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) dg3_child2();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) parent_db1();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child1_db2();
//     Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH_packet)) child2_db3();
    
//     data_generator #(.WIDTH_packet(14)) dg1(
//         .r(dg1_parent)
//     );
//     data_generator #(.WIDTH_packet(14)) dg2(
//         .r(dg2_child1)
//     );
//     data_generator #(.WIDTH_packet(14)) dg3(
//         .r(dg3_child2)
//     );
//     router #(.MASK(3'b001)) tb1(
//         .parent_in(dg1_parent),
//         .parent_out(parent_db1),
//         .child1_in(dg2_child1), 
//         .child1_out(child1_db2),
//         .child2_in(dg3_child2), 
//         .child2_out(child2_db3)
//     );
//     data_bucket #(.WIDTH(14)) db1(
//         .r(parent_db1)
//     );

//     data_bucket #(.WIDTH(14)) db2(
//         .r(child1_db2)
//     );

//     data_bucket #(.WIDTH(14)) db3(
//         .r(child2_db3)
//     );

//     initial begin
//         $display("*** Router starts ***");
//         #500;
//         //$display("*** Router starts ***");
//         $stop;
//     end
// endmodule

