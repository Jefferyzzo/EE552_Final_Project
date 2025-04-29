`timescale 1ns/1ps
import SystemVerilogCSP::*;

module mesh_advanced#(
    parameter WIDTH = {{ WIDTH | default(15) }},
    parameter FL = {{ FL | default(2) }},
    parameter BL = {{ BL | default(2) }},
    parameter ROW = {{ ROW | default(4) }},
    parameter COL = {{ COL | default(4) }},
    parameter X_HOP_LOC = {{ X_HOP_LOC | default(4) }},
    parameter Y_HOP_LOC = {{ Y_HOP_LOC | default(7) }}
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
    {% for i in range(ROW) %}
        localparam int W_IDX_{{i}} = {{i}} * (COL+1);
        localparam int E_IDX_{{i}} = {{i}} * (COL+1) + COL;
        
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_W{{i}} (.r(W2E[W_IDX_{{i}}]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_E{{i}} (.r(E2W[E_IDX_{{i}}]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_W{{i}} (.r(E2W[W_IDX_{{i}}]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_E{{i}} (.r(W2E[E_IDX_{{i}}]));
    {% endfor %}

    {% for i in range(COL) %}
        localparam int N_IDX_{{i}} = ROW * COL + {{i}};
        localparam int S_IDX_{{i}} = {{i}};

        dummy_dg #(.WIDTH(WIDTH)) dummyGen_N{{i}} (.r(N2S[N_IDX_{{i}}]));
        dummy_dg #(.WIDTH(WIDTH)) dummyGen_S{{i}} (.r(S2N[S_IDX_{{i}}]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_N{{i}} (.r(S2N[N_IDX_{{i}}]));
        dummy_db #(.WIDTH(WIDTH)) dummyBucket_S{{i}} (.r(N2S[S_IDX_{{i}}]));
    {% endfor %}

    // Routers
    {% for i in range(ROW) %}
        {% for j in range(COL) %}
            localparam int PE_IDX_{{i}}_{{j}} = {{i}} * COL + {{j}};
            localparam int NS_IDX_{{i}}_{{j}} = {{i}} * COL + {{j}};
            localparam int NS_IDX_P1_{{i}}_{{j}} = ({{i}}+1)*COL + {{j}};
            localparam int EW_IDX_{{i}}_{{j}} = {{i}} * (COL+1) + {{j}};
            localparam int EW_IDX_P1_{{i}}_{{j}} = {{i}} * (COL+1) + {{j}} + 1;
            
            {% if not (i == ROW-1 and j == 0) %}
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_{{i}}_{{j}}),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_{{i}}_{{j}} (
                .Wi(W2E[EW_IDX_{{i}}_{{j}}]),
                .Wo(E2W[EW_IDX_{{i}}_{{j}}]),
                .Ei(E2W[EW_IDX_P1_{{i}}_{{j}}]),
                .Eo(W2E[EW_IDX_P1_{{i}}_{{j}}]),
                .Ni(N2S[NS_IDX_P1_{{i}}_{{j}}]),
                .No(S2N[NS_IDX_P1_{{i}}_{{j}}]),
                .Si(S2N[NS_IDX_{{i}}_{{j}}]),
                .So(N2S[NS_IDX_{{i}}_{{j}}]),
                .PEi(PEi[PE_IDX_{{i}}_{{j}}]),
                .PEo(PEo[PE_IDX_{{i}}_{{j}}])
            );
            {% else %}
            router_reversed #(
                .WIDTH(WIDTH),
                .FL(FL),
                .BL(BL),
                .NODE_NUM(PE_IDX_{{i}}_{{j}}),
                .X_HOP_LOC(X_HOP_LOC),
                .Y_HOP_LOC(Y_HOP_LOC)
            ) router_node_{{i}}_{{j}} (
                .Wi(W2E[EW_IDX_{{i}}_{{j}}]),
                .Wo(E2W[EW_IDX_{{i}}_{{j}}]),
                .Ei(E2W[EW_IDX_P1_{{i}}_{{j}}]),
                .Eo(W2E[EW_IDX_P1_{{i}}_{{j}}]),
                .Ni(I),
                .No(S2N[NS_IDX_P1_{{i}}_{{j}}]),
                .Si(S2N[NS_IDX_{{i}}_{{j}}]),
                .So(N2S[NS_IDX_{{i}}_{{j}}]),
                .PEi(PEi[PE_IDX_{{i}}_{{j}}]),
                .PEo(PEo[PE_IDX_{{i}}_{{j}}])
            );
            {% endif %}
        {% endfor %}
    {% endfor %}

endmodule
