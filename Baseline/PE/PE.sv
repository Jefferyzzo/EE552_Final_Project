// PE top module

`timescale 1ns/1ns
import SystemVerilogCSP::*;

module pe #(
    parameter FILTER_WIDTH = 8,
    parameter IFMAP_SIZE   = 9,
    parameter FL	       = 2,
    parameter BL	       = 1,
    parameter DIRECTION    = 0,
    parameter X_HOP        = 0,
    parameter Y_HOP        = 0,
    parameter PE_NODE      = 0 
) (
    interface  Packet,  
    interface  Output
); 
    
    Channel #(.WIDTH(3*FILTER_WIDTH+4),.hsProtocol(P4PhaseBD)) Packet ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Timestep ();
    Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) Ifmapb_filter ();
    Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) Filter_row ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Data ();

    Channel #(.WIDTH(IFMAP_SIZE),.hsProtocol(P4PhaseBD)) Ifmap_data ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Fiter_row1_data ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Fiter_row2_data ();
    Channel #(.WIDTH(3*FILTER_WIDTH),.hsProtocol(P4PhaseBD)) Fiter_row3_data ();
  
    Channel #(.WIDTH(IFMAP_SIZE),.hsProtocol(P4PhaseBD)) Ifmap_data ();

    depacketizer #(
                 .FILTER_WIDTH(FILTER_WIDTH), 
                 .FL(FL),
                 .BL(BL)
                ) dp (
                 .Packet(Packet),                       //input
                 .Timestep(Timestep),                   //output
                 .Ifmapb_filter(Ifmapb_filter), 
                 .Filter_row(Filter_row), 
                 .Data(Data)
                );

    special_split #(
                    .FILTER_WIDTH(FILTER_WIDTH),
                    .FL(FL),
                    .BL(BL)
                ) ss (
                    .Data(Data),                        //input
                    .Ifmapb_filter(Ifmapb_filter), 
                    .Filter_row(Filter_row), 
                    .Ifmap(Ifmap_data),                 //output
                    .Filter_row1(Fiter_row1_data),
                    .Filter_row2(Fiter_row2_data),
                    .Filter_row3(Fiter_row3_data)
                );
    
    // ifmap dataflow
    priority #(.WIDTH(IFMAP_SIZE),
               .FL(FL),
               .BL(BL)
            ) pr_ifmap (
               .L0(Ifmap_data),
               .L1(),    //todo
               .R()
            )

      


endmodule