// `timescale 1ns/1ps
// import SystemVerilogCSP::*;

// module data_generator (interface r);
//   parameter WIDTH_packet = 14;
//   parameter FL = 2; //ideal environment   forward delay
//   logic [WIDTH_packet-1:0] SendValue = 14'b00000000000000;
//  always begin 
//     $display("*** %m starts execution at time %t", $time);
//     SendValue = $random % (1 << WIDTH_packet);
// 	//add a display here to see when this module starts its main loop
//     // the range of random number is from 0 to 2^WIDTH
//     #FL;   // change FL and check the change of performance
     
//     //Communication action Send is about to start
//     $display("Start sending in module %m. Simulation time = %t", $time);
//     r.Send(SendValue);
//     $display("Finished sending in module %m. Simulation time = %t", $time);
//     //Communication action Send is finished
	

//   end
// endmodule

`timescale 1ns/1ps
import SystemVerilogCSP::*;

module data_generator(interface r);
  parameter WIDTH_packet = 14;
  parameter FL = 2;

  logic [WIDTH_packet-1:0] SendValue;

  initial begin
    // --- First packet: [10:8] = 3'b000 → (000 & 001 = 0) → R0
    SendValue = 14'b01000100000111;
    $display("*** %m starts execution at time %t", $time);
    #FL;
    $display("Start sending (R0) in module %m. Simulation time = %t, data = %b", $time, SendValue);
    r.Send(SendValue);
    $display("Finished sending in module %m. Simulation time = %t", $time);

    // --- Second packet: [10:8] = 3'b001 → (001 & 001 = 1) → R1
    SendValue = 14'b00000000001001;
    #FL;
    $display("Start sending (R1) in module %m. Simulation time = %t, data = %b", $time, SendValue);
    r.Send(SendValue);
    $display("Finished sending in module %m. Simulation time = %t", $time);

    // Optional: add more if needed
  end

endmodule
