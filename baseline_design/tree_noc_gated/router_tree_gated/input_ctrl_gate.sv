//  `timescale 1ns/1ps

// import SystemVerilogCSP::*;

// module input_ctrl_gate #(
//     parameter WIDTH_packet = 14,
//     parameter WIDTH_dest = 3,
//     parameter WIDTH_addr = 3,
//     parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest,
//     parameter FL = 2,
//     parameter BL = 1,
//     parameter LEVEL = 0,
//     parameter IS_PARENT = 0,
//     //parameter IS_LCHILD = 0,
//     parameter NUM_NODE = 8
//     ///parameter router_addr = 3'b000
// ) (interface in, out1, out2);

//     logic rreq;
//     logic rack;
//     logic sel_rreq;


//     logic [WIDTH_packet-1:0] packet; 
//     logic [WIDTH_dest-1:0] dest;
//     logic [WIDTH_addr-1:0] addr;
//     logic [$clog2(WIDTH_dest)-1:0] bit_index;
//     logic dest_bit;
//     logic addr_bit;
//     logic [WIDTH_dest-1:0]mask;
//     logic [WIDTH_dest-1:0]masked_dest;
//     logic masked_dest_bit;

//     // assign rack = out1.ack || out2.ack;
//     always @(*) begin
//         if(!sel_rreq) out1.req = rreq;
//         else out2.req = rreq;
//     end

//     always @(*) begin
//         rack = out1.ack || out2.ack;
//         out1.data = packet;
//         out2.data = packet;
//     end
//     // assign out1.data = packet;
//     // assign out2.data = packet;



//     click_controller #( .WIDTH(WIDTH_packet), .DELAY(FL)) click_ctrl(
//         .lreq(in.req),
//         .lack(in.ack),
//         .rreq(rreq),
//         .rack(rack),
//         .ldata(in.data),
//         .rdata(packet)
//     );

//     always @(*) begin
//         addr = packet[WIDTH_packet - 1 -: WIDTH_addr];
//         dest = packet[WIDTH_packet - WIDTH_addr - 1 -: WIDTH_dest];
//         if(LEVEL == 0) begin
//             sel_rreq = 1;
//         end
//         else begin

//             if (IS_PARENT) begin
//                 //parent node
//                 bit_index = WIDTH_dest - 1 - LEVEL; //如果是父节点，则取非Masked的MSL
//                 dest_bit = dest[bit_index];

//                 $display("Parent node: bit_index = %0d, dest_bit = %b", bit_index, dest_bit);
//                 $display(">>> Received parent packet: %b", packet);
//                 $display(">>> !!!!!IS_PARENT = %0d,  LEVEL = %0d, addr = %b, dest = %b", 
//                         IS_PARENT,  LEVEL, addr, dest);

//                 if (dest_bit == 1'b0) begin  //取出的值是0的话传给左孩子，取出的值是1的话，传给右孩子。
//                     $display("Routed to out1 (child1)");
//                     sel_rreq = 1'b0;
//                 end else begin
//                     $display("Routed to out2 (child2)");
//                     sel_rreq = 1'b1;
//                 end
//             end else begin
//                 //child node
//                 //bit_index = WIDTH_dest - LEVEL; 
//                 //dest_bit = dest[bit_index]; //如果是孩子节点
//                 mask = ((1 << LEVEL) - 1) << (WIDTH_dest - LEVEL); //如果LEVEL = 1,MASK = 100, 如果LEVEL = 2,则MASK = 110
//                 masked_dest = dest & mask; //MASK 与 destination 按位与&
//                 masked_dest_bit = masked_dest[WIDTH_dest - LEVEL]; //取mask以后的mask那几位，比如按位与结果是110，MASK是100，则取1


//                 $display(">>> Received child packet: %b", packet);
//                 $display(">>> mask = %b, IS_PARENT = %0d,  LEVEL = %0d, addr = %b, dest = %b,masked_dest = %b,masked_addr=%b",mask, IS_PARENT,  LEVEL, addr, dest,masked_dest,mask&addr);

//                 //if (IS_LCHILD) begin
//                 addr_bit = addr[WIDTH_addr - LEVEL];//代表addr取被MASK的那几位数字
//                 if(dest == addr) begin

//                     //$display("Left child node: addr_bit = %b, masked_dest = %b",addr_bit,masked_dest);

//                 $display("!!!!!!!!!!Ilegal packet!!!!!!!!!!!!!");
               
//                 end 
//                 else begin
//                     if (masked_dest != (addr & mask)) begin //如果masked_dest_bit结果与address_bit不一致则向parent发，如果masked dest结果与address一致则向另一个child发，
//                         $display("Routed to out1 (parent)");
//                         sel_rreq = 1'b0;
//                     end else begin
//                         $display("Routed to out2 (sibling)");
//                         sel_rreq = 1'b1;
//                     end
//                 end
//             end
//         end
//     end

// endmodule
 `timescale 1ns/1ps

import SystemVerilogCSP::*;

module input_ctrl_gate #(
    parameter WIDTH_packet = 28,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr = 3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest,
    parameter FL = 2,
    parameter BL = 1,
    parameter LEVEL = 0,
    parameter IS_PARENT = 0,
    //parameter IS_LCHILD = 0,
    parameter NUM_NODE = 8
    ///parameter router_addr = 3'b000
) (interface in, out1, out2);

    logic rreq;
    logic rack;
    logic sel_rreq;


    logic [WIDTH-1:0] packet; 
    logic [WIDTH_dest-1:0] dest;
    logic [WIDTH_addr-1:0] addr;
    logic [$clog2(WIDTH_dest)-1:0] bit_index;
    logic dest_bit;
    logic addr_bit;
    logic [WIDTH_dest-1:0]mask;
    logic [WIDTH_dest-1:0]masked_dest;
    logic masked_dest_bit;

    logic out1_ack, out2_ack;
    logic out1_req, out2_req;

    // Channel #(.hsProtocol(WIDTH_packet), .WIDTH(WIDTH)) out1_chan();

    buffer_channel #(.WIDTH(WIDTH)) out1_buf (
        .bAck(out1_ack),
        .bReq(out1_req),
        .rcvd_val(packet),
        .out_chan(out1)
    );


    buffer_channel #(.WIDTH(WIDTH)) out2_buf (
        .bAck(out2_ack),
        .bReq(out2_req),
        .rcvd_val(packet),
        .out_chan(out2)
    );
    // // assign rack = out1.ack || out2.ack;
    always @(*) begin
        if(!sel_rreq) out1_req = rreq;
        else out2_req = rreq;
    end

    always @(*) begin
        rack = out1_ack || out2_ack;
    end
    // assign out1.data = packet;
    // assign out2.data = packet;



    click_controller #( .WIDTH(WIDTH), .DELAY(FL)) click_ctrl(
        .lreq(in.req),
        .lack(in.ack),
        .rreq(rreq),
        .rack(rack),
        .ldata(in.data),
        .rdata(packet)
    );

    always @(*) begin
        addr = packet[WIDTH_addr+WIDTH_dest - 1 : WIDTH_dest];
        dest = packet[WIDTH_dest - 1 : 0];
        if(LEVEL == 0) begin
            sel_rreq = 1;
        end
        else begin

            if (IS_PARENT) begin
                //parent node
                bit_index = WIDTH_dest - 1 - LEVEL; //如果是父节点，则取非Masked的MSL
                dest_bit = dest[bit_index];

                $display("Parent node: bit_index = %0d, dest_bit = %b", bit_index, dest_bit);
                $display(">>> Received parent packet: %b", packet);
                $display(">>> !!!!!IS_PARENT = %0d,  LEVEL = %0d, addr = %b, dest = %b", 
                        IS_PARENT,  LEVEL, addr, dest);

                if (dest_bit == 1'b0) begin  //取出的值是0的话传给左孩子，取出的值是1的话，传给右孩子。
                    $display("Routed to out1 (child1)");
                    sel_rreq = 1'b0;
                end else begin
                    $display("Routed to out2 (child2)");
                    sel_rreq = 1'b1;
                end
            end else begin
                //child node
                //bit_index = WIDTH_dest - LEVEL; 
                //dest_bit = dest[bit_index]; //如果是孩子节点
                mask = ((1 << LEVEL) - 1) << (WIDTH_dest - LEVEL); //如果LEVEL = 1,MASK = 100, 如果LEVEL = 2,则MASK = 110
                masked_dest = dest & mask; //MASK 与 destination 按位与&
                masked_dest_bit = masked_dest[WIDTH_dest - LEVEL]; //取mask以后的mask那几位，比如按位与结果是110，MASK是100，则取1


                $display(">>> Received child packet: %b", packet);
                $display(">>> mask = %b, IS_PARENT = %0d,  LEVEL = %0d, addr = %b, dest = %b,masked_dest = %b,masked_addr=%b",mask, IS_PARENT,  LEVEL, addr, dest,masked_dest,mask&addr);

                //if (IS_LCHILD) begin
                addr_bit = addr[WIDTH_addr - LEVEL];//代表addr取被MASK的那几位数字
                if(dest == addr) begin

                    //$display("Left child node: addr_bit = %b, masked_dest = %b",addr_bit,masked_dest);

                $display("!!!!!!!!!!Ilegal packet!!!!!!!!!!!!!");
               
                end 
                else begin
                    if (masked_dest != (addr & mask)) begin //如果masked_dest_bit结果与address_bit不一致则向parent发，如果masked dest结果与address一致则向另一个child发，
                        $display("Routed to out1 (parent)");
                        sel_rreq = 1'b0;
                    end else begin
                        $display("Routed to out2 (sibling)");
                        sel_rreq = 1'b1;
                    end
                end
            end
        end
    end

endmodule

//-------------------------shim code-------------------------------
// built from ruiheng's data_bucket module
module buffer_channel #(
    parameter WIDTH_packet = 28,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr = 3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest
)(
    output logic bAck, 
    input logic bReq, 
    input   logic [WIDTH-1:0] rcvd_val, 
    interface out_chan);
  
  logic [WIDTH-1:0]  output_value;
 
 
  always begin
    bAck = 0;
    wait (bReq)
    begin: first_phase
        output_value = rcvd_val;
        #2;
        bAck = 1;
		out_chan.Send(output_value);

    end: first_phase
   
    wait (!bReq) #1;

  end
endmodule














