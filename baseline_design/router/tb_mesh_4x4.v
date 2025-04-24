`timescale 1ns/1ps

module tb_mesh_4x4;
    
    parameter NUM_OF_CYCLE = 1;

    // ID of each PE
    localparam PE_0 = 0;
    localparam PE_1 = 1;
    localparam PE_2 = 2;
    localparam PE_3 = 3;
    localparam PE_4 = 4;
    localparam PE_5 = 5;
    localparam PE_6 = 6;
    localparam PE_7 = 7;
    localparam PE_8 = 8;
    localparam PE_9 = 9;
    localparam PE_10 = 10;
    localparam PE_11 = 11;
    localparam PE_12 = 12;
    localparam PE_13 = 13;
    localparam PE_14 = 14;
    localparam PE_15 = 15;


    reg clk;
    reg reset;
    reg polarity;

    // 定义 PEIO 端口
    reg [0:15] pesi ;
    reg [0:15] pero ;
    wire[0:15] peri ;
    wire[0:15] peso ;
    reg  [63:0] pedi [0:15];
    wire [63:0] pedo [0:15];
    integer packet_count;

    // 250MHz 时钟 (周期 = 4ns)
    initial clk = 0;
    always #2 clk = ~clk; 

    always @ (posedge clk) begin
        if (reset) polarity <= 0;
        else polarity <= ~polarity;
    end

    // instantiate the mesh_4x4 module
    mesh_4x4 uut (
        .clk(clk),
        .reset(reset),
        // node (0,0)
        .pesi_x0_y0(pesi[0]), .pero_x0_y0(pero[0]),
        .peri_x0_y0(peri[0]), .peso_x0_y0(peso[0]),
        .pedi_x0_y0(pedi[0]), .pedo_x0_y0(pedo[0]),
        // node (1,0)
        .pesi_x1_y0(pesi[1]), .pero_x1_y0(pero[1]),
        .peri_x1_y0(peri[1]), .peso_x1_y0(peso[1]),
        .pedi_x1_y0(pedi[1]), .pedo_x1_y0(pedo[1]),
        // node (2,0)
        .pesi_x2_y0(pesi[2]), .pero_x2_y0(pero[2]),
        .peri_x2_y0(peri[2]), .peso_x2_y0(peso[2]),
        .pedi_x2_y0(pedi[2]), .pedo_x2_y0(pedo[2]),
        // node (3,0)
        .pesi_x3_y0(pesi[3]), .pero_x3_y0(pero[3]),
        .peri_x3_y0(peri[3]), .peso_x3_y0(peso[3]),
        .pedi_x3_y0(pedi[3]), .pedo_x3_y0(pedo[3]),
        // node (0,1)
        .pesi_x0_y1(pesi[4]), .pero_x0_y1(pero[4]),
        .peri_x0_y1(peri[4]), .peso_x0_y1(peso[4]),
        .pedi_x0_y1(pedi[4]), .pedo_x0_y1(pedo[4]),
        // node (1,1)
        .pesi_x1_y1(pesi[5]), .pero_x1_y1(pero[5]),
        .peri_x1_y1(peri[5]), .peso_x1_y1(peso[5]),
        .pedi_x1_y1(pedi[5]), .pedo_x1_y1(pedo[5]),
        // node (2,1)
        .pesi_x2_y1(pesi[6]), .pero_x2_y1(pero[6]),
        .peri_x2_y1(peri[6]), .peso_x2_y1(peso[6]),
        .pedi_x2_y1(pedi[6]), .pedo_x2_y1(pedo[6]),
        // node (3,1)
        .pesi_x3_y1(pesi[7]), .pero_x3_y1(pero[7]),
        .peri_x3_y1(peri[7]), .peso_x3_y1(peso[7]),
        .pedi_x3_y1(pedi[7]), .pedo_x3_y1(pedo[7]),
        // node (0,2)
        .pesi_x0_y2(pesi[8]), .pero_x0_y2(pero[8]),
        .peri_x0_y2(peri[8]), .peso_x0_y2(peso[8]),
        .pedi_x0_y2(pedi[8]), .pedo_x0_y2(pedo[8]),
        // node (1,2)
        .pesi_x1_y2(pesi[9]), .pero_x1_y2(pero[9]),
        .peri_x1_y2(peri[9]), .peso_x1_y2(peso[9]),
        .pedi_x1_y2(pedi[9]), .pedo_x1_y2(pedo[9]),
        // node (2,2)
        .pesi_x2_y2(pesi[10]), .pero_x2_y2(pero[10]),
        .peri_x2_y2(peri[10]), .peso_x2_y2(peso[10]),
        .pedi_x2_y2(pedi[10]), .pedo_x2_y2(pedo[10]),
        // node (3,2)
        .pesi_x3_y2(pesi[11]), .pero_x3_y2(pero[11]),
        .peri_x3_y2(peri[11]), .peso_x3_y2(peso[11]),
        .pedi_x3_y2(pedi[11]), .pedo_x3_y2(pedo[11]),
        // node (0,3)
        .pesi_x0_y3(pesi[12]), .pero_x0_y3(pero[12]),
        .peri_x0_y3(peri[12]), .peso_x0_y3(peso[12]),
        .pedi_x0_y3(pedi[12]), .pedo_x0_y3(pedo[12]),
        // node (1,3)
        .pesi_x1_y3(pesi[13]), .pero_x1_y3(pero[13]),
        .peri_x1_y3(peri[13]), .peso_x1_y3(peso[13]),
        .pedi_x1_y3(pedi[13]), .pedo_x1_y3(pedo[13]),
        // node (2,3)
        .pesi_x2_y3(pesi[14]), .pero_x2_y3(pero[14]),
        .peri_x2_y3(peri[14]), .peso_x2_y3(peso[14]),
        .pedi_x2_y3(pedi[14]), .pedo_x2_y3(pedo[14]),
        // node (3,3)
        .pesi_x3_y3(pesi[15]), .pero_x3_y3(pero[15]),
        .peri_x3_y3(peri[15]), .peso_x3_y3(peso[15]),
        .pedi_x3_y3(pedi[15]), .pedo_x3_y3(pedo[15])

    );


//--------------------------------------------------------------------
//gather testbench
//--------------------------------------------------------------------
    function [3:0] hop_convert;
        input signed [3:0] hop_in;
        integer i;
        reg [3:0] temp;
        reg [3:0] abs_val;
        begin
            abs_val = (hop_in < 0) ? -hop_in : hop_in; //absolute value
            temp = 4'b0000;

            for (i = 0; i < abs_val && i < 4; i = i + 1) begin
                temp[i] = 1'b1; // eg. 3 => 0011
            end

            hop_convert = temp;
        end
    endfunction

    task generate_packet;
        input integer src_pe;
        input integer dst_pe;
        
        integer dest_x, dest_y;
        integer src_x, src_y;
        integer hopcount_x, hopcount_y;
        begin
            // 坐标转换
            dest_x = dst_pe % 4;
            dest_y = dst_pe / 4;
            src_x  = src_pe % 4;
            src_y  = src_pe / 4;

            // hopcount 动态计算
            hopcount_y = dest_y - src_y; // placeholder
            hopcount_x = dest_x - src_x; // placeholder

            // header区
            pedi[src_pe][63]     = polarity;
            pedi[src_pe][62]     = (dest_x > src_x) ? 1'b1 : 1'b0; // dir_x 1:CCW 0:CW
            pedi[src_pe][61]     = (dest_y < src_y) ? 1'b1 : 1'b0; // dir_y 1:S, 0:N
            pedi[src_pe][60:56]  = 5'd0;
            pedi[src_pe][55:52]  = hop_convert(hopcount_y);
            pedi[src_pe][51:48]  = hop_convert(hopcount_x);

            // payload区
            pedi[src_pe][47:32]  = src_pe; // 源PEID
            pedi[src_pe][31:4]  = 0; 
            pedi[src_pe][3:0]    = dst_pe; // payload[3:0]
            $fdisplay(sent_file, "src_pe = %d,direction = %b,  hop count = %b, packet = %h at time %0dns", src_pe, pedi[src_pe][62:61], pedi[src_pe][55:48],pedi[src_pe],$time);
            
        end
    endtask
//send data in phase k and return status
//0: not finished
//1: finished
    task send_data;
        input [3:0] phase;
        output status;
        integer num_sent [0:15];
        
        begin
            status = 0;//not finished
            packet_count = 1;
            num_sent [0] = 0;
            num_sent [1] = 0;
            num_sent [2] = 0;
            num_sent [3] = 0;
            num_sent [4] = 0;
            num_sent [5] = 0;
            num_sent [6] = 0;
            num_sent [7] = 0;
            num_sent [8] = 0;
            num_sent [9] = 0;
            num_sent [10] = 0;
            num_sent [11] = 0;
            num_sent [12] = 0;
            num_sent [13] = 0;
            num_sent [14] = 0;
            num_sent [15] = 0;

            fork
                begin
                    while (num_sent[0] < packet_count && phase != 0) begin
                        @(posedge clk); #0.1;
                        if (phase != 0 && peri[0]) begin
                            generate_packet(0, phase);
                            pesi[0] = 1;
                            @(posedge clk); #0.1;
                            pesi[0] = 0;
                            num_sent[0] = num_sent[0] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[1] < packet_count && phase != 1) begin
                        @(posedge clk); #0.1;
                        if (phase != 1 && peri[1]) begin
                            generate_packet(1, phase);
                            pesi[1] = 1;
                            @(posedge clk); #0.1;
                            pesi[1] = 0;
                            num_sent[1] = num_sent[1] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[2] < packet_count && phase != 2) begin
                        @(posedge clk); #0.1;
                        if (phase != 2 && peri[2]) begin
                            generate_packet(2, phase);
                            pesi[2] = 1;
                            @(posedge clk); #0.1;
                            pesi[2] = 0;
                            num_sent[2] = num_sent[2] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[3] < packet_count && phase != 3) begin
                        @(posedge clk); #0.1;
                        if (phase != 3 && peri[3]) begin
                            generate_packet(3, phase);
                            pesi[3] = 1;
                            @(posedge clk); #0.1;
                            pesi[3] = 0;
                            num_sent[3] = num_sent[3] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[4] < packet_count && phase != 4) begin
                        @(posedge clk); #0.1;
                        if (phase != 4 && peri[4]) begin
                            generate_packet(4, phase);
                            pesi[4] = 1;
                            @(posedge clk); #0.1;
                            pesi[4] = 0;
                            num_sent[4] = num_sent[4] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[5] < packet_count && phase != 5) begin
                        @(posedge clk); #0.1;
                        if (phase != 5 && peri[5]) begin
                            generate_packet(5, phase);
                            pesi[5] = 1;
                            @(posedge clk); #0.1;
                            pesi[5] = 0;
                            num_sent[5] = num_sent[5] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[6] < packet_count && phase != 6) begin
                        @(posedge clk); #0.1;
                        if (phase != 6 && peri[6]) begin
                            generate_packet(6, phase);
                            pesi[6] = 1;
                            @(posedge clk); #0.1;
                            pesi[6] = 0;
                            num_sent[6] = num_sent[6] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[7] < packet_count && phase != 7) begin
                        @(posedge clk); #0.1;
                        if (phase != 7 && peri[7]) begin
                            generate_packet(7, phase);
                            pesi[7] = 1;
                            @(posedge clk); #0.1;
                            pesi[7] = 0;
                            num_sent[7] = num_sent[7] + 1;
                        end
                    end
                end 
                begin
                    while (num_sent[8] < packet_count && phase != 8) begin
                        @(posedge clk); #0.1;
                        if (phase != 8 && peri[8]) begin
                            generate_packet(8, phase);
                            pesi[8] = 1;
                            @(posedge clk); #0.1;
                            pesi[8] = 0;
                            num_sent[8] = num_sent[8] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[9] < packet_count && phase != 9) begin
                        @(posedge clk); #0.1;
                        if (phase != 9 && peri[9]) begin
                            generate_packet(9, phase);
                            pesi[9] = 1;
                            @(posedge clk); #0.1;
                            pesi[9] = 0;
                            num_sent[9] = num_sent[9] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[10] < packet_count && phase != 10) begin
                        @(posedge clk); #0.1;
                        if (phase != 10 && peri[10]) begin
                            generate_packet(10, phase);
                            pesi[10] = 1;
                            @(posedge clk); #0.1;
                            pesi[10] = 0;
                            num_sent[10] = num_sent[10] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[11] < packet_count && phase != 11) begin
                        @(posedge clk); #0.1;
                        if (phase != 11 && peri[11]) begin
                            generate_packet(11, phase);
                            pesi[11] = 1;
                            @(posedge clk); #0.1;
                            pesi[11] = 0;
                            num_sent[11] = num_sent[11] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[12] < packet_count && phase != 12) begin
                        @(posedge clk); #0.1;
                        if (phase != 12 && peri[12]) begin
                            generate_packet(12, phase);
                            pesi[12] = 1;
                            @(posedge clk); #0.1;
                            pesi[12] = 0;
                            num_sent[12] = num_sent[12] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[13] < packet_count && phase != 13) begin
                        @(posedge clk); #0.1;
                        if (phase != 13 && peri[13]) begin
                            generate_packet(13, phase);
                            pesi[13] = 1;
                            @(posedge clk); #0.1;
                            pesi[13] = 0;
                            num_sent[13] = num_sent[13] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[14] < packet_count && phase != 14) begin
                        @(posedge clk); #0.1;
                        if (phase != 14 && peri[14]) begin
                            generate_packet(14, phase);
                            pesi[14] = 1;
                            @(posedge clk); #0.1;
                            pesi[14] = 0;
                            num_sent[14] = num_sent[14] + 1;
                        end
                    end
                end
                begin
                    while (num_sent[15] < packet_count && phase != 15) begin
                        @(posedge clk); #0.1;
                        if (phase != 15 && peri[15]) begin
                            generate_packet(15, phase);
                            pesi[15] = 1;
                            @(posedge clk); #0.1;
                            pesi[15] = 0;
                            num_sent[15] = num_sent[15] + 1;
                        end
                    end
                end 
            join
            status = 1;//finished
        end
    endtask

//--------------------------------------------------------------------
//open files to write
//--------------------------------------------------------------------
    integer out_file_0, out_file_1, out_file_2, out_file_3, out_file_4, out_file_5, out_file_6, out_file_7, out_file_8, out_file_9, out_file_10, out_file_11, out_file_12, out_file_13, out_file_14, out_file_15;
    integer time_file;
    integer sent_file;
    initial begin 
        out_file_0 = $fopen("gather_phase0.txt", "w");
        out_file_1 = $fopen("gather_phase1.txt", "w");
        out_file_2 = $fopen("gather_phase2.txt", "w");
        out_file_3 = $fopen("gather_phase3.txt", "w");
        out_file_4 = $fopen("gather_phase4.txt", "w");
        out_file_5 = $fopen("gather_phase5.txt", "w");
        out_file_6 = $fopen("gather_phase6.txt", "w");
        out_file_7 = $fopen("gather_phase7.txt", "w");
        out_file_8 = $fopen("gather_phase8.txt", "w");
        out_file_9 = $fopen("gather_phase9.txt", "w");
        out_file_10 = $fopen("gather_phase10.txt", "w");
        out_file_11 = $fopen("gather_phase11.txt", "w");
        out_file_12 = $fopen("gather_phase12.txt", "w");
        out_file_13 = $fopen("gather_phase13.txt", "w");
        out_file_14 = $fopen("gather_phase14.txt", "w");
        out_file_15 = $fopen("gather_phase15.txt", "w");
        time_file = $fopen("time.txt", "w");
        sent_file = $fopen("sent_file.txt", "w");
    end

//--------------------------------------------------------------------
//main function
//--------------------------------------------------------------------
    integer cycle_ptr;
    integer phase_ptr;
    integer packet_ptr;
    reg status;
    initial begin
       
        reset = 1;
        pesi = 16'd0;//16 bits
        pero = 16'b1111_1111_1111_1111;//16 bits

        #7 reset = 0;
        for (cycle_ptr = 0; cycle_ptr < NUM_OF_CYCLE; cycle_ptr = cycle_ptr + 1) begin
            for (phase_ptr = 0; phase_ptr < 16; phase_ptr = phase_ptr + 1) begin
                $fdisplay(time_file, "Phase %1d started at %1d ns", phase_ptr, $time);
                // for (packet_ptr = 0; packet_ptr < 4; packet_ptr = packet_ptr + 1) begin
                //     send_data(phase_ptr, status);
                // end
                send_data(phase_ptr, status);
                
                $fdisplay(time_file, "Phase %1d finished at %1d ns", phase_ptr, $time);
            end
        end

    end
    initial begin
        #15000;
        $fclose(out_file_0);
        $fclose(out_file_1);
        $fclose(out_file_2);
        $fclose(out_file_3);
        $fclose(out_file_4);
        $fclose(out_file_5);
        $fclose(out_file_6);
        $fclose(out_file_7);
        $fclose(out_file_8);
        $fclose(out_file_9);
        $fclose(out_file_10);
        $fclose(out_file_11);
        $fclose(out_file_12);
        $fclose(out_file_13);
        $fclose(out_file_14);
        $fclose(out_file_15);
        $fclose(time_file);
        $fclose(sent_file);
        reset = 1;
        #8;
        $finish;
    end

//--------------------------------------------------------------------
//receive data
//--------------------------------------------------------------------
    integer j;
    always @(posedge clk) begin
        for (j = 0; j < 16; j = j + 1) begin
            log_receive(j, peso[j], pedo[j]);
        end
    end
//write data to file based on node_id
    task log_receive;
        input integer node_id;
        input peso;
        input [63:0] pedo;
        integer of;
        begin
            // 映射 node_id -> out_file
            case(node_id)
                0:  of = out_file_0;
                1:  of = out_file_1;
                2:  of = out_file_2;
                3:  of = out_file_3;
                4:  of = out_file_4;
                5:  of = out_file_5;
                6:  of = out_file_6;
                7:  of = out_file_7;
                8:  of = out_file_8;
                9:  of = out_file_9;
                10: of = out_file_10;
                11: of = out_file_11;
                12: of = out_file_12;
                13: of = out_file_13;
                14: of = out_file_14;
                15: of = out_file_15;
            endcase

            if (!reset && peso) begin
                $fdisplay(of, 
                    "Node %0d | Time = %0dns | Pol = %b | dir_x = %b | dir_y = %b  | Src = %0d | Packet = %h", 
                    node_id,     $time,      pedo[63],   pedo[62],    pedo[61],     pedo[47:32],   pedo
                );
            end
        end
    endtask
endmodule





