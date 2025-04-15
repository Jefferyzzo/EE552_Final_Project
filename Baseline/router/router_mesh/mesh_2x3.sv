`timescale 1ns/1ps
import SystemVerilogCSP::*;

module dummy_dg #(parameter WIDTH = 15) (interface r);
    // Dummy generator that does not send data
    initial forever begin
        // No transaction logic (idle)
        #1000;
    end
endmodule


module mesh_2x3#(
    parameter WIDTH	= 10 ,
    parameter FL	= 2 ,
    parameter BL	= 2
) (
    interface PEi [1:0][2:0],
    interface PEo [1:0][2:0]
    // interface  PEi_0_0   ,
    // interface  PEo_0_0   ,    
    // interface  PEi_0_1   ,
    // interface  PEo_0_1   , 
    // interface  PEi_0_2   ,
    // interface  PEo_0_2   , 
    // interface  PEi_1_0   ,
    // interface  PEo_1_0   ,    
    // interface  PEi_1_1   ,
    // interface  PEo_1_1   , 
    // interface  PEi_1_2   ,
    // interface  PEo_1_2
);
    parameter X_HOP_LOC = 3; // location of last x hop bit in the packet
    parameter Y_HOP_LOC = 4; // location of last y hop bit in the packet

    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [2:0][2:0] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [2:0][2:0] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [1:0][3:0] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [1:0][3:0] ();

    dummy_dg dummyGen_N[2:0] (.*);
    dummy_dg dummyGen_S[2:0] (.*);
    dummy_dg dummyGen_W[1:0] (.*);
    dummy_dg dummyGen_E[1:0] (.*);
    genvar i, j;
    generate
        for(i = 0; i < 2;i++) begin: gen_x_dummy
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_W (.r(W2E[i][0]));
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_E (.r(E2W[i][3]));
        end
    endgenerate
    generate
        for(i = 0; i < 3;i++) begin: gen_y_dummy
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_N (.r(N2S[2][i]));
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_S (.r(S2N[0][i]));
        end
    endgenerate
    generate
        for(i = 0; i < 2;i++) begin: gen_row
            for(j = 0; j < 3;j++) begin: gen_col
                router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(COL*i+j), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(X_HOP_LOC)) 
                    router_node(.Wi(W2E[i][j]), .Wo(E2W[i][j]), .Ei(E2W[i][j+1]), .Eo(W2E[i][j+1]), 
                    .Ni(N2S[i+1][j]), .No(S2N[i+1][j]), .Si(S2N[i][j]), .So(N2S[i][j]), 
                    .PEi(PEi[i][j]), .PEo(PEo[i][j]));
            end
        end
    endgenerate
    

endmodule

