
module data_generator #(parameter WIDTH = 45) (interface r);
    parameter FL = 2; //ideal environment, no forward delay


    integer fd;
    string line, cleaned_line;
    int status;
    logic [WIDTH-1:0] packet;

    initial begin
        fd = $fopen("./scnn_script/send_values_bin.txt", "r");
        if (fd == 0) begin
            $display("ERROR: Cannot open file.");
            $finish;
        end

        while (!$feof(fd)) begin
            line = "";
            void'($fgets(line, fd));

            if (line.len() > 0 ) begin
                cleaned_line = "";
                foreach (line[i]) begin
                  if (line[i] != " " && line[i] != "_")
                    cleaned_line = {cleaned_line, line[i]};
                end
                status = $sscanf(cleaned_line, "%b", packet);
                if (status == 1) begin
                    // $display("At time %t, send %d th\t inst %h", $time, idx, inst);
                    r.Send(packet);
                    // $display("At time %t, finish send %d th\t inst %h", $time, idx, inst);
                    #FL;
                end else begin
                    $display("WARNING: Failed to parse line: %s", line);
                end
            end
        end

        $fclose(fd);
        $display("Finished sending packet at time %t.", $time);
    end

endmodule


// module data_bucket (interface r);

//     parameter PACKET_WIDTH = 8;
//     parameter BL = 0; // ideal environment, no backward delay

//     logic [PACKET_WIDTH-1:0] ReceiveValue = 0;
    
//     logic [4:0] counter = 5'b00000;

//     integer out_fh;

//     initial begin
//         out_fh = $fopen("data_bucket_output.log", "w");
//         if (out_fh == 0)
//             $fatal("ERROR: could not open output file");
//     end

//     always begin
//         if (counter < 5'd20) begin
//             r.Receive(ReceiveValue);
//             $display("DB %m receives output data = %b @ %0t", ReceiveValue, $time);
//             $display("Timestep = %b, OutSpike = %b, PE Node = %d, Residue = %d", ReceiveValue[0], ReceiveValue[4], ReceiveValue[6:5], ReceiveValue[32:16]);
//             $fdisplay(out_fh, "DB %m receives output data = %b @ %0t", ReceiveValue, $time);
//             $fdisplay(out_fh, "Timestep = %b, OutSpike = %b, PE Node = %d, Residue = %d", ReceiveValue[0], ReceiveValue[4], ReceiveValue[6:5], ReceiveValue[32:16]);
//             #BL;
//             counter = counter + 1;
//         end else begin
//             #10;
//         end
//     end

//     final begin
//         $fclose(out_fh);
//     end
// endmodule

module data_bucket (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; //ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    always begin
        r.Receive(ReceiveValue);
        $display("DB %m receives output data = %d @ %t", ReceiveValue, $time);
        #BL;
    end

endmodule

module top_tb ();

    parameter FILTER_WIDTH = 8;
    parameter IFMAP_SIZE   = 25;
    parameter OUTPUT_WIDTH = 13;
    parameter THRESHOLD    = 64;
    parameter FL	       = 2;
    parameter BL	       = 1;
    parameter ROW          = 4;
    parameter COL          = 4;
    parameter WIDTH        = 13 + 5*FILTER_WIDTH;
    parameter Y_HOP_LOC    = 7;
    parameter X_HOP_LOC    = 4;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_in ();
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_out ();

    // Instantiate DUT
    data_generator #(.PACKET_WIDTH(3*FILTER_WIDTH+9), .FL(0)) dg (Packet_in);

    top#(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .ROW(ROW),
        .COL(COL),
        .WIDTH(WIDTH),
        .Y_HOP_LOC(Y_HOP_LOC),
        .X_HOP_LOC(X_HOP_LOC)
    ) top (
        .Packet_in(Packet_in),
        .Packet_out(Packet_out)
    );

    data_bucket #(.PACKET_WIDTH(3*FILTER_WIDTH+9), .BL(0)) db_content (Packet_out);

    initial begin
        $display("Start simulation!!!");
        #250;
        $finish;
    end

endmodule