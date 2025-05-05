`timescale 1ns/1ns
import SystemVerilogCSP::*;

/*TODO: 1.the width of each parameter
        2.control unit
        3.output memory
*/
module top#(
    parameter FILTER_WIDTH = {{ FILTER_WIDTH | default(8) }},
    parameter IFMAP_SIZE   = {{ IFMAP_SIZE | default(25) }},
    parameter OUTPUT_WIDTH = {{ OUTPUT_WIDTH | default(13) }},
    parameter THRESHOLD    = {{ THRESHOLD | default(64) }},
    parameter FL	       = {{ FL | default(2) }},
    parameter BL	       = {{ BL | default(1) }},
    parameter ROW          = {{ ROW | default(4) }},
    parameter COL          = {{ COL | default(4) }},
    parameter WIDTH        = 13 + 5*FILTER_WIDTH
    parameter Y_HOP_LOC    = {{ Y_HOP_LOC | default(7) }},
    parameter X_HOP_LOC    = {{ X_HOP_LOC | default(4) }},
) (
    interface Packet_in,
    interface Packet_out
);

    // Declare Channels
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) PEi [0:{{ROW*COL-1}}] ();
    Channel #(.WIDTH(WIDTH-(8)), .hsProtocol(P4PhaseBD)) PEo [0:{{ROW*COL-1}}] (); 
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) N2S [0:{{(ROW+1)*COL-1}}] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) S2N [0:{{(ROW+1)*COL-1}}] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) E2W [0:{{ROW*(COL+1)-1}}] ();
    Channel #(.WIDTH(WIDTH), .hsProtocol(P4PhaseBD)) W2E [0:{{ROW*(COL+1)-1}}] ();

    // Dummy generators and buckets on edges
    {% for i in range(ROW) %}
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_W{{i}} (.r(W2E[{{i*(COL+1)}}]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_E{{i}} (.r(E2W[{{  i*(COL+1)+COL  }}]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_W{{i}} (.r(E2W[{{  i*(COL+1)  }}]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_E{{i}} (.r(W2E[{{  i*(COL+1)+COL }}]));
    {% endfor %}
    {% for j in range(COL) %}
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_N{{j}} (.r(N2S[{{ ROW*COL+j  }}]));
    dummy_dg #(.WIDTH(WIDTH)) dummyGen_S{{j}} (.r(S2N[{{j}}]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_N{{j}} (.r(S2N[{{ ROW*COL+j }}]));
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_S{{j}} (.r(N2S[{{j}}]));
    {% endfor %}
    
    // Router + PE per node
    {% for i in range(ROW) %}
        {% for j in range(COL) %}
            {% set PE_IDX = i * COL + j %}
            {% set NS_IDX = i * COL + j %}
            {% set NS_IDX_P1 = (i+1)*COL + j %}
            {% set EW_IDX = i*(COL+1) + j %}
            {% set EW_IDX_P1 = i*(COL+1) + j + 1 %}
            {% set X_HOP_OUT_CAL = COL - (PE_IDX % COL) - 1 %}
            {% set Y_HOP_OUT_CAL = PE_IDX//COL %}
            {% set X_HOP_ACK_CAL = PE_IDX % COL %}
            {% set Y_HOP_ACK_CAL = ROW - (PE_IDX// COL) - 1 %}

            {% set pe_name = "pe%d_%d" % (i, j) %}
            {% set rtr_name = "router_%d_%d" % (i, j) %}

            {% if i == ROW-1 and j == 0 %}
    // Router (right bottom) - input from Packet_in
    //control unit
    //************************************************************************************
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM({{PE_IDX}}), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) {{rtr_name}} (
        .Wi(W2E[{{EW_IDX}}]),
        .Wo(E2W[{{EW_IDX}}]),
        .Ei(E2W[{{EW_IDX_P1}}]),
        .Eo(W2E[{{EW_IDX_P1}}]),
        .Ni(Packet_in),
        .No(S2N[{{NS_IDX_P1}}]),
        .Si(S2N[{{NS_IDX}}]),
        .So(N2S[{{NS_IDX}}]),
        .PEi(PEi[{{PE_IDX}}]),
        .PEo(PEo[{{PE_IDX}}])
    );
    
    control_unit #(
        .FL(FL),
        .BL(BL)
    ) cu (
        .I(PEo[{{PE_IDX}}]),
        .O(PEi[{{PE_IDX}}])
    ); 
            {% elif i == 0 and j == COL-1 %}
    // Router (bottom right) - output to Packet_out
    // output port
    dummy_db #(.WIDTH(WIDTH)) dummyBucket_PEi{{PE_IDX}} (.r(PEi[{{PE_IDX}}]));
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM({{PE_IDX}}), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) {{rtr_name}} (
        .Wi(W2E[{{EW_IDX}}]),
        .Wo(E2W[{{EW_IDX}}]),
        .Ei(E2W[{{EW_IDX_P1}}]),
        .Eo(W2E[{{EW_IDX_P1}}]),
        .Ni(N2S[{{NS_IDX_P1}}]),
        .No(S2N[{{NS_IDX_P1}}]),
        .Si(S2N[{{NS_IDX}}]),
        .So(N2S[{{NS_IDX}}]),
        .PEi(PEi[{{PE_IDX}}]),
        .PEo(Packet_out)
    );



            {% else %}
    // Regular Router
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .NODE_NUM({{PE_IDX}}), .X_HOP_LOC(X_HOP_LOC), .Y_HOP_LOC(Y_HOP_LOC)) {{rtr_name}} (
        .Wi(W2E[{{EW_IDX}}]),
        .Wo(E2W[{{EW_IDX}}]),
        .Ei(E2W[{{EW_IDX_P1}}]),
        .Eo(W2E[{{EW_IDX_P1}}]),
        .Ni(N2S[{{NS_IDX_P1}}]),
        .No(S2N[{{NS_IDX_P1}}]),
        .Si(S2N[{{NS_IDX}}]),
        .So(N2S[{{NS_IDX}}]),
        .PEi(PEi[{{PE_IDX}}]),
        .PEo(PEo[{{PE_IDX}}])
    );

    // PE
    PE #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(3),
        .X_HOP_OUT({{ (ROW - 1) }}'b{{ "1" * X_HOP_OUT_CAL + "0" * ((ROW - 1) - X_HOP_OUT_CAL) }}),  
        .Y_HOP_OUT({{ (COL - 1) }}'b{{ "1" * Y_HOP_OUT_CAL + "0" * ((COL - 1) - Y_HOP_OUT_CAL) }}),  
        .PE_NODE({{PE_IDX}}),
        .X_HOP_ACK({{(ROW-1)}}'b{{ "1" * X_HOP_ACK_CAL }}{{ "0" * ((ROW - 1) - X_HOP_ACK_CAL) }}), 
        .Y_HOP_ACK({{(COL-1)}}'b{{ "1" * Y_HOP_ACK_CAL }}{{ "0" * ((COL - 1) - Y_HOP_ACK_CAL) }}),
        .DIRECTION_ACK(0)
    ) {{pe_name}} (
        .Packet_in(PEo[{{PE_IDX}}]),
        .Packet_out(PEi[{{PE_IDX}}])
    );
            {% endif %}



        {% endfor %}
    {% endfor %}

endmodule

