`timescale 1ns/1ns

import SystemVerilogCSP::*;

// ************************************************** Input DATA Format****************************************************
//  Address    [5*FILTER_WIDTH+5]   [5*FILTER_WIDTH+4:5*FILTER_WIDTH+3]      [5*FILTER_WIDTH+2:7]     [6:1]       [0]         
//             done                 fil_size                                 ifmap_data               ifmap_size  timestep   
// ************************************************************************************************************************

// ************************************************** Input Addr Format***********************************
//  Address    [12:7]     [12:1]    [0]         
//             y_loc      x_loc     timestep   
// *******************************************************************************************************
module Ifmap_Mem #(
    parameter WIDTH_IN = 46,
    parameter WIDTH_OUT = 25,
    parameter SIZE	= 38,
    parameter DEPTH = 5 ,
    parameter FL	= 2 ,
    parameter BL	= 2
    ) (
    interface   W,
    interface   R_req,
    interface   R_data,
    interface   Inst_gen
    );
    logic [SIZE-1:0] data_ts0 [SIZE-1:0]; // data storage for timestep 0  
    logic [SIZE-1:0] data_ts1 [SIZE-1:0]; // data storage for timestep 1
    logic [WIDTH_IN-1:0] in_packet;
    logic [1:0] fil_size;
    logic [5:0] if_size, conv_size;
    logic [5:0] y_ts0, x_ts0, y_ts1, x_ts1; // location for storing ifmap data bit
    integer i_ts0, i_ts1, cnt_ts0, cnt_ts1;
    integer i, j;
    logic done;

    
    logic [12:0] in_addr;
    logic [WIDTH_OUT-1:0] out_packet;

    initial begin
        y_ts0 = 0;
        x_ts0 = 0;
        y_ts1 = 0;
        x_ts1 = 0;
        i_ts0 = 0;
        i_ts1 = 0;
        for(i = 0; i < SIZE; i++) begin  // initialize memory data to 0
            data_ts0[i] = 0;
            data_ts1[i] = 0;
        end
    end


    always begin // Write Operation
        done = 0;
        W.Receive(in_packet); // receive write address and data
        // $display("At %t, ifmap receive packet %h of timestep %d, done = %d", $time, in_packet, in_packet[0], in_packet[WIDTH_IN-1]);
        #FL;
        if_size = in_packet[6:1];
        fil_size = in_packet[44:43];
        // $display("At %t, if_size %h", $time, if_size);
        if(!in_packet[0]) begin // timestep 0
            for(i_ts0 = 0; i_ts0 < 36; i_ts0++) begin
                
                if(!done) begin
                    data_ts0[y_ts0][x_ts0] = in_packet[i_ts0+7];
                    // $display("Storing %d th number %b in y = %d, x = %d", i_ts0, in_packet[i_ts0+7], y_ts0, x_ts0);
                end
                if(!(y_ts0 == (if_size-1) && x_ts0 == (if_size-1))) begin
                    if(x_ts0 == (if_size-1)) begin
                        x_ts0 = 0;
                        y_ts0++;
                    end
                    else
                        x_ts0++;

                end
                else done = 1;
            end

        end
        else begin // timestep 1
            for(i_ts1 = 0; i_ts1 < 36; i_ts1++) begin
                
                if(!done) begin
                    data_ts1[y_ts1][x_ts1] = in_packet[i_ts1+7];
                    // $display("Storing %d th number %b in y = %d, x = %d", i_ts1, in_packet[i_ts1+7], y_ts1, x_ts1);
                end
                if(!(y_ts1 == (if_size-1) && x_ts1 == (if_size-1))) begin
                    if(x_ts1 == (if_size-1)) begin
                        x_ts1 = 0;
                        y_ts1++;
                    end
                    else
                        x_ts1++;

                end
                else done = 1;
            end
            if(in_packet[WIDTH_IN-1]) begin  // all ifmap data finishes storing
                conv_size = in_packet[6:1] - in_packet[44:43] - 1;
                Inst_gen.Send(conv_size);
            end
        end

    end


    logic  [5:0]  x, y, y_end;
    logic  [SIZE-1:0] line;
    always begin // Read Operation
        R_req.Receive(in_addr);
        #FL;
        y = in_addr[12:7];
        x = in_addr[6:1];
        out_packet = 0;
        // $display("At %t, ifmap receives addr, y = %h, x = %h, timestep = %h", $time, y, x, in_addr[0]);
        if (!in_addr[0]) begin // timestep 0
            case (fil_size)
                2'b00: begin // 2*2 filter
                    for (int i = 0; i < 2; i++) begin
                        for(int j = 0; j < 2; j++) begin
                            out_packet[3-(i*2 + j)] = data_ts0[y + i][x + j];
                        end
                    end
                end
                2'b01: begin  // 3*3 filter
                    for (int i = 0; i < 3; i++) begin
                        for(int j = 0; j < 3; j++) begin
                            out_packet[8-(i*3 + j)] = data_ts0[y + i][x + j];
                        end
                    end
                end
                2'b10: begin // 4*4 filter
                    for (int i = 0; i < 4; i++) begin
                        for(int j = 0; j < 4; j++) begin
                            out_packet[15-(i*4 + j)] = data_ts0[y + i][x + j];
                        end
                    end
                end
                2'b11: begin // 5*5 filter
                    for (int i = 0; i < 5; i++) begin
                        for(int j = 0; j < 5; j++) begin
                            out_packet[24-(i*5 + j)] = data_ts0[y + i][x + j];
                        end
                    end
                end
                default: ;
            endcase
            // $display("Timestep 0 out packet = %b", out_packet);
        end else begin // timestep 1
            case (fil_size)
                2'b00: begin // 2*2 filter
                    for (int i = 0; i < 2; i++) begin
                        for(int j = 0; j < 2; j++) begin
                            out_packet[3-(i*2 + j)] = data_ts1[y + i][x + j];
                        end
                    end
                end
                2'b01: begin  // 3*3 filter
                    for (int i = 0; i < 3; i++) begin
                        for(int j = 0; j < 3; j++) begin
                            out_packet[8-(i*3 + j)] = data_ts1[y + i][x + j];
                        end
                    end
                end
                2'b10: begin // 4*4 filter
                    for (int i = 0; i < 4; i++) begin
                        for(int j = 0; j < 4; j++) begin
                            out_packet[15-(i*4 + j)] = data_ts1[y + i][x + j];
                        end
                    end
                end
                2'b11: begin // 5*5 filter
                    for (int i = 0; i < 5; i++) begin
                        for(int j = 0; j < 5; j++) begin
                            out_packet[24-(i*5 + j)] = data_ts1[y + i][x + j];
                        end
                    end
                end
                default: ;
            endcase
            // $display("Timestep 1 out packet = %b", out_packet);
        end



/*
        // if(!in_addr[0]) begin // Read timestep 0 data
        //     case(in_addr[14:13]) // fill data packet according to filter size
        //         2'b00:
        //         begin
        //             out_packet[30:28] = data_ts0[x][y_end:y];
        //             out_packet[33:31] = data_ts0[x+1][y_end:y];
        //             out_packet[36:34] = data_ts0[x+2][y_end:y];
        //         end
        //         2'b01:
        //         begin
        //             out_packet[31:28] = data_ts0[x][y+3:y];
        //             out_packet[35:32] = data_ts0[x+1][y+3:y];
        //             out_packet[39:36] = data_ts0[x+2][y+3:y];
        //             out_packet[43:40] = data_ts0[x+3][y+3:y];
        //         end
        //         2'b10:
        //         begin
        //             out_packet[32:28] = data_ts0[x][y+4:y];
        //             out_packet[37:37] = data_ts0[x+1][y+4:y];
        //             out_packet[42:38] = data_ts0[x+2][y+4:y];
        //             out_packet[47:43] = data_ts0[x+3][y+4:y];
        //             out_packet[52:48] = data_ts0[x+4][y+4:y];
        //         end
        //         default:;
        //     endcase
        // end
        // else begin // Read timestep 1 data
        //     case(in_addr[14:13]) // fill data packet according to filter size
        //         2'b00:
        //         begin
        //             out_packet[30:28] = data_ts1[x][y+2:y];
        //             out_packet[33:31] = data_ts1[x+1][y+2:y];
        //             out_packet[36:34] = data_ts1[x+2][y+2:y];
        //         end
        //         2'b01:
        //         begin
        //             out_packet[31:28] = data_ts1[x][y+3:y];
        //             out_packet[35:32] = data_ts1[x+1][y+3:y];
        //             out_packet[39:36] = data_ts1[x+2][y+3:y];
        //             out_packet[43:40] = data_ts1[x+3][y+3:y];
        //         end
        //         2'b10:
        //         begin
        //             out_packet[32:28] = data_ts1[x][y+4:y];
        //             out_packet[37:37] = data_ts1[x+1][y+4:y];
        //             out_packet[42:38] = data_ts1[x+2][y+4:y];
        //             out_packet[47:43] = data_ts1[x+3][y+4:y];
        //             out_packet[52:48] = data_ts1[x+4][y+4:y];
        //         end
        //         default:;
        //     endcase
        // end
*/
        

        R_data.Send(out_packet);
        #BL;
    end
endmodule





