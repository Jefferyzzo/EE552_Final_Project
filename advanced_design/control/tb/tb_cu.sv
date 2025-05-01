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

localparam RUNTIME = 500;
module tb_cu #(
    parameter FL	= 2 ,
    parameter BL	= 2
) (

); 


    // Channels between input packets and output arbiter
    Channel #(.WIDTH(45),.hsProtocol(P4PhaseBD)) I ();
    Channel #(.WIDTH(53),.hsProtocol(P4PhaseBD)) O ();

    control_unit #(
        .FL(FL), .BL(BL)
    ) cu (
        .I(I),
        .O(O)
    ); 

    data_generator dg(.r(I));
    data_bucket db(.r(O));


    initial begin
        #RUNTIME;
        $finish;

    end


endmodule




//data_generator module
module data_generator #(parameter WIDTH = 45) (interface r);
    parameter FL = 4; //ideal environment, no forward delay


    integer fd;
    string line, cleaned_line;
    integer idx = 0;
    int status;
    logic [WIDTH-1:0] inst;

    initial begin
        fd = $fopen("./testcase/top_inst.txt", "r");
        if (fd == 0) begin
            $display("ERROR: Cannot open file.");
            $finish;
        end

        while (!$feof(fd)) begin
            line = "";
            void'($fgets(line, fd));

            if (line.len() > 0 && line.substr(0,1) != "//") begin
                cleaned_line = "";
                foreach (line[i]) begin
                  if (line[i] != " " && line[i] != "_")
                    cleaned_line = {cleaned_line, line[i]};
                end
                status = $sscanf(cleaned_line, "%b", inst);
                if (status == 1) begin
                    $display("At time %t, send %d th\t inst %s", $time, idx, format_bin45(inst));
                    r.Send(inst);
                    #FL;
                    idx++;
                end else begin
                    $display("WARNING: Failed to parse line: %s", line);
                end
            end
        end

        $fclose(fd);
        $display("Finished sending instructions at time %t.", $time);
    end

    function string format_bin45(input logic [44:0] data);
        string s;
        integer i;
        begin
            s = "";
            for (i = 44; i >= 0; i--) begin
                s = {s, data[i] ? "1" : "0"};
                if (i % 4 == 0 && i != 0) s = {s, "_"};  // 每 4 位插入分隔符（除了最后一组）
            end
            return s;
        end
    endfunction

endmodule

//data_bucket module
module data_bucket #(parameter WIDTH = 53) (interface r);

    parameter BL = 1; //ideal environment no backward delay

    //Variables added for performance measurements
    real cycleCounter=0;  //# of cycles = Total number of times a value is received
    real timeOfReceive=0; //Simulation time of the latest Receive 
    real cycleTime=0;     // time difference between the last two receives
    real averageThroughput=0;
    real averageCycleTime=0;
    real sumOfCycleTimes=0;
    integer j;




    logic [WIDTH-1:0] packet;
    logic [39:0] data;
    logic [2:0] filter_row;
    logic ifmap_filter;
    logic timestep;
    logic [2:0] y_hop;
    logic [2:0] x_hop;
    logic [1:0] direction;
    integer file, file_time;

    initial begin
        // 打开文件
        file = $fopen("./result/cu_top.txt", "w");
        file_time = $fopen("./result/cu_top_time.txt", "w");
        if (file == 0) begin
        $display("Error opening file!");
        $finish;
        end

        // 写入表头
        $fdisplay(file, "Data\t\t\t\t\t\t\t\t\t\t\t\tfilter_row\tifmap0_filter1\ttimestep\ty_hop\tx_hop\tdirection");
        $fdisplay(file_time, 
    "Time        Data                                              filter_row  ifmap0_filter1  timestep  y_hop   x_hop direction");
        #RUNTIME;
        $fclose(file);
        $fclose(file_time);
        $display("Packet written to ./result/cu_top.txt");
    end

    always
    begin
        $timeformat(-9, 2, " ns", 10);  // Scale to ns, 2 decimal places  
    //     $display("%m starts its main loop at %t", $time);
        //Save the simulation time when Receive starts   
        timeOfReceive = $time;  
        r.Receive(packet); 

        data            = packet[WIDTH-1: WIDTH-40];
        filter_row      = packet[12:10];
        ifmap_filter    = packet[9];
        timestep        = packet[8];
        y_hop           = packet[7:5];
        x_hop           = packet[4:2];
        direction       = packet[1:0];

        // 写入数据
        $fdisplay(file, "%s\t%b\t\t\t%b\t\t\t\t%b\t\t\t%b\t\t%b\t\t%b",
                format_bin40(data), filter_row, ifmap_filter,
                timestep, y_hop, x_hop, direction);
        $fdisplay(file_time, "%t\t%s\t%b\t\t\t\t\t%b\t\t\t\t\t\t\t\t%b\t\t\t\t\t%b\t\t\t%b\t\t%b",
                $time, format_bin40(data), filter_row, ifmap_filter,
                timestep, y_hop, x_hop, direction);
        #BL;
    //     cycleCounter += 1;		
    //     //Measuring throughput: calculate the number of Receives per unit of time  
    //     //CycleTime stores the time it takes from the begining to the end of the always block
    //     cycleTime = $time - timeOfReceive; // the difference of time between now and the last receive
    //     averageThroughput = cycleCounter/$time; 
    //     sumOfCycleTimes += cycleTime;
    //     averageCycleTime = sumOfCycleTimes / cycleCounter;
    //     $display("Execution cycle= %d, Cycle Time= %d, 
    //         Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
    //         averageCycleTime, averageThroughput);




    end

    function string format_bin40(input logic [39:0] data);
        string s;
        integer i;
        begin
            s = "";
            for (i = 39; i >= 0; i--) begin
                s = {s, data[i] ? "1" : "0"};
                if (i % 4 == 0 && i != 0) s = {s, "_"};
            end
            return s;
        end
    endfunction
endmodule



