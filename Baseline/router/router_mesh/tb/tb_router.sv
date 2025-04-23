`timescale 1ns/1ns
import SystemVerilogCSP::*;


//top level module instantiating data_generator, reciever, and the interface
integer out_file;
integer packet_limit = 5;
module tb_router; 

     reg clk;
     initial begin
     clk = 0;
     forever #2 clk = ~clk; // 10ns clock period
     end


     initial begin
          out_file = $fopen("./result/router_result.txt", "w");
          #200;
          $fclose(out_file);
          $finish;
     end


     
     
     //Interface Vector instatiation: 4-phase bundled data channel
     // *******************
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Ei ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Wi ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Ni ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Si ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) PEi ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Eo ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Wo ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) No ();
     Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) So ();
     Channel #(.WIDTH(10),.hsProtocol(P4PhaseBD)) PEo ();
     
     //instantiating the test circuit  
     data_generator_E #(.WIDTH(15)) dg_Ei(.r(Ei));
     data_generator_W #(.WIDTH(15)) dg_Wi(.r(Wi));
     data_generator_N #(.WIDTH(15)) dg_Ni(.r(Ni));
     data_generator_S #(.WIDTH(15)) dg_Si(.r(Si));
     data_generator_PE #(.WIDTH(15)) dg_PEi(.r(PEi));
     data_bucket #(.WIDTH(15)) db_Eo(.r(Eo));
     data_bucket #(.WIDTH(15)) db_Wo(.r(Wo));
     data_bucket #(.WIDTH(15)) db_No(.r(No));
     data_bucket #(.WIDTH(15)) db_So(.r(So));
     data_bucket #(.WIDTH(10)) db_PEo(.r(PEo));
     router #(.WIDTH(15)) dut (
          .Wi(Wi),
          .Wo(Wo),
          .Ei(Ei),
          .Eo(Eo),
          .Si(Si),
          .So(So),
          .Ni(Ni),
          .No(No),
          .PEi(PEi),
          .PEo(PEo)
     );
endmodule


//data_generator module
module data_generator_E (interface r);
     parameter WIDTH = 15;
     parameter FL = 0; //ideal environment, no forward delay
     
     logic [0:WIDTH-1] data = 0;
     int packet_num_E = 0;
     
     initial
     begin 
          while(packet_num_E < packet_limit) begin
               $display("packet num E = %d", packet_num_E);
               data[5:7] = 3'b000; // marking the source direction
               $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places
               $fdisplay(out_file, "%m starts sending %015b at %t", data, $time);
               r.Send(data);
               wait(r.status != s_pend);
               data[1] = !data[1]; // change direction
               data[2:4] = data[2:4] + 3; // change hop count
               data[8:WIDTH-1] = data[8:WIDTH-1] + 1;
               packet_num_E = packet_num_E + 1;
          end
     end
endmodule


//data_generator module
module data_generator_W (interface r);
     parameter WIDTH = 15;
     parameter FL = 0; //ideal environment, no forward delay
     
     logic [0:WIDTH-1] data = 0;
     int packet_num_W = 0;
     
     initial
     begin 
          while(packet_num_W < packet_limit) begin
               $display("packet num W = %d", packet_num_W);
               data[0] = 1;
               data[5:7] = 3'b001; // marking the source direction
               $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places
               $fdisplay(out_file, "%m starts sending %015b at %t", data, $time);
               r.Send(data);
               wait(r.status != s_pend);
               data[1] = !data[1]; // change direction
               data[2:4] = data[2:4] + 3; // change hop count
               data[8:WIDTH-1] = data[8:WIDTH-1] + 1;
               packet_num_W = packet_num_W + 1;
          end
     end
endmodule

//data_generator module
module data_generator_N (interface r);
     parameter WIDTH = 15;
     parameter FL = 0; //ideal environment, no forward delay
     
     logic [0:WIDTH-1] data = 0;
     int packet_num_N = 0;
     
     initial
     begin 
          while(packet_num_N < packet_limit) begin
               $display("packet num E = %d", packet_num_N);
               data[0:1] = 2'b01;
               data[5:7] = 3'b010; // marking the source direction
               $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places
               $fdisplay(out_file, "%m starts sending %015b at %t", data, $time);
               r.Send(data);
               wait(r.status != s_pend);
               data[2:4] = data[2:4] + 3; // change hop count
               data[8:WIDTH-1] = data[8:WIDTH-1] + 1;
               packet_num_N = packet_num_N + 1;
          end
     end
endmodule

module data_generator_S (interface r);
     parameter WIDTH = 15;
     parameter FL = 0; //ideal environment, no forward delay
     
     logic [0:WIDTH-1] data = 0;
     int packet_num_S = 0;
     
     initial
     begin 
          while(packet_num_S < packet_limit) begin
               $display("packet num S = %d", packet_num_S);
               data[0:1] = 2'b00;
               data[5:7] = 3'b011; // marking the source direction
               $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places
               $fdisplay(out_file, "%m starts sending %015b at %t", data, $time);
               r.Send(data);
               wait(r.status != s_pend);
               data[2:4] = data[2:4] + 3; // change hop count
               data[8:WIDTH-1] = data[8:WIDTH-1] + 1;
               packet_num_S = packet_num_S + 1;
          end
     end
endmodule

//data_generator module
module data_generator_PE (interface r);
     parameter WIDTH = 15;
     parameter FL = 0; //ideal environment, no forward delay
     
     logic [0:WIDTH-1] data = 0;
     int packet_num_PE = 0;
     
     initial
     begin 
          while(packet_num_PE < packet_limit) begin
               $display("packet num PE = %d", packet_num_PE);
               if(data[3:4] == 0) begin
                    data[3:4] = 2'b01;
               end
               data[5:7] = 3'b100; // marking the source direction
               $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places
               $fdisplay(out_file, "%m starts sending %015b at %t", data, $time);
               r.Send(data);
               wait(r.status != s_pend);
               data[0:1] = data[0:1] + 1; // change direction
               data[2:4] = data[2:4] + 3; // change hop count
               data[8:WIDTH-1] = data[8:WIDTH-1] + 1;
               packet_num_PE = packet_num_PE + 1;
          end
     end
endmodule



//data_bucket module
module data_bucket (interface r);
parameter WIDTH = 10;
parameter BL = 0; //ideal environment   no backward delay

logic [WIDTH-1:0] ReceiveValue = 0;
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
    $fdisplay(out_file, "%m receives packet %b at time %t", ReceiveValue, $time);
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
