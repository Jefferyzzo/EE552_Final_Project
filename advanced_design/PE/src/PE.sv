`timescale 1ns/1ns

import SystemVerilogCSP::*;

module PE #(
    parameter FILTER_WIDTH  = 8,  
    parameter IFMAP_SIZE    = 25, 
    parameter OUTPUT_WIDTH  = 13, 
    parameter THRESHOLD     = 64,
    parameter FL	        = 2,
    parameter BL	        = 1,
    parameter DIRECTION_OUT = 0,
    parameter X_HOP_OUT     = 0,
    parameter Y_HOP_OUT     = 0,
    parameter PE_NODE       = 0,
    parameter X_HOP_ACK     = 0,
    parameter Y_HOP_ACK     = 0,
    parameter DIRECTION_ACK = 0
) (
    interface Packet_in, 
    interface Packet_out
); 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep (); 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Ifmapb_filter (); 
    Channel #(.WIDTH(3),.hsProtocol(P4PhaseBD)) Filter_row (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Data (); 

    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy0 ();  
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy1 (); 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy2 (); 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy3 (); 

    Channel #(.WIDTH(IFMAP_SIZE),.hsProtocol(P4PhaseBD)) Ifmap_data (); 
    Channel #(.WIDTH(5*FILTER_WIDTH-25),.hsProtocol(P4PhaseBD)) Conv_Loc (); 
    Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) Size (); 

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data ();  
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data (); 

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_reg (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_reg (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_reg (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data_reg (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data_reg (); 

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_copy0 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_copy0 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_copy0 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data_copy0 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data_copy0 (); 

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_copy1 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_copy1 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_copy1 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data_copy1 (); 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data_copy1 (); 

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out_timestep1 ();
    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out_timestep2 ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Adder_out ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Merge_out ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) OutSpike ();
    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Residue ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Residue_copy0 ();
    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Residue_copy1 ();
  
    depacketizer #( 
        .FILTER_WIDTH(FILTER_WIDTH), 
        .FL(FL),
        .BL(BL)
    ) dp (
        .Packet(Packet_in),             // input
        .Timestep(Timestep),            // output
        .Ifmapb_filter(Ifmapb_filter), 
        .Filter_row(Filter_row), 
        .Data(Data)
    );

    copy4 #( 
        .WIDTH(1),
        .FL(FL),
        .BL(BL)
    ) copy_timestep (
        .L(Timestep),
        .R0(Timestep_copy0),
        .R1(Timestep_copy1),
        .R2(Timestep_copy2),
        .R3(Timestep_copy3) 
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
        .Size(Size),
        .Conv_Loc(Conv_Loc),
        .Filter_row1(Filter_row1_data),
        .Filter_row2(Filter_row2_data),
        .Filter_row3(Filter_row3_data),
        .Filter_row4(Filter_row4_data),
        .Filter_row5(Filter_row5_data)
    );
    
    // Register for Filter_row1_data
    priority_mux #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row1 (
        .L0(Filter_row1_data),
        .L1(Filter_row1_data_copy1),    
        .R(Filter_row1_data_reg)
    );

    copy #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row1 (
        .L(Filter_row1_data_reg),
        .R0(Filter_row1_data_copy0),
        .R1(Filter_row1_data_copy1)    
    );

    // Register for Filter_row2_data
    priority_mux #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row2 (
        .L0(Filter_row2_data),
        .L1(Filter_row2_data_copy1),    
        .R(Filter_row2_data_reg)
    );

    copy #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row2 (
        .L(Filter_row2_data_reg),
        .R0(Filter_row2_data_copy0),
        .R1(Filter_row2_data_copy1)    
    );

    // Register for Filter_row3_data
    priority_mux #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row3 (
        .L0(Filter_row3_data),
        .L1(Filter_row3_data_copy1),    
        .R(Filter_row3_data_reg)
    );

    copy #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row3 (
        .L(Filter_row3_data_reg),
        .R0(Filter_row3_data_copy0),
        .R1(Filter_row3_data_copy1)    
    );

    // Register for Filter_row4_data
    priority_mux #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row4 (
        .L0(Filter_row4_data),
        .L1(Filter_row4_data_copy1),    
        .R(Filter_row4_data_reg)
    );

    copy #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row4 (
        .L(Filter_row4_data_reg),
        .R0(Filter_row4_data_copy0),
        .R1(Filter_row4_data_copy1)    
    );

    // Register for Filter_row5_data
    priority_mux #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row5 ( 
        .L0(Filter_row5_data),
        .L1(Filter_row5_data_copy1),    
        .R(Filter_row5_data_reg)
    );

    copy #( 
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row5 (
        .L(Filter_row5_data_reg),
        .R0(Filter_row5_data_copy0),
        .R1(Filter_row5_data_copy1)    
    );

    // MAC operation
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
        .Filter_row4(Filter_row4_data_copy0),
        .Filter_row5(Filter_row5_data_copy0), 
        .Ifmap(Ifmap_data),
        .Size(Size),
        .Out(Mac_out)
    );

    split #(
        .WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL) 
    ) mac_split (
        .L(Mac_out),
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
        .L1(Adder_out),
        .S(Timestep_copy1),
        .R(Merge_out)     
    ); 

    two_input_adder #(
        .WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL)
    ) adder (
        .L0(Mac_out_timestep2),
        .L1(Residue_copy1),
        .R(Adder_out)
    );

    spike_residue #(
        .WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL)
    ) sr (
        .L(Merge_out),
        .OutSpike(OutSpike),
        .Residue(Residue)    
    );

    conditional_copy #(
        .WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_residue (
        .L(Residue),
        .Timestep(Timestep_copy2),
        .R0(Residue_copy0), // copy to output packet
        .R1(Residue_copy1)  // copy to psum
    );

    packetizer #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .FL(FL),
        .BL(BL),
        .DIRECTION_OUT(DIRECTION_OUT),
        .X_HOP_OUT(X_HOP_OUT),
        .Y_HOP_OUT(Y_HOP_OUT),
        .PE_NODE(PE_NODE),
        .X_HOP_ACK(X_HOP_ACK),
        .Y_HOP_ACK(Y_HOP_ACK),
        .DIRECTION_ACK(DIRECTION_ACK)
    ) pa (
        .Timestep(Timestep_copy3),  
        .Residue(Residue_copy0), 
        .Outspike(OutSpike),
        .Conv_Loc(Conv_Loc),
        .Packet(Packet_out)
    ); 

endmodule