`timescale 1ns/1ps
import SystemVerilogCSP::*;

module data_bucket (interface r);
  parameter NODE = 0;
  parameter WIDTH_packet = 14;
  parameter BL = 1; //ideal environment    backward delay
  logic [WIDTH_packet-1:0] ReceiveValue = 0;
  
  integer fp;

  //Variables added for performance measurements

  always
  begin
    $display("*** %m starts execution at time %t", $time);
	//add a display here to see when this module starts its main loop
	//fp = $fopen("mesh.out");
	//Communication action Receive is about to start
    $display("Start receiving in module %m. Simulation time = %t", $time);  
    r.Receive(ReceiveValue);
    $display("Finish receiving in module %m. Simulation time = %t", $time);  
    $display(" !!!!!!!!!out data: %b",ReceiveValue);
	//Communication action Receive is finished
    
	#BL;

	
  end

endmodule