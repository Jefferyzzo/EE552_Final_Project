`timescale 1ns/1ns

import SystemVerilogCSP::*;

module PE #(
    parameter FILTER_WIDTH = 8,  // check
    parameter IFMAP_SIZE   = 25, // check
    parameter OUTPUT_WIDTH = 12,
    parameter THRESHOLD    = 64,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter DIRECTION    = 0,
    parameter X_HOP        = 0,
    parameter Y_HOP        = 0,
    parameter PE_NODE      = 0 
) (
    interface Packet_in, 
    interface Packet_out
); 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep (); // check
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Ifmapb_filter (); // check
    Channel #(.WIDTH(3),.hsProtocol(P4PhaseBD)) Filter_row (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Data (); // check

    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy0 (); // check 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy1 (); // check
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy2 (); // check
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy3 (); // check

    Channel #(.WIDTH(IFMAP_SIZE),.hsProtocol(P4PhaseBD)) Ifmap_data (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH-25),.hsProtocol(P4PhaseBD)) Conv_Loc (); // check

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data (); // check 
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data (); // check

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_reg (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_reg (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_reg (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data_reg (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data_reg (); // check

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_copy0 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_copy0 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_copy0 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data_copy0 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data_copy0 (); // check

    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row1_data_copy1 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row2_data_copy1 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row3_data_copy1 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row4_data_copy1 (); // check
    Channel #(.WIDTH(5*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Filter_row5_data_copy1 (); // check

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out_timestep1 ();
    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Mac_out_timestep2 ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Adder_out ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Merge_out ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) OutSpike ();
    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Residue ();

    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Residue_copy0 ();
    Channel #(.WIDTH(OUTPUT_WIDTH),.hsProtocol(P4PhaseBD)) Residue_copy1 ();
  
    depacketizer #( // check
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

    copy4 #( // check
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

    special_split #( // check
        .FILTER_WIDTH(FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) ss (
        .Data(Data),                        // input
        .Ifmapb_filter(Ifmapb_filter), 
        .Filter_row(Filter_row), 
        .Ifmap(Ifmap_data),                 // output
        .Conv_Loc(Conv_Loc),
        .Filter_row1(Filter_row1_data),
        .Filter_row2(Filter_row2_data),
        .Filter_row3(Filter_row3_data),
        .Filter_row4(Filter_row4_data),
        .Filter_row5(Filter_row5_data)
    );
    
    // Register for Filter_row1_data
    priority_mux #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row1 (
        .L0(Filter_row1_data),
        .L1(Filter_row1_data_copy1),    
        .R(Filter_row1_data_reg)
    );

    special_copy #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row1 (
        .L(Filter_row1_data_reg),
        .R0(Filter_row1_data_copy0),
        .R1(Filter_row1_data_copy1)    
    );

    // Register for Filter_row2_data
    priority_mux #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row2 (
        .L0(Filter_row2_data),
        .L1(Filter_row2_data_copy1),    
        .R(Filter_row2_data_reg)
    );

    special_copy #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row2 (
        .L(Filter_row2_data_reg),
        .R0(Filter_row2_data_copy0),
        .R1(Filter_row2_data_copy1)    
    );

    // Register for Filter_row3_data
    priority_mux #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row3 (
        .L0(Filter_row3_data),
        .L1(Filter_row3_data_copy1),    
        .R(Filter_row3_data_reg)
    );

    special_copy #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row3 (
        .L(Filter_row3_data_reg),
        .R0(Filter_row3_data_copy0),
        .R1(Filter_row3_data_copy1)    
    );

    // Register for Filter_row4_data
    priority_mux #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row4 (
        .L0(Filter_row4_data),
        .L1(Filter_row4_data_copy1),    
        .R(Filter_row4_data_reg)
    );

    special_copy #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) copy_filter_row4 (
        .L(Filter_row4_data_reg),
        .R0(Filter_row4_data_copy0),
        .R1(Filter_row4_data_copy1)    
    );

    // Register for Filter_row5_data
    priority_mux #( // check
        .WIDTH(5*FILTER_WIDTH),
        .FL(FL),
        .BL(BL)
    ) pr_filter_row5 ( // check
        .L0(Filter_row5_data),
        .L1(Filter_row5_data_copy1),    
        .R(Filter_row5_data_reg)
    );

    special_copy #( // check
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
        .DIRECTION(DIRECTION),
        .X_HOP(X_HOP),
        .Y_HOP(Y_HOP),
        .PE_NODE(PE_NODE) 
    ) pa (
        .Timestep(Timestep_copy3),  
        .Residue(Residue_copy0), 
        .Outspike(OutSpike),
        .Packet(Packet_out)
    ); 

endmodule