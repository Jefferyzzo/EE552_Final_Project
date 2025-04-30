`timescale 1ns/1ns

import SystemVerilogCSP::*;


// ************************************************** Input Filter Packet Format***********************************************************************************************
//  Address    [5*FILTER_WIDTH+4:5]     [4:3]       [2]         [1]                 [0]              
//             filter_data              filter_size timestep    ifmap(0)_filter(1)  ack(0)_input(1)  
// **********************************************************************************************************************************************************************


// ************************************************** Input Ifmap Packet Format***********************************************************************************************
//  Address    [5*FILTER_WIDTH+4:9]     [8:3]       [2]         [1]                 [0]              
//             ifmap_data               ifmap_size  timestep    ifmap(0)_filter(1)  ack(0)_input(1)  
// **********************************************************************************************************************************************************************
// ifmap_data width is 36 bits

// ************************************************** Input Ack Packet Format***********************************************************************************************
//             
//  Address    [5*FILTER_WIDTH+4:5]     [4:1]       [0]               
//             0s                       PE_node     ack(0)_input(1)  
// **********************************************************************************************************************************************************************

// ************************************************** Output Pakcet Data***********************************************************************************************
//             
//  Address    [5*FILTER_WIDTH+12:13]       [12:10]     [9]                 [8]       [7:5]    [4:2]    [1:0]            
//             data                         filter_row  ifmap(0)_filter(1)  timestep  y-hop    x-hop    direction 
//  data format for ifmap data:
//  Address    [5*FILTER_WIDTH+12:5*FILTER_WIDTH-12]    [5*FILTER_WIDTH-13:15]  [14:13]
//             ifmap data                               conv_loc                size
// *****************************************************************************************************************************************************************************

// e.g for data field under 3*3 filter: 0, 0, filter2, filter1, filter0
// e.g for ifmap data: if0, if1, if2 ..., if24
// FILTER_WIDTH = 8, maximum conv size is (2^5)^2, maximum ifmap size is (2*5+4)^2


// Instruction must input filter data and size first, then input ifmap data and size

module control_unit #(
parameter FL	= 2 ,
parameter BL	= 2
) (
interface  I    ,
interface  O  
); 


// Channels between input packets and output arbiter
Channel #(.WIDTH(46),.hsProtocol(P4PhaseBD)) ID_Ifmem ();
Channel #(.WIDTH(44),.hsProtocol(P4PhaseBD)) ID_Filmem ();
Channel #(.WIDTH(3),.hsProtocol(P4PhaseBD)) ID_Filgen ();
Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) ID_Pkt ();
Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) ID_TB [13:0] ();
Channel #(.WIDTH(6),.hsProtocol(P4PhaseBD)) Ifmem_Ifgen ();
Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Pkt_Ifmem ();
Channel #(.WIDTH(25),.hsProtocol(P4PhaseBD)) Ifmem_Pkt ();
Channel #(.WIDTH(3),.hsProtocol(P4PhaseBD)) Pkt_Filmem ();
Channel #(.WIDTH(40),.hsProtocol(P4PhaseBD)) Filmem_Pkt ();
Channel #(.WIDTH(18),.hsProtocol(P4PhaseBD)) Ifgen_Alloc ();
Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Filgen_Alloc ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Alloc_FIFO [13:0] ();
Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) TB_FIFO [13:0] ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) FIFO_Arb [13:0] ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Arb_Pkt ();


Instr_Decoder ID (
    .I(I),  
    .O_if_data(ID_Ifmem), 
    .O_fil_data(ID_Filmem), 
    .O_fil_inst(ID_Filgen),
    .O_packetizer(ID_Pkt), 
    .PE_ack(ID_TB)
);

Ifmap_Mem Ifmem (
    .W(ID_Ifmem),
    .R_req(Pkt_Ifmem),
    .R_data(Ifmem_Pkt),
    .Inst_gen(Ifmem_Ifgen)
);

Filter_Mem Filmem (
    .W(ID_Filmem),
    .R_req(Pkt_Filmem),
    .R_data(Filmem_Pkt)
);

Ifmap_Inst_Generator Ifgen (
    .I(Ifmem_Ifgen),
    .O_FIFO(Ifgen_Alloc)
);

Filter_Inst_Generator Filgen (
    .I(ID_Filgen),
    .O_FIFO(Filgen_Alloc)
);

Allocate Alloc (
    .I_fil(Filgen_Alloc),
    .I_if(Ifgen_Alloc),
    .O(Alloc_FIFO)
);


genvar i;
generate
    for (i = 0; i <= 13; i = i + 1) begin : gen_fifo
        Inst_FIFO PE_FIFO (
            .I_inst(Alloc_FIFO[i]),
            .I_ack(ID_TB[i]),
            .O(FIFO_Arb[i])
        );

        token_buffer TB (
            .left(ID_TB[i]), 
            .right(TB_FIFO[i])
        );
    end
endgenerate


arbiter_14in Arb (
    .L(FIFO_Arb),
    .R(Arb_Pkt)     
); 


packetizer_cu pkt(
    .I_FIFO(Arb_Pkt),
    .I_fil_size(ID_Pkt),
    .Fil_addr(Pkt_Filmem),
    .Fil_data(Filmem_Pkt),
    .If_addr(Pkt_Ifmem),
    .If_data(Ifmem_Pkt),
    .O(O)
);




endmodule



