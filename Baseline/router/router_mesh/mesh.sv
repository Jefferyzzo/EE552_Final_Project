`timescale 1ns/1ps
import SystemVerilogCSP::*;

module dummy_dg #(parameter WIDTH = 15) (interface r);
    // Dummy generator that does not send data
    initial forever begin
        // No transaction logic (idle)
        #1000;
    end
endmodule


module mesh#(
    parameter WIDTH	= 15 ,
    parameter FL	= 2 ,
    parameter BL	= 2 ,
    parameter ROW	= 4 ,
    parameter COL	= 4,
    parameter X_HOP_LOC = 4,
    parameter Y_HOP_LOC = 7
) (
    interface PEi [0:ROW-1][0:COL-1],
    interface PEo [0:ROW-1][0:COL-1]
);
    

    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [0:ROW][0:COL-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [0:ROW][0:COL-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [0:ROW-1][0:COL] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [0:ROW-1][0:COL] ();

    genvar i, j;
    generate
        for(i = 0; i < ROW;i++) begin: gen_x_dummy
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_W (.r(W2E[i][0]));
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_E (.r(E2W[i][COL]));
        end
    endgenerate
    generate
        for(i = 0; i < COL;i++) begin: gen_y_dummy
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_N (.r(N2S[ROW][i]));
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_S (.r(S2N[0][i]));
        end
    endgenerate
    generate
        for(i = 0; i < ROW;i++) begin: gen_row
            for(j = 0; j < COL;j++) begin: gen_col
                router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM(4*i+j), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(X_HOP_LOC)) 
                    router_node(.Wi(W2E[i][j]), .Wo(E2W[i][j]), .Ei(E2W[i][j+1]), .Eo(W2E[i][j+1]), 
                    .Ni(N2S[i+1][j]), .No(S2N[i+1][j]), .Si(S2N[i][j]), .So(N2S[i][j]), 
                    .PEi(PEi[i][j]), .PEo(PEo[i][j]));
            end
        end
    endgenerate

endmodule

