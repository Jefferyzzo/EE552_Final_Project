// `timescale 1ns/1ps

// import SystemVerilogCSP::*;

// module arbiter_2to1 #(
//     parameter WIDTH_packet = 14,
//     parameter FL = 2,
//     parameter BL = 1
// ) (
//     interface in1, in2, out
// );
//     logic [WIDTH_packet-1:0] in_packet;
//     logic prio;

//     initial begin
//         prio = 0;
//     end

//     always begin
//         wait(in1.req || in2.req);
//         if(in1.req && in2.req) begin
//             // contention
//             if(prio) begin
//                 // in2 gets it
//                 in2.Receive(in_packet);
//                 #FL;
//                 out.Send(in_packet);
//                 #BL;
//                 prio = ~prio;
//             end
//             else begin
//                 // in1
//                 in1.Receive(in_packet);
//                 #FL;
//                 out.Send(in_packet);
//                 #BL;
//                 prio = ~prio;
//             end
//         end
//         else if(in1.req) begin
//             in1.Receive(in_packet);
//             #FL;
//             out.Send(in_packet);
//             #BL;
//         end
//         else if(in2.req) begin
//             in2.Receive(in_packet);
//             #FL;
//             out.Send(in_packet);
//             #BL;
//         end
//     end
// endmodule
//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns
import SystemVerilogCSP::*;

module arbiter #(
parameter WIDTH_packet	= 14 ,
parameter FL	= 2 ,
parameter BL	= 1 
) (
interface  L0   ,
interface  L1   ,
interface  W     // W denotes which channel is granted, it's only 1bit wide. W.data=0 means L0 is chosen
); 

logic [WIDTH_packet-1:0] packet;
logic sel;

always  begin
    wait((L0.status != idle) || (L1.status != idle));
    if ((L0.status != idle) && (L1.status != idle)) begin
        // Randomly choose between L0 and L1
        if ({$random} % 2 == 0) begin    
            // Choose L0 
            
            L0.Receive(packet);
            #FL;
            sel = 0;
            W.Send(sel);
            #BL;
        end
        else begin
            // Choose L1 
            sel = 1;
            L1.Receive(packet);
            #FL;
            sel = 1;
            W.Send(sel);
            #BL;
        end
    end
    else if (L0.status != idle) begin         
        // Choose L0 
        
        L0.Receive(packet);
        #FL;
        sel = 0;
        W.Send(sel);
        #BL;
    end
    else if (L1.status != idle) begin
        // Choose L1 
        //sel = 1;
        L1.Receive(packet);
        #FL;

        sel = 1;
        W.Send(sel);
        #BL;
    end
end

endmodule
