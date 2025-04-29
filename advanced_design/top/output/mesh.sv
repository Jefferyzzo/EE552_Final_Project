`timescale 1ns/1ps
import SystemVerilogCSP::*;

module mesh_advanced#(
    parameter WIDTH = 15,
    parameter FL = 2,
    parameter BL = 2,
    parameter ROW = 4,
    parameter COL = 4,
    parameter X_HOP_LOC = 4,
    parameter Y_HOP_LOC = 7
) (
    interface PEi [0:ROW*COL-1],
    interface PEo [0:ROW*COL-1],
    interface I,
    interface O
);

    // N2S通道: (ROW+1)*COL个元素
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [0:(ROW+1)*COL-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [0:(ROW+1)*COL-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [0:ROW*(COL+1)-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [0:ROW*(COL+1)-1] ();

    // dummy generator/bucket for X boundaries
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W0 (.r(W2E[0]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E0 (.r(E2W[4]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W0 (.r(E2W[0]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E0 (.r(W2E[4]));
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W1 (.r(W2E[5]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E1 (.r(E2W[9]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W1 (.r(E2W[5]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E1 (.r(W2E[9]));
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W2 (.r(W2E[10]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E2 (.r(E2W[14]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W2 (.r(E2W[10]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E2 (.r(W2E[14]));
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W3 (.r(W2E[15]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E3 (.r(E2W[19]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W3 (.r(E2W[15]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E3 (.r(W2E[19]));
    

    // dummy generator/bucket for Y boundaries
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N0 (.r(N2S[16]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S0 (.r(S2N[0]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N0 (.r(S2N[16]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S0 (.r(N2S[0]));
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N1 (.r(N2S[17]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S1 (.r(S2N[1]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N1 (.r(S2N[17]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S1 (.r(N2S[1]));
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N2 (.r(N2S[18]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S2 (.r(S2N[2]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N2 (.r(S2N[18]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S2 (.r(N2S[2]));
    
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N3 (.r(N2S[19]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S3 (.r(S2N[3]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N3 (.r(S2N[19]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S3 (.r(N2S[3]));
    

    // router core
    
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(0),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_0 (
                .Wi(W2E[0]),
                .Wo(E2W[0]),
                .Ei(E2W[1]),
                .Eo(W2E[1]),
                .Ni(N2S[4]),
                .No(S2N[4]),
                .Si(S2N[0]),
                .So(N2S[0]),
                .PEi(PEi[0]),
                .PEo(PEo[0])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(1),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_1 (
                .Wi(W2E[1]),
                .Wo(E2W[1]),
                .Ei(E2W[2]),
                .Eo(W2E[2]),
                .Ni(N2S[5]),
                .No(S2N[5]),
                .Si(S2N[1]),
                .So(N2S[1]),
                .PEi(PEi[1]),
                .PEo(PEo[1])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(2),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_2 (
                .Wi(W2E[2]),
                .Wo(E2W[2]),
                .Ei(E2W[3]),
                .Eo(W2E[3]),
                .Ni(N2S[6]),
                .No(S2N[6]),
                .Si(S2N[2]),
                .So(N2S[2]),
                .PEi(PEi[2]),
                .PEo(PEo[2])
            );
            
        
            
            
            
            
            

            
            // special node at top-right (0, COL-1) for output
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(3),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_3 (
                .Wi(W2E[3]),
                .Wo(E2W[3]),
                .Ei(E2W[4]),
                .Eo(W2E[4]),
                .Ni(N2S[7]),
                .No(S2N[7]),
                .Si(S2N[3]),
                .So(O),
                .PEi(PEi[3]),
                .PEo(PEo[3])
            );
            
        
    
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(4),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_0 (
                .Wi(W2E[5]),
                .Wo(E2W[5]),
                .Ei(E2W[6]),
                .Eo(W2E[6]),
                .Ni(N2S[8]),
                .No(S2N[8]),
                .Si(S2N[4]),
                .So(N2S[4]),
                .PEi(PEi[4]),
                .PEo(PEo[4])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(5),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_1 (
                .Wi(W2E[6]),
                .Wo(E2W[6]),
                .Ei(E2W[7]),
                .Eo(W2E[7]),
                .Ni(N2S[9]),
                .No(S2N[9]),
                .Si(S2N[5]),
                .So(N2S[5]),
                .PEi(PEi[5]),
                .PEo(PEo[5])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(6),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_2 (
                .Wi(W2E[7]),
                .Wo(E2W[7]),
                .Ei(E2W[8]),
                .Eo(W2E[8]),
                .Ni(N2S[10]),
                .No(S2N[10]),
                .Si(S2N[6]),
                .So(N2S[6]),
                .PEi(PEi[6]),
                .PEo(PEo[6])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(7),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_3 (
                .Wi(W2E[8]),
                .Wo(E2W[8]),
                .Ei(E2W[9]),
                .Eo(W2E[9]),
                .Ni(N2S[11]),
                .No(S2N[11]),
                .Si(S2N[7]),
                .So(N2S[7]),
                .PEi(PEi[7]),
                .PEo(PEo[7])
            );
            
        
    
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(8),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_0 (
                .Wi(W2E[10]),
                .Wo(E2W[10]),
                .Ei(E2W[11]),
                .Eo(W2E[11]),
                .Ni(N2S[12]),
                .No(S2N[12]),
                .Si(S2N[8]),
                .So(N2S[8]),
                .PEi(PEi[8]),
                .PEo(PEo[8])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(9),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_1 (
                .Wi(W2E[11]),
                .Wo(E2W[11]),
                .Ei(E2W[12]),
                .Eo(W2E[12]),
                .Ni(N2S[13]),
                .No(S2N[13]),
                .Si(S2N[9]),
                .So(N2S[9]),
                .PEi(PEi[9]),
                .PEo(PEo[9])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(10),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_2 (
                .Wi(W2E[12]),
                .Wo(E2W[12]),
                .Ei(E2W[13]),
                .Eo(W2E[13]),
                .Ni(N2S[14]),
                .No(S2N[14]),
                .Si(S2N[10]),
                .So(N2S[10]),
                .PEi(PEi[10]),
                .PEo(PEo[10])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(11),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_3 (
                .Wi(W2E[13]),
                .Wo(E2W[13]),
                .Ei(E2W[14]),
                .Eo(W2E[14]),
                .Ni(N2S[15]),
                .No(S2N[15]),
                .Si(S2N[11]),
                .So(N2S[11]),
                .PEi(PEi[11]),
                .PEo(PEo[11])
            );
            
        
    
        
            
            
            
            
            

            
            // special node at bottom-left (ROW-1, 0) for input
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(12),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_0 (
                .Wi(W2E[15]),
                .Wo(E2W[15]),
                .Ei(E2W[16]),
                .Eo(W2E[16]),
                .Ni(I),
                .No(S2N[16]),
                .Si(S2N[12]),
                .So(N2S[12]),
                .PEi(PEi[12]),
                .PEo(PEo[12])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(13),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_1 (
                .Wi(W2E[16]),
                .Wo(E2W[16]),
                .Ei(E2W[17]),
                .Eo(W2E[17]),
                .Ni(N2S[17]),
                .No(S2N[17]),
                .Si(S2N[13]),
                .So(N2S[13]),
                .PEi(PEi[13]),
                .PEo(PEo[13])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(14),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_2 (
                .Wi(W2E[17]),
                .Wo(E2W[17]),
                .Ei(E2W[18]),
                .Eo(W2E[18]),
                .Ni(N2S[18]),
                .No(S2N[18]),
                .Si(S2N[14]),
                .So(N2S[14]),
                .PEi(PEi[14]),
                .PEo(PEo[14])
            );
            
        
            
            
            
            
            

            
            // normal node
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(15),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_3 (
                .Wi(W2E[18]),
                .Wo(E2W[18]),
                .Ei(E2W[19]),
                .Eo(W2E[19]),
                .Ni(N2S[19]),
                .No(S2N[19]),
                .Si(S2N[15]),
                .So(N2S[15]),
                .PEi(PEi[15]),
                .PEo(PEo[15])
            );
            
        
    

endmodule