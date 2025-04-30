`timescale 1ns/1ns

import SystemVerilogCSP::*;

module PE #(
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_SIZE   = 9,
    parameter OUTPUT_WIDTH = 12,
    parameter THRESHOLD    = 64,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter WIDTH_packet = 28,
    parameter WIDTH_dest = 3,
    parameter WIDTH_addr =3,
    parameter WIDTH = WIDTH_packet + WIDTH_addr + WIDTH_dest,
    parameter PE_NODE      = 0 
) (
    interface Packet_in, 
    interface Packet_out
); 
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Ifmapb_filter ();
    Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) Filter_row ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Data ();

    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy0 ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy1 ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy2 ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep_copy3 ();

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
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .WIDTH_packet(28),
        .WIDTH_addr(3),
        .WIDTH_dest(3),
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
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .WIDTH_packet(28),
        .WIDTH_addr(3),
        .WIDTH_dest(3),
        .FL(FL),
        .BL(BL),
        .PE_NODE(PE_NODE) 
    ) pa (
        .Timestep(Timestep_copy3),  
        .Residue(Residue_copy0), 
        .Outspike(OutSpike),
        .Packet(Packet_out)
    ); 

endmodule