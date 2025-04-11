//Filling in all the blanks marked with ******************* 
`timescale 1ns/1ns

import SystemVerilogCSP::*;

module router #(
parameter WIDTH	= 10 ,
parameter FL	= 2 ,
parameter BL	= 2 ,
parameter NODE_NUM = 0,
parameter X_HOP_LOC = 3, // location of last x hop bit in the packet
parameter Y_HOP_LOC = 4 // location of last y hop bit in the packet
) (
interface  Wi    ,
interface  Wo    ,
interface  Ei    ,
interface  Eo    ,
interface  Ni    ,
interface  No    ,
interface  Si    ,
interface  So    ,
interface  PEi   ,
interface  PEo    
); 


// Channels between input packets and output arbiter
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) W2E ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) W2N ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) W2S ();
Channel #(.WIDTH(WIDTH - (Y_HOP_LOC + 1)),.hsProtocol(P4PhaseBD)) W2PE ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) E2W ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) E2N ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) E2S ();
Channel #(.WIDTH(WIDTH - (Y_HOP_LOC + 1)),.hsProtocol(P4PhaseBD)) E2PE ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) N2S ();
Channel #(.WIDTH(WIDTH - (Y_HOP_LOC + 1)),.hsProtocol(P4PhaseBD)) N2PE ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) S2N ();
Channel #(.WIDTH(WIDTH - (Y_HOP_LOC + 1)),.hsProtocol(P4PhaseBD)) S2PE ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) PE2E ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) PE2W ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) PE2N ();
Channel #(.WIDTH(WIDTH),.hsProtocol(P4PhaseBD)) PE2S ();





input_buffer_E #(.NODE_NUM(NODE_NUM), .WIDTH(WIDTH), .FL(FL), .BL(BL), .X_HOP_LOC(3), .Y_HOP_LOC(4))
    buffer_E(.Ei(Ei), .E2PE(E2PE), .E2W(E2W), .E2N(E2N), .E2S(E2S));

input_buffer_W #(.NODE_NUM(NODE_NUM), .WIDTH(WIDTH), .FL(FL), .BL(BL), .X_HOP_LOC(3), .Y_HOP_LOC(4))
    buffer_W(.Wi(Wi), .W2PE(W2PE), .W2E(W2E), .W2N(W2N), .W2S(W2S));

input_buffer_S #(.NODE_NUM(NODE_NUM), .WIDTH(WIDTH), .FL(FL), .BL(BL), .X_HOP_LOC(3), .Y_HOP_LOC(4))
    buffer_S(.Si(Si), .S2PE(S2PE), .S2N(S2N));

input_buffer_N #(.NODE_NUM(NODE_NUM), .WIDTH(WIDTH), .FL(FL), .BL(BL), .X_HOP_LOC(3), .Y_HOP_LOC(4))
    buffer_N(.Ni(Ni), .N2PE(N2PE), .N2S(N2S));

input_buffer_PE #(.NODE_NUM(NODE_NUM), .WIDTH(WIDTH), .FL(FL), .BL(BL), .X_HOP_LOC(3), .Y_HOP_LOC(4))
    buffer_PE(.PEi(PEi), .PE2W(PE2W), .PE2E(PE2E), .PE2N(PE2N), .PE2S(PE2S));


// arbiter for channel outputs
arbiter_merge  #(.WIDTH(WIDTH), .FL(FL), .BL(BL))
    Wo_arb ( .L0(E2W), .L1(PE2W), .R(Wo)); 

arbiter_merge  #(.WIDTH(WIDTH), .FL(FL), .BL(BL))
    Eo_arb ( .L0(W2E), .L1(PE2E), .R(Eo)); 

arbiter_merge_4in  #(.WIDTH(WIDTH), .FL(FL), .BL(BL))
    No_arb ( .L0(W2N), .L1(E2N), .L2(S2N), .L3(PE2N), .R(No)); 

arbiter_merge_4in  #(.WIDTH(WIDTH), .FL(FL), .BL(BL))
    So_arb ( .L0(W2S), .L1(E2S), .L2(N2S), .L3(PE2S), .R(So)); 

arbiter_merge_4in  #(.WIDTH(WIDTH - (Y_HOP_LOC + 1)), .FL(FL), .BL(BL))
    PEo_arb ( .L0(W2PE), .L1(E2PE), .L2(N2PE), .L3(S2PE), .R(PEo)); 


endmodule

module input_buffer_E#(
    parameter NODE_NUM = 0,
    parameter WIDTH	= 10 ,
    parameter FL	= 2 ,
    parameter BL	= 2 ,
    parameter X_HOP_LOC = 3, // location of last x hop bit in the packet
    parameter Y_HOP_LOC = 4 // location of last y hop bit in the packet
    ) (
    interface  Ei    ,
    interface  E2PE  ,
    interface  E2W   ,
    interface  E2N   ,
    interface  E2S
    ); 
    
    logic [0:WIDTH-1] Ei_packet, Eo_packet;

// Ei channel logic
    always begin
        Ei.Receive(Ei_packet);
        $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
        $display("node %d receives packet %h from East input at %t", NODE_NUM, Ei_packet, $time);
        #FL;
        if(Ei_packet[X_HOP_LOC] == 0 && Ei_packet[Y_HOP_LOC] == 0) begin // x hop and y hop are both 0, reach target node
            Eo_packet = Ei_packet[Y_HOP_LOC + 1: WIDTH - 1];
            E2PE.Send(Eo_packet);
            $display("node %d sends packet %h from East to PE at %t", NODE_NUM, Ei_packet, $time);
            #BL;
        end
        else if(Ei_packet[X_HOP_LOC] == 1) begin // if there is x hop, packet must go in x direction
            Eo_packet = {Ei_packet[0:1], 1'b0, Ei_packet[2:X_HOP_LOC-1], Ei_packet[X_HOP_LOC+1:WIDTH-1]};
            E2W.Send(Eo_packet);
            $display("node %d sends packet %h from East to West at %t", NODE_NUM, Ei_packet, $time);
            #BL;
        end
        else begin // no x hop but there is still y hop
            // Eo_packet = {Ei_packet[0:X_HOP_LOC], 1'b0, Ei_packet[X_HOP_LOC+1:Y_HOP_LOC-1], Ei_packet[Y_HOP_LOC+1:WIDTH-1]};
            Eo_packet = {Ei_packet[0:X_HOP_LOC], 1'b0, Ei_packet[Y_HOP_LOC+1:WIDTH-1]};
            case(Ei_packet[1])
                0: begin // send to North
                    E2N.Send(Eo_packet);
                    $display("node %d sends packet %h from East to North at %t", NODE_NUM, Ei_packet, $time);
                    #BL;
                end
                1: begin // send to South
                    E2S.Send(Eo_packet);
                    $display("node %d sends packet %h from East to South at %t", NODE_NUM, Ei_packet, $time);
                    #BL;
                end
            endcase
        end
    end

endmodule



module input_buffer_W#(
    parameter NODE_NUM = 0,
    parameter WIDTH	= 10 ,
    parameter FL	= 2 ,
    parameter BL	= 2 ,
    parameter X_HOP_LOC = 3, // location of last x hop bit in the packet
    parameter Y_HOP_LOC = 4 // location of last y hop bit in the packet
    ) (
    interface  Wi    ,
    interface  W2PE  ,
    interface  W2E   ,
    interface  W2N   ,
    interface  W2S
    ); 

    logic [0:WIDTH-1] Wi_packet, Wo_packet;

// Wi channel logic
    always begin
        Wi.Receive(Wi_packet);
        $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
        $display("node %d receives packet %h from West input at %t", NODE_NUM, Wi_packet, $time);
        #FL;
        if(Wi_packet[X_HOP_LOC] == 0 && Wi_packet[Y_HOP_LOC] == 0) begin // x hop and y hop are both 0, reach target node
            Wo_packet = Wi_packet[Y_HOP_LOC + 1: WIDTH - 1];
            W2PE.Send(Wi_packet);
            $display("node %d sends packet %h from West to PE at %t", NODE_NUM, Wi_packet, $time);
            #BL;
        end
        else if(Wi_packet[X_HOP_LOC] == 1) begin // if there is x hop, packet must go in x direction
            Wo_packet = {Wi_packet[0:1], 1'b0, Wi_packet[2:X_HOP_LOC-1], Wi_packet[X_HOP_LOC+1:WIDTH-1]};
            W2E.Send(Wo_packet);
            $display("node %d sends packet %h from West to East at %t", NODE_NUM, Wi_packet, $time);
            #BL;
        end
        else begin // no x hop but there is still y hop
            // Wo_packet = {Wi_packet[0:X_HOP_LOC], 1'b0, Wi_packet[X_HOP_LOC+1:Y_HOP_LOC-1], Wi_packet[Y_HOP_LOC+1:WIDTH-1]};
            Wo_packet = {Wi_packet[0:X_HOP_LOC], 1'b0, Wi_packet[Y_HOP_LOC+1:WIDTH-1]};
            case(Wi_packet[1])
                0: begin // send to North
                    W2N.Send(Wo_packet);
                    $display("node %d sends packet %h from West to North at %t", NODE_NUM, Wi_packet, $time);
                    #BL;
                end
                1: begin // send to South
                    W2S.Send(Wo_packet);
                    $display("node %d sends packet %h from West to South at %t", NODE_NUM, Wi_packet, $time);
                    #BL;
                end
            endcase
        end
    end

endmodule


module input_buffer_N#(
    parameter NODE_NUM = 0,
    parameter WIDTH	= 10 ,
    parameter FL	= 2 ,
    parameter BL	= 2 ,
    parameter X_HOP_LOC = 3, // location of last x hop bit in the packet
    parameter Y_HOP_LOC = 4 // location of last y hop bit in the packet
    ) (
    interface  Ni    ,
    interface  N2PE  ,
    interface  N2S
    ); 

    logic [0:WIDTH-1] Ni_packet, No_packet;

// Ni channel logic
    always begin
        Ni.Receive(Ni_packet);
        $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
        $display("node %d receives packet %h from North input at %t", NODE_NUM, Ni_packet, $time);
        #FL;
        if(Ni_packet[Y_HOP_LOC] == 0) begin // reach target node
            No_packet = Ni_packet[Y_HOP_LOC + 1: WIDTH - 1];
            N2PE.Send(No_packet);
            $display("node %d sends packet %h from North to PE at %t", NODE_NUM, Ni_packet, $time);
            #BL;
        end
        else begin // send to south
            // No_packet = {Ni_packet[0:X_HOP_LOC], 1'b0, Ni_packet[X_HOP_LOC+1:Y_HOP_LOC-1], Ni_packet[Y_HOP_LOC+1:WIDTH-1]};
            No_packet = {Ni_packet[0:X_HOP_LOC], 1'b0, Ni_packet[Y_HOP_LOC+1:WIDTH-1]};
            N2S.Send(No_packet);
            $display("node %d sends packet %h from North to South at %t", NODE_NUM, Ni_packet, $time);
            #BL;
        end
    end
endmodule



module input_buffer_S#(
    parameter NODE_NUM = 0,
    parameter WIDTH	= 10 ,
    parameter FL	= 2 ,
    parameter BL	= 2 ,
    parameter X_HOP_LOC = 3, // location of last x hop bit in the packet
    parameter Y_HOP_LOC = 4 // location of last y hop bit in the packet
    ) (
    interface  Si    ,
    interface  S2PE  ,
    interface  S2N
    ); 

    logic [0:WIDTH-1] Si_packet, So_packet;

    // Si channel logic
    always begin
        Si.Receive(Si_packet);
        $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
        $display("node %d receives packet %h from South input at %t", NODE_NUM, Si_packet, $time);
        #FL;
        if(Si_packet[Y_HOP_LOC] == 0) begin // reach target node
            So_packet = Si_packet[Y_HOP_LOC + 1: WIDTH - 1];
            S2PE.Send(So_packet);
            $display("node %d sends packet %h from South to PE at %t", NODE_NUM, Si_packet, $time);
            #BL;
        end
        else begin // send to north
            // So_packet = {Si_packet[0:X_HOP_LOC], 1'b0, Si_packet[X_HOP_LOC+1:Y_HOP_LOC-1], Si_packet[Y_HOP_LOC+1:WIDTH-1]};
            So_packet = {Si_packet[0:X_HOP_LOC], 1'b0, Si_packet[Y_HOP_LOC+1:WIDTH-1]};
            S2N.Send(So_packet);
            $display("node %d sends packet %h from South to North at %t", NODE_NUM, Si_packet, $time);
            #BL;
        end
    end
endmodule



module input_buffer_PE#(
    parameter NODE_NUM = 0,
    parameter WIDTH	= 10 ,
    parameter FL	= 2 ,
    parameter BL	= 2 ,
    parameter X_HOP_LOC = 3, // location of last x hop bit in the packet
    parameter Y_HOP_LOC = 4 // location of last y hop bit in the packet
    ) (
    interface  PEi    ,
    interface  PE2S   ,
    interface  PE2E   ,
    interface  PE2W   ,
    interface  PE2N
    ); 

    logic [0:WIDTH-1] PEi_packet;
    logic [0: WIDTH-1-(Y_HOP_LOC + 1)] PEo_packet;

    // PEi channel logic
    always begin
        PEi.Receive(PEi_packet);
        $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
        $display("node %d receives packet %h from PE input at %t", NODE_NUM, PEi_packet, $time);
        #FL;
        if(PEi_packet[X_HOP_LOC] == 1) begin // if there is x hop, packet must go in x direction
            PEo_packet = {PEi_packet[0:1], 1'b0, PEi_packet[2:X_HOP_LOC-1], PEi_packet[X_HOP_LOC+1:WIDTH-1]};
            case(PEi_packet[0])
            0: begin // send to West
                PE2W.Send(PEo_packet);
                $display("node %d sends packet %h from PE to West at %t", NODE_NUM, PEi_packet, $time);
                #BL;
            end
            1: begin // send to East
                PE2E.Send(PEo_packet);
                $display("node %d sends packet %h from PE to East at %t", NODE_NUM, PEi_packet, $time);
                #BL;
            end
        endcase
        end
        else begin // no x hop but there is still y hop
            // PEo_packet = {PEi_packet[0:X_HOP_LOC], 1'b0, PEi_packet[X_HOP_LOC+1:Y_HOP_LOC-1], PEi_packet[Y_HOP_LOC+1:WIDTH-1]};
            PEo_packet = {PEi_packet[0:X_HOP_LOC], 1'b0, PEi_packet[Y_HOP_LOC+1:WIDTH-1]};
            case(PEi_packet[1])
                0: begin // send to North
                    PE2N.Send(PEo_packet);
                    $display("node %d sends packet %h from PE to North at %t", NODE_NUM, PEi_packet, $time);
                    #BL;
                end
                1: begin // send to South
                    PE2S.Send(PEo_packet);
                    $display("node %d sends packet %h from PE to South at %t", NODE_NUM, PEi_packet, $time);
                    #BL;
                end
            endcase
        end
    end
endmodule