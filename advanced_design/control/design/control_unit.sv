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
Channel #(.WIDTH(43),.hsProtocol(P4PhaseBD)) ID_Ifmem ();
Channel #(.WIDTH(43),.hsProtocol(P4PhaseBD)) ID_filmem ();
Channel #(.WIDTH(8),.hsProtocol(P4PhaseBD)) ID_Ifgen ();
Channel #(.WIDTH(3),.hsProtocol(P4PhaseBD)) ID_filgen ();
Channel #(.WIDTH(0),.hsProtocol(P4PhaseBD)) ID_TB [13:0] ();
Channel #(.WIDTH(25),.hsProtocol(P4PhaseBD)) Pkt_Ifmem ();
Channel #(.WIDTH(15),.hsProtocol(P4PhaseBD)) Ifmem_Pkt ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Ifgen_Mrg ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Filgen_Mrg_inst ();
Channel #(.WIDTH(0),.hsProtocol(P4PhaseBD)) Filgen_Mrg_done ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Mrg_Cpy ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Cpy_FIFO [13:0] ();
Channel #(.WIDTH(0),.hsProtocol(P4PhaseBD)) TB_FIFO [13:0] ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) FIFO_Arb [13:0] ();
Channel #(.WIDTH(14),.hsProtocol(P4PhaseBD)) Arb_Pkt ();





endmodule



