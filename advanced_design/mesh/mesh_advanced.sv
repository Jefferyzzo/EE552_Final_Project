`timescale 1ns/1ps
import SystemVerilogCSP::*;

module dummy_dg #(parameter WIDTH = 15) (interface r);
    // Dummy generator that does not send data
    initial forever begin
        // No transaction logic (idle)
        #10;
    end
endmodule

module dummy_db #(parameter WIDTH = 15) (interface r);
    // Dummy generator that does not send data
    initial forever begin
        // No transaction logic (idle)
        #10;
    end
endmodule

module mesh_advanced#(
    parameter WIDTH = 15,
    parameter FL = 2,
    parameter BL = 2,
    parameter ROW = 4,
    parameter COL = 4,
    parameter X_HOP_LOC = 4,
    parameter Y_HOP_LOC = 7
) (
    interface PEi [0:ROW*COL-1],  // 一维PE输入接口数组
    interface PEo [0:ROW*COL-1],   // 一维PE输出接口数组
    interface I,
    interface O
);
    
    // 修改Channel为一维数组
    // N2S通道: (ROW+1)*COL个元素
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [0:(ROW+1)*COL-1] ();
    // S2N通道: (ROW+1)*COL个元素
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [0:(ROW+1)*COL-1] ();
    // E2W通道: ROW*(COL+1)个元素
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [0:ROW*(COL+1)-1] ();
    // W2E通道: ROW*(COL+1)个元素
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [0:ROW*(COL+1)-1] ();

    genvar i, j;
    generate
        for(i = 0; i < ROW; i++) begin: gen_x_dummy
            // 计算一维索引
            localparam int W_IDX = i * (COL+1);       // W2E[i][0] -> W2E[i*(COL+1)]
            localparam int E_IDX = i * (COL+1) + COL; // E2W[i][COL] -> E2W[i*(COL+1)+COL]
            
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_W (.r(W2E[W_IDX]));
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_E (.r(E2W[E_IDX]));
            dummy_db #(.WIDTH(WIDTH)) dummyBucket_W (.r(E2W[W_IDX]));
            dummy_db #(.WIDTH(WIDTH)) dummyBucket_E (.r(W2E[E_IDX]));
        end
    endgenerate
    
    generate
        for(i = 0; i < COL; i++) begin: gen_y_dummy
            // 计算一维索引
            localparam int N_IDX = ROW * COL + i;     // N2S[ROW][i] -> N2S[ROW*COL+i]
            localparam int S_IDX = i;                 // S2N[0][i] -> S2N[i]
            
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_N (.r(N2S[N_IDX]));
            dummy_dg #(.WIDTH(WIDTH)) dummyGen_S (.r(S2N[S_IDX]));
            dummy_db #(.WIDTH(WIDTH)) dummyBucket_N (.r(S2N[N_IDX]));
            dummy_db #(.WIDTH(WIDTH)) dummyBucket_S (.r(N2S[S_IDX]));
        end
    endgenerate
    
    generate
        for(i = 0; i < ROW; i++) begin: gen_row
            for(j = 0; j < COL; j++) begin: gen_col
                // 计算一维索引
                localparam int PE_IDX = i * COL + j;  // PEi[i][j] -> PEi[i*COL+j]
                    
                // 计算通道的一维索引
                localparam int NS_IDX = i * COL + j;  // N2S[i][j] -> N2S[i*COL+j]
                localparam int NS_IDX_P1 = (i+1)*COL + j; // N2S[i+1][j] -> N2S[(i+1)*COL+j]
                
                localparam int EW_IDX = i * (COL+1) + j; // W2E[i][j] -> W2E[i*(COL+1)+j]
                localparam int EW_IDX_P1 = i * (COL+1) + j + 1; // E2W[i][j+1] -> E2W[i*(COL+1)+j+1]
                if(!((i == (ROW-1) && j == 0) || (i == 0 && j == (COL-1)) )) begin // left-top node and right_bottom node are specially defined for input and output port
                    router_reversed #(
                        .WIDTH(WIDTH), 
                        .FL(FL), 
                        .BL(BL), 
                        .NODE_NUM(COL*i+j), 
                        .X_HOP_LOC(X_HOP_LOC), 
                        .Y_HOP_LOC(Y_HOP_LOC)
                    ) router_node(
                        .Wi(W2E[EW_IDX]),         // W2E[i][j]
                        .Wo(E2W[EW_IDX]),         // E2W[i][j]
                        .Ei(E2W[EW_IDX_P1]),      // E2W[i][j+1]
                        .Eo(W2E[EW_IDX_P1]),      // W2E[i][j+1]
                        .Ni(N2S[NS_IDX_P1]),      // N2S[i+1][j]
                        .No(S2N[NS_IDX_P1]),      // S2N[i+1][j]
                        .Si(S2N[NS_IDX]),         // S2N[i][j]
                        .So(N2S[NS_IDX]),         // N2S[i][j]
                        .PEi(PEi[PE_IDX]),        // PEi[i][j]
                        .PEo(PEo[PE_IDX])         // PEo[i][j]
                    );
                end
                else if((i == (ROW-1) && j == 0)) begin
                    router_reversed #(
                        .WIDTH(WIDTH), 
                        .FL(FL), 
                        .BL(BL), 
                        .NODE_NUM(COL*i+j), 
                        .X_HOP_LOC(X_HOP_LOC), 
                        .Y_HOP_LOC(Y_HOP_LOC)
                    ) router_node(
                        .Wi(W2E[EW_IDX]),         // W2E[i][j]
                        .Wo(E2W[EW_IDX]),         // E2W[i][j]
                        .Ei(E2W[EW_IDX_P1]),      // E2W[i][j+1]
                        .Eo(W2E[EW_IDX_P1]),      // W2E[i][j+1]
                        .Ni(I),                   // external input
                        .No(S2N[NS_IDX_P1]),      // S2N[i+1][j]
                        .Si(S2N[NS_IDX]),         // S2N[i][j]
                        .So(N2S[NS_IDX]),         // N2S[i][j]
                        .PEi(PEi[PE_IDX]),        // PEi[i][j]
                        .PEo(PEo[PE_IDX])         // PEo[i][j]
                    );
                end
                else begin
                    router_reversed #(
                        .WIDTH(WIDTH), 
                        .FL(FL), 
                        .BL(BL), 
                        .NODE_NUM(COL*i+j), 
                        .X_HOP_LOC(X_HOP_LOC), 
                        .Y_HOP_LOC(Y_HOP_LOC)
                    ) router_node(
                        .Wi(W2E[EW_IDX]),         // W2E[i][j]
                        .Wo(E2W[EW_IDX]),         // E2W[i][j]
                        .Ei(E2W[EW_IDX_P1]),      // E2W[i][j+1]
                        .Eo(W2E[EW_IDX_P1]),      // W2E[i][j+1]
                        .Ni(N2S[NS_IDX_P1]),      // N2S[i+1][j]
                        .No(S2N[NS_IDX_P1]),      // S2N[i+1][j]
                        .Si(S2N[NS_IDX]),         // S2N[i][j]
                        .So(O),                   // external output
                        .PEi(PEi[PE_IDX]),        // PEi[i][j]
                        .PEo(PEo[PE_IDX])         // PEo[i][j]
                    );

                end
            end
        end
    endgenerate


endmodule