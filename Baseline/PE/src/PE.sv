// PE top module

`timescale 1ns/1ns
import SystemVerilogCSP::*;

module pe #(
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_SIZE   = 9,
    parameter OUTPUT_WIDTH = 12,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter DIRECTION    = 0,
    parameter X_HOP        = 0,
    parameter Y_HOP        = 0,
    parameter PE_NODE      = 0 
) (
    interface  Packet,  
    // interface  Output
    // interface Out

); 
    
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Ifmapb_filter ();
    Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) Filter_row ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Data ();

    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy0 ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy1 ();

    Channel #(.WIDTH(IFMAP_SIZE),.hsProtocol(P4PhaseBD)) Ifmap_data ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data ();

    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_reg ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_reg ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_reg ();

    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_copy0 ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_copy0 ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_copy0 ();

    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_copy1 ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_copy1 ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_copy1 ();

    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Out ();

    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out_timestep1 ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out_timestep2 ();

  
    depacketizer #(
        .FILTER_WIDTH(FILTER_WIDTH), 
        .FL(FL),
        .BL(BL)
    ) dp (
        .Packet(Packet),                // input
        .Timestep(Timestep),            // output
        .Ifmapb_filter(Ifmapb_filter), 
        .Filter_row(Filter_row), 
        .Data(Data)
    );
    // timestep
    copy #(
        .WIDTH(1),
        .FL(FL),
        .BL(BL)
    ) copy_timestep (
        .L(Timestep),
        .R0(Timestep_copy0),
        .R1(Timestep_copy1)    
    );

    special_split #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) ss (
        .Data(Data),                        // input
        .Ifmapb_filter(Ifmapb_filter), 
        .Filter_row(Filter_row), 
        .Ifmap(Ifmap_data),                 // output
        .Filter_row1(Filter_row1_data),
        .Filter_row2(Filter_row2_data),
        .Filter_row3(Filter_row3_data)
    );
    
    // Register for Filter_row1_data
    priority_mux #(
        .WIDTH(3*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row1 (
        .L0(Filter_row1_data),
        .L1(Filter_row1_data_copy1),    
        .R(Filter_row1_data_reg)
    );

    copy #(
        .WIDTH(3*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row1 (
        .L(Filter_row1_data_reg),
        .R0(Filter_row1_data_copy0),
        .R1(Filter_row1_data_copy1)    
    );

    // Register for Filter_row2_data
    priority_mux #(
        .WIDTH(3*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row2 (
        .L0(Filter_row2_data),
        .L1(Filter_row2_data_copy1),    
        .R(Filter_row2_data_reg)
    );

    copy #(
        .WIDTH(3*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row2 (
        .L(Filter_row2_data_reg),
        .R0(Filter_row2_data_copy0),
        .R1(Filter_row2_data_copy1)    
    );

    // Register for Filter_row3_data
    priority_mux #(
        .WIDTH(3*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row3 (
        .L0(Filter_row3_data),
        .L1(Filter_row3_data_copy1),    
        .R(Filter_row3_data_reg)
    );

    copy #(
        .WIDTH(3*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row3 (
        .L(Filter_row3_data_reg),
        .R0(Filter_row3_data_copy0),
        .R1(Filter_row3_data_copy1)    
    );

    //mac operation
    mac #(
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_WIDTH(1),
        .FL(FL),
        .BL(BL)
    ) mac (
        .Filter_row1(Filter_row1_data_copy0), 
        .Filter_row2(Filter_row2_data_copy0), 
        .Filter_row3(Filter_row3_data_copy0), 
        .Ifmap(Ifmap_data),
        .Out(Out)
    );

    split #(
        .WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL) 
    ) mac_split (
        .L(Out),
        .S(Timestep_copy0),
        .R0(Mac_out_timestep1), 
        .R1(Mac_out_timestep2)   
    );

    merge #(
        .WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL) 
    ) merge_timestep (
        .L0(Mac_out_timestep1),
        .L1(),
        .S(Timestep_copy1),
        .R()     
); 

    two_input_adder #(
        .WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL)
    ) adder (
        .L0(Mac_out_timestep2),
        .L1(),
        .R(Out)
    );



endmodule