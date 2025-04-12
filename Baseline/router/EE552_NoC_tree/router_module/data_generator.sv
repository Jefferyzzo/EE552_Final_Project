`timescale 1ns/1ps
import SystemVerilogCSP::*;

module data_generator #(
  parameter SENDVALUE1 =14'b00010011111110,
  parameter SENDVALUE2 =14'b10011111110111,
  parameter WIDTH_packet = 14
) (interface r);
  //parameter WIDTH_packet = 14;
  parameter FL = 2; //ideal environment   forward delay
  logic [WIDTH_packet-1:0] SendValue1;
  logic [WIDTH_packet-1:0] SendValue2;

 always begin 
    $display("*** %m starts execution at time %t", $time);
    //SendValue = $random % (1 << WIDTH_packet);
    SendValue1 = SENDVALUE1;
    $display("Start sending in module %m. Simulation time = %t", $time);
    r.Send(SendValue1);
    $display("Finished sending in module %m. Simulation time = %t", $time);
    #10;
    //SendValue2 = SendValue2;

	//add a display here to see when this module starts its main loop
    // the range of random number is from 0 to 2^WIDTH
    #FL;   // change FL and check the change of performance
    SendValue2 = SENDVALUE2;
    //Communication action Send is about to start
    $display("Start sending in module %m. Simulation time = %t", $time);
    r.Send(SendValue2);
    $display("Finished sending in module %m. Simulation time = %t", $time);
    //Communication action Send is finished
	

  end
endmodule