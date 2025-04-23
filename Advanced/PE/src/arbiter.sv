`timescale 1ns/1ns

import SystemVerilogCSP::*;

module arbiter #(
    parameter WIDTH	= 8,
    parameter FL	= 2,
    parameter BL	= 1 
) (
    interface  L0,
    interface  L1,
    interface  W     // W denotes which channel is granted, it's only 1bit wide. W.data=0 means L0 is chosen
); 

    logic [WIDTH-1:0] packet;
    
    always begin
        wait((L0.status != idle) || (L1.status != idle));
        if ((L0.status != idle) && (L1.status != idle)) begin
            // Randomly choose between L0 and L1
            if ({$random} % 2 == 0) begin    
                // Choose L0 
    			L0.Receive(packet);
    			#FL;
    			W.Send(0);
    			#BL;
            end
            else begin
                // Choose L1 
    			L1.Receive(packet);
    			#FL;
    			W.Send(1);
    			#BL;
    			end
        end
        else if (L0.status != idle) begin            
            // Choose L0 
    		L0.Receive(packet);
    		#FL;
    		W.Send(0);
    		#BL;
    	end
    	else if (L1.status != idle) begin
            // Choose L1 
            L1.Receive(packet);
    		#FL;
            W.Send(1);
    		#BL;
    	end
    end

endmodule