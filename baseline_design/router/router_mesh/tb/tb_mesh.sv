`timescale 1ns/1ns
import SystemVerilogCSP::*;


//top level module instantiating data_generator, reciever, and the interface
parameter     ROW = 4;
parameter     COL = 4;
parameter     WIDTH = 20;
integer sent_file;
integer out_file[0:ROW*COL-1];
integer packet_limit = 3;
module tb_mesh; 
     parameter FL	= 2 ;
     parameter BL	= 2 ;
     parameter X_HOP_LOC = 4;
     parameter Y_HOP_LOC = 7;
     
    

     reg clk;
     initial begin
     clk = 0;
     forever #2 clk = ~clk; // 4ns clock period
     end

     // output files for recording received packets for each node
     integer i;
     initial begin
          for(i = 0;i<ROW*COL;i++)begin
               out_file[i] = $fopen($sformatf("./result/gather_node%0d.txt", i), "w");
          end
          sent_file = $fopen("./result/sent_file.txt", "w");
          
          #2000;

          for(i = 0;i<ROW*COL;i++)begin
               $fclose(out_file[i]);
          end
          $fclose(sent_file);
          $finish;
     end


     Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) PEi [0:ROW-1][0:COL-1] ();
     Channel #(.WIDTH(WIDTH-(Y_HOP_LOC+1)), .hsProtocol(P4PhaseBD)) PEo [0:ROW-1][0:COL-1] ();
     genvar j,k;
     generate
          for(j=0;j<ROW;j++) begin: gen_row
               for(k=0;k<COL;k++) begin: gen_col
                    data_generator #(.WIDTH(WIDTH),.NODE_NUM(j*COL+k)) dg (.r(PEi[j][k]));
                    data_bucket #(.WIDTH(WIDTH-(Y_HOP_LOC+1)),.NODE_NUM(j*COL+k)) db(.r(PEo[j][k]));
               end
          end

     endgenerate
     mesh #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .ROW(ROW), .COL(COL), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC))
          dut (.PEi(PEi), .PEo(PEo));
     
endmodule


//data_generator module
module data_generator #(parameter NODE_NUM = 0, parameter WIDTH = 15) (interface r);
     parameter FL = 0; //ideal environment, no forward delay
     
     logic [0:WIDTH-1] packet = 0;
     integer packet_num[0:ROW*COL-1];
     integer i;
     
     initial
     begin 
          $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places
          for(i=0;i<ROW*COL;i++) begin
               packet_num[i] = 0;
          end
          while(packet_num[NODE_NUM] < packet_limit) begin
               for(i=0;i<ROW*COL;i++) begin
                    if(NODE_NUM != i) begin
                         packet = generate_packet(NODE_NUM, i, COL, packet_num[NODE_NUM]);
                         r.Send(packet);
                         wait(r.status != s_pend);
                    end
               end
               packet_num[NODE_NUM] = packet_num[NODE_NUM] + 1;
          end

     end


//--------------------------------------------------------------------
// generate packets for gather testbench
//--------------------------------------------------------------------
function [3:0] hop_convert;
input signed [3:0] hop_in;
integer i;
reg [3:0] temp;
reg [3:0] abs_val;
begin
abs_val = (hop_in < 0) ? -hop_in : hop_in; //absolute value
temp = 4'b0000;

for (i = 0; i < abs_val && i < 4; i = i + 1) begin
     temp[i] = 1'b1; // eg. 3 => 0011
end

hop_convert = temp;
end
endfunction

function [0:WIDTH-1] generate_packet;
input integer src_pe;
input integer dst_pe;
input integer COL;
input integer packet_index;

integer dest_x, dest_y;
integer src_x, src_y;
integer hopcount_x, hopcount_y;
begin
     // 坐标转换
     dest_x = dst_pe % COL;
     dest_y = dst_pe / COL;
     src_x  = src_pe % COL;
     src_y  = src_pe / COL;

     // hopcount 动态计算
     hopcount_y = dest_y - src_y; // placeholder
     hopcount_x = dest_x - src_x; // placeholder

     // header区
     generate_packet[0]       = (dest_x > src_x) ? 1'b1 : 1'b0; // dir_x 1:E 0:W
     generate_packet[1]       = (dest_y < src_y) ? 1'b1 : 1'b0; // dir_y 1:S, 0:N
     generate_packet[2:4]     = hop_convert(hopcount_x);
     generate_packet[5:7]     = hop_convert(hopcount_y);

     // payload区
     generate_packet[8:11]  = src_pe; // 源PEID
     generate_packet[12:15] = dst_pe; // 目标PE
     generate_packet[16:WIDTH-1] = packet_index;
     $fdisplay(sent_file, "src_pe = %d, dst_pe = %d, direction = %b,  hop count = %b, packet = %h at time %0dns", 
          src_pe, dst_pe, generate_packet[0:1], generate_packet[2:7],generate_packet,$time);

end
endfunction

endmodule

//data_bucket module
module data_bucket #(parameter WIDTH = 10, parameter NODE_NUM = 0) (interface r);

parameter BL = 0; //ideal environment   no backward delay

logic [0:WIDTH-1] ReceiveValue = 0;
//Variables added for performance measurements
real cycleCounter=0;  //# of cycles = Total number of times a value is received
real timeOfReceive=0; //Simulation time of the latest Receive 
real cycleTime=0;     // time difference between the last two receives
real averageThroughput=0;
real averageCycleTime=0;
real sumOfCycleTimes=0;

always
begin
     $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
//     $display("%m starts its main loop at %t", $time);
    //Save the simulation time when Receive starts   
    timeOfReceive = $time;  
    r.Receive(ReceiveValue); 
    $fdisplay(out_file[NODE_NUM], "Node %0d | Time = %0dns | Src = %0d | Packet = %h", 
                    NODE_NUM, $time, ReceiveValue[0:3], ReceiveValue);
    #BL;
//     cycleCounter += 1;		
//     //Measuring throughput: calculate the number of Receives per unit of time  
//     //CycleTime stores the time it takes from the begining to the end of the always block
//     cycleTime = $time - timeOfReceive; // the difference of time between now and the last receive
//     averageThroughput = cycleCounter/$time; 
//     sumOfCycleTimes += cycleTime;
//     averageCycleTime = sumOfCycleTimes / cycleCounter;
//     $display("Execution cycle= %d, Cycle Time= %d, 
//         Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
//         averageCycleTime, averageThroughput);
end
endmodule
