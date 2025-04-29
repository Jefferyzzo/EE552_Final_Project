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
    interface I
);

    // 通道定义
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [0:(ROW+1)*COL-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [0:(ROW+1)*COL-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [0:ROW*(COL+1)-1] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [0:ROW*(COL+1)-1] ();

    // Dummy generators/buckets on edges
        localparam int W_IDX_0 = 0 * (COL+1);
        localparam int E_IDX_0 = 0 * (COL+1) + COL;
        
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_W0 (.r(W2E[W_IDX_0]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_E0 (.r(E2W[E_IDX_0]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_W0 (.r(E2W[W_IDX_0]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_E0 (.r(W2E[E_IDX_0]));
        localparam int W_IDX_1 = 1 * (COL+1);
        localparam int E_IDX_1 = 1 * (COL+1) + COL;
        
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_W1 (.r(W2E[W_IDX_1]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_E1 (.r(E2W[E_IDX_1]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_W1 (.r(E2W[W_IDX_1]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_E1 (.r(W2E[E_IDX_1]));
        localparam int W_IDX_2 = 2 * (COL+1);
        localparam int E_IDX_2 = 2 * (COL+1) + COL;
        
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_W2 (.r(W2E[W_IDX_2]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_E2 (.r(E2W[E_IDX_2]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_W2 (.r(E2W[W_IDX_2]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_E2 (.r(W2E[E_IDX_2]));
        localparam int W_IDX_3 = 3 * (COL+1);
        localparam int E_IDX_3 = 3 * (COL+1) + COL;
        
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_W3 (.r(W2E[W_IDX_3]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_E3 (.r(E2W[E_IDX_3]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_W3 (.r(E2W[W_IDX_3]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_E3 (.r(W2E[E_IDX_3]));

        localparam int N_IDX_0 = ROW * COL + 0;
        localparam int S_IDX_0 = 0;

        dummy_dg #(.WIDTH(WIDTH)) dummyGen_N0 (.r(N2S[N_IDX_0]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_S0 (.r(S2N[S_IDX_0]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_N0 (.r(S2N[N_IDX_0]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_S0 (.r(N2S[S_IDX_0]));
        localparam int N_IDX_1 = ROW * COL + 1;
        localparam int S_IDX_1 = 1;

        dummy_dg #(.WIDTH(WIDTH)) dummyGen_N1 (.r(N2S[N_IDX_1]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_S1 (.r(S2N[S_IDX_1]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_N1 (.r(S2N[N_IDX_1]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_S1 (.r(N2S[S_IDX_1]));
        localparam int N_IDX_2 = ROW * COL + 2;
        localparam int S_IDX_2 = 2;

        dummy_dg #(.WIDTH(WIDTH)) dummyGen_N2 (.r(N2S[N_IDX_2]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_S2 (.r(S2N[S_IDX_2]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_N2 (.r(S2N[N_IDX_2]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_S2 (.r(N2S[S_IDX_2]));
        localparam int N_IDX_3 = ROW * COL + 3;
        localparam int S_IDX_3 = 3;

        dummy_dg #(.WIDTH(WIDTH)) dummyGen_N3 (.r(N2S[N_IDX_3]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_S3 (.r(S2N[S_IDX_3]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_N3 (.r(S2N[N_IDX_3]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_S3 (.r(N2S[S_IDX_3]));

    // Routers
            localparam int PE_IDX_0_0 = 0 * COL + 0;
            localparam int NS_IDX_0_0 = 0 * COL + 0;
            localparam int NS_IDX_P1_0_0 = (0+1)*COL + 0;
            localparam int EW_IDX_0_0 = 0 * (COL+1) + 0;
            localparam int EW_IDX_P1_0_0 = 0 * (COL+1) + 0 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_0_0),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_0 (
                .Wi(W2E[EW_IDX_0_0]),
                .Wo(E2W[EW_IDX_0_0]),
                .Ei(E2W[EW_IDX_P1_0_0]),
                .Eo(W2E[EW_IDX_P1_0_0]),
                .Ni(N2S[NS_IDX_P1_0_0]),
                .No(S2N[NS_IDX_P1_0_0]),
                .Si(S2N[NS_IDX_0_0]),
                .So(N2S[NS_IDX_0_0]),
                .PEi(PEi[PE_IDX_0_0]),
                .PEo(PEo[PE_IDX_0_0])
            );
            localparam int PE_IDX_0_1 = 0 * COL + 1;
            localparam int NS_IDX_0_1 = 0 * COL + 1;
            localparam int NS_IDX_P1_0_1 = (0+1)*COL + 1;
            localparam int EW_IDX_0_1 = 0 * (COL+1) + 1;
            localparam int EW_IDX_P1_0_1 = 0 * (COL+1) + 1 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_0_1),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_1 (
                .Wi(W2E[EW_IDX_0_1]),
                .Wo(E2W[EW_IDX_0_1]),
                .Ei(E2W[EW_IDX_P1_0_1]),
                .Eo(W2E[EW_IDX_P1_0_1]),
                .Ni(N2S[NS_IDX_P1_0_1]),
                .No(S2N[NS_IDX_P1_0_1]),
                .Si(S2N[NS_IDX_0_1]),
                .So(N2S[NS_IDX_0_1]),
                .PEi(PEi[PE_IDX_0_1]),
                .PEo(PEo[PE_IDX_0_1])
            );
            localparam int PE_IDX_0_2 = 0 * COL + 2;
            localparam int NS_IDX_0_2 = 0 * COL + 2;
            localparam int NS_IDX_P1_0_2 = (0+1)*COL + 2;
            localparam int EW_IDX_0_2 = 0 * (COL+1) + 2;
            localparam int EW_IDX_P1_0_2 = 0 * (COL+1) + 2 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_0_2),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_2 (
                .Wi(W2E[EW_IDX_0_2]),
                .Wo(E2W[EW_IDX_0_2]),
                .Ei(E2W[EW_IDX_P1_0_2]),
                .Eo(W2E[EW_IDX_P1_0_2]),
                .Ni(N2S[NS_IDX_P1_0_2]),
                .No(S2N[NS_IDX_P1_0_2]),
                .Si(S2N[NS_IDX_0_2]),
                .So(N2S[NS_IDX_0_2]),
                .PEi(PEi[PE_IDX_0_2]),
                .PEo(PEo[PE_IDX_0_2])
            );
            localparam int PE_IDX_0_3 = 0 * COL + 3;
            localparam int NS_IDX_0_3 = 0 * COL + 3;
            localparam int NS_IDX_P1_0_3 = (0+1)*COL + 3;
            localparam int EW_IDX_0_3 = 0 * (COL+1) + 3;
            localparam int EW_IDX_P1_0_3 = 0 * (COL+1) + 3 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_0_3),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_0_3 (
                .Wi(W2E[EW_IDX_0_3]),
                .Wo(E2W[EW_IDX_0_3]),
                .Ei(E2W[EW_IDX_P1_0_3]),
                .Eo(W2E[EW_IDX_P1_0_3]),
                .Ni(N2S[NS_IDX_P1_0_3]),
                .No(S2N[NS_IDX_P1_0_3]),
                .Si(S2N[NS_IDX_0_3]),
                .So(N2S[NS_IDX_0_3]),
                .PEi(PEi[PE_IDX_0_3]),
                .PEo(PEo[PE_IDX_0_3])
            );
            localparam int PE_IDX_1_0 = 1 * COL + 0;
            localparam int NS_IDX_1_0 = 1 * COL + 0;
            localparam int NS_IDX_P1_1_0 = (1+1)*COL + 0;
            localparam int EW_IDX_1_0 = 1 * (COL+1) + 0;
            localparam int EW_IDX_P1_1_0 = 1 * (COL+1) + 0 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_1_0),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_0 (
                .Wi(W2E[EW_IDX_1_0]),
                .Wo(E2W[EW_IDX_1_0]),
                .Ei(E2W[EW_IDX_P1_1_0]),
                .Eo(W2E[EW_IDX_P1_1_0]),
                .Ni(N2S[NS_IDX_P1_1_0]),
                .No(S2N[NS_IDX_P1_1_0]),
                .Si(S2N[NS_IDX_1_0]),
                .So(N2S[NS_IDX_1_0]),
                .PEi(PEi[PE_IDX_1_0]),
                .PEo(PEo[PE_IDX_1_0])
            );
            localparam int PE_IDX_1_1 = 1 * COL + 1;
            localparam int NS_IDX_1_1 = 1 * COL + 1;
            localparam int NS_IDX_P1_1_1 = (1+1)*COL + 1;
            localparam int EW_IDX_1_1 = 1 * (COL+1) + 1;
            localparam int EW_IDX_P1_1_1 = 1 * (COL+1) + 1 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_1_1),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_1 (
                .Wi(W2E[EW_IDX_1_1]),
                .Wo(E2W[EW_IDX_1_1]),
                .Ei(E2W[EW_IDX_P1_1_1]),
                .Eo(W2E[EW_IDX_P1_1_1]),
                .Ni(N2S[NS_IDX_P1_1_1]),
                .No(S2N[NS_IDX_P1_1_1]),
                .Si(S2N[NS_IDX_1_1]),
                .So(N2S[NS_IDX_1_1]),
                .PEi(PEi[PE_IDX_1_1]),
                .PEo(PEo[PE_IDX_1_1])
            );
            localparam int PE_IDX_1_2 = 1 * COL + 2;
            localparam int NS_IDX_1_2 = 1 * COL + 2;
            localparam int NS_IDX_P1_1_2 = (1+1)*COL + 2;
            localparam int EW_IDX_1_2 = 1 * (COL+1) + 2;
            localparam int EW_IDX_P1_1_2 = 1 * (COL+1) + 2 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_1_2),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_2 (
                .Wi(W2E[EW_IDX_1_2]),
                .Wo(E2W[EW_IDX_1_2]),
                .Ei(E2W[EW_IDX_P1_1_2]),
                .Eo(W2E[EW_IDX_P1_1_2]),
                .Ni(N2S[NS_IDX_P1_1_2]),
                .No(S2N[NS_IDX_P1_1_2]),
                .Si(S2N[NS_IDX_1_2]),
                .So(N2S[NS_IDX_1_2]),
                .PEi(PEi[PE_IDX_1_2]),
                .PEo(PEo[PE_IDX_1_2])
            );
            localparam int PE_IDX_1_3 = 1 * COL + 3;
            localparam int NS_IDX_1_3 = 1 * COL + 3;
            localparam int NS_IDX_P1_1_3 = (1+1)*COL + 3;
            localparam int EW_IDX_1_3 = 1 * (COL+1) + 3;
            localparam int EW_IDX_P1_1_3 = 1 * (COL+1) + 3 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_1_3),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_1_3 (
                .Wi(W2E[EW_IDX_1_3]),
                .Wo(E2W[EW_IDX_1_3]),
                .Ei(E2W[EW_IDX_P1_1_3]),
                .Eo(W2E[EW_IDX_P1_1_3]),
                .Ni(N2S[NS_IDX_P1_1_3]),
                .No(S2N[NS_IDX_P1_1_3]),
                .Si(S2N[NS_IDX_1_3]),
                .So(N2S[NS_IDX_1_3]),
                .PEi(PEi[PE_IDX_1_3]),
                .PEo(PEo[PE_IDX_1_3])
            );
            localparam int PE_IDX_2_0 = 2 * COL + 0;
            localparam int NS_IDX_2_0 = 2 * COL + 0;
            localparam int NS_IDX_P1_2_0 = (2+1)*COL + 0;
            localparam int EW_IDX_2_0 = 2 * (COL+1) + 0;
            localparam int EW_IDX_P1_2_0 = 2 * (COL+1) + 0 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_2_0),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_0 (
                .Wi(W2E[EW_IDX_2_0]),
                .Wo(E2W[EW_IDX_2_0]),
                .Ei(E2W[EW_IDX_P1_2_0]),
                .Eo(W2E[EW_IDX_P1_2_0]),
                .Ni(N2S[NS_IDX_P1_2_0]),
                .No(S2N[NS_IDX_P1_2_0]),
                .Si(S2N[NS_IDX_2_0]),
                .So(N2S[NS_IDX_2_0]),
                .PEi(PEi[PE_IDX_2_0]),
                .PEo(PEo[PE_IDX_2_0])
            );
            localparam int PE_IDX_2_1 = 2 * COL + 1;
            localparam int NS_IDX_2_1 = 2 * COL + 1;
            localparam int NS_IDX_P1_2_1 = (2+1)*COL + 1;
            localparam int EW_IDX_2_1 = 2 * (COL+1) + 1;
            localparam int EW_IDX_P1_2_1 = 2 * (COL+1) + 1 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_2_1),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_1 (
                .Wi(W2E[EW_IDX_2_1]),
                .Wo(E2W[EW_IDX_2_1]),
                .Ei(E2W[EW_IDX_P1_2_1]),
                .Eo(W2E[EW_IDX_P1_2_1]),
                .Ni(N2S[NS_IDX_P1_2_1]),
                .No(S2N[NS_IDX_P1_2_1]),
                .Si(S2N[NS_IDX_2_1]),
                .So(N2S[NS_IDX_2_1]),
                .PEi(PEi[PE_IDX_2_1]),
                .PEo(PEo[PE_IDX_2_1])
            );
            localparam int PE_IDX_2_2 = 2 * COL + 2;
            localparam int NS_IDX_2_2 = 2 * COL + 2;
            localparam int NS_IDX_P1_2_2 = (2+1)*COL + 2;
            localparam int EW_IDX_2_2 = 2 * (COL+1) + 2;
            localparam int EW_IDX_P1_2_2 = 2 * (COL+1) + 2 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_2_2),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_2 (
                .Wi(W2E[EW_IDX_2_2]),
                .Wo(E2W[EW_IDX_2_2]),
                .Ei(E2W[EW_IDX_P1_2_2]),
                .Eo(W2E[EW_IDX_P1_2_2]),
                .Ni(N2S[NS_IDX_P1_2_2]),
                .No(S2N[NS_IDX_P1_2_2]),
                .Si(S2N[NS_IDX_2_2]),
                .So(N2S[NS_IDX_2_2]),
                .PEi(PEi[PE_IDX_2_2]),
                .PEo(PEo[PE_IDX_2_2])
            );
            localparam int PE_IDX_2_3 = 2 * COL + 3;
            localparam int NS_IDX_2_3 = 2 * COL + 3;
            localparam int NS_IDX_P1_2_3 = (2+1)*COL + 3;
            localparam int EW_IDX_2_3 = 2 * (COL+1) + 3;
            localparam int EW_IDX_P1_2_3 = 2 * (COL+1) + 3 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_2_3),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_2_3 (
                .Wi(W2E[EW_IDX_2_3]),
                .Wo(E2W[EW_IDX_2_3]),
                .Ei(E2W[EW_IDX_P1_2_3]),
                .Eo(W2E[EW_IDX_P1_2_3]),
                .Ni(N2S[NS_IDX_P1_2_3]),
                .No(S2N[NS_IDX_P1_2_3]),
                .Si(S2N[NS_IDX_2_3]),
                .So(N2S[NS_IDX_2_3]),
                .PEi(PEi[PE_IDX_2_3]),
                .PEo(PEo[PE_IDX_2_3])
            );
            localparam int PE_IDX_3_0 = 3 * COL + 0;
            localparam int NS_IDX_3_0 = 3 * COL + 0;
            localparam int NS_IDX_P1_3_0 = (3+1)*COL + 0;
            localparam int EW_IDX_3_0 = 3 * (COL+1) + 0;
            localparam int EW_IDX_P1_3_0 = 3 * (COL+1) + 0 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_3_0),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_0 (
                .Wi(W2E[EW_IDX_3_0]),
                .Wo(E2W[EW_IDX_3_0]),
                .Ei(E2W[EW_IDX_P1_3_0]),
                .Eo(W2E[EW_IDX_P1_3_0]),
                .Ni(I),
                .No(S2N[NS_IDX_P1_3_0]),
                .Si(S2N[NS_IDX_3_0]),
                .So(N2S[NS_IDX_3_0]),
                .PEi(PEi[PE_IDX_3_0]),
                .PEo(PEo[PE_IDX_3_0])
            );
            localparam int PE_IDX_3_1 = 3 * COL + 1;
            localparam int NS_IDX_3_1 = 3 * COL + 1;
            localparam int NS_IDX_P1_3_1 = (3+1)*COL + 1;
            localparam int EW_IDX_3_1 = 3 * (COL+1) + 1;
            localparam int EW_IDX_P1_3_1 = 3 * (COL+1) + 1 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_3_1),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_1 (
                .Wi(W2E[EW_IDX_3_1]),
                .Wo(E2W[EW_IDX_3_1]),
                .Ei(E2W[EW_IDX_P1_3_1]),
                .Eo(W2E[EW_IDX_P1_3_1]),
                .Ni(N2S[NS_IDX_P1_3_1]),
                .No(S2N[NS_IDX_P1_3_1]),
                .Si(S2N[NS_IDX_3_1]),
                .So(N2S[NS_IDX_3_1]),
                .PEi(PEi[PE_IDX_3_1]),
                .PEo(PEo[PE_IDX_3_1])
            );
            localparam int PE_IDX_3_2 = 3 * COL + 2;
            localparam int NS_IDX_3_2 = 3 * COL + 2;
            localparam int NS_IDX_P1_3_2 = (3+1)*COL + 2;
            localparam int EW_IDX_3_2 = 3 * (COL+1) + 2;
            localparam int EW_IDX_P1_3_2 = 3 * (COL+1) + 2 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_3_2),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_2 (
                .Wi(W2E[EW_IDX_3_2]),
                .Wo(E2W[EW_IDX_3_2]),
                .Ei(E2W[EW_IDX_P1_3_2]),
                .Eo(W2E[EW_IDX_P1_3_2]),
                .Ni(N2S[NS_IDX_P1_3_2]),
                .No(S2N[NS_IDX_P1_3_2]),
                .Si(S2N[NS_IDX_3_2]),
                .So(N2S[NS_IDX_3_2]),
                .PEi(PEi[PE_IDX_3_2]),
                .PEo(PEo[PE_IDX_3_2])
            );
            localparam int PE_IDX_3_3 = 3 * COL + 3;
            localparam int NS_IDX_3_3 = 3 * COL + 3;
            localparam int NS_IDX_P1_3_3 = (3+1)*COL + 3;
            localparam int EW_IDX_3_3 = 3 * (COL+1) + 3;
            localparam int EW_IDX_P1_3_3 = 3 * (COL+1) + 3 + 1;
            
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_3_3),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_3_3 (
                .Wi(W2E[EW_IDX_3_3]),
                .Wo(E2W[EW_IDX_3_3]),
                .Ei(E2W[EW_IDX_P1_3_3]),
                .Eo(W2E[EW_IDX_P1_3_3]),
                .Ni(N2S[NS_IDX_P1_3_3]),
                .No(S2N[NS_IDX_P1_3_3]),
                .Si(S2N[NS_IDX_3_3]),
                .So(N2S[NS_IDX_3_3]),
                .PEi(PEi[PE_IDX_3_3]),
                .PEo(PEo[PE_IDX_3_3])
            );

endmodule