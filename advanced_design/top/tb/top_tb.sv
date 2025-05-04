
module data_generator (interface r);

    parameter PACKET_WIDTH = 33;
    parameter FL = 0; // ideal environment no forward delay

    logic [PACKET_WIDTH-1:0] SendValue;
    logic [PACKET_WIDTH-1:0] Packet[];  // dynamic array

    initial begin
        integer file, status;
        string line;
        logic [PACKET_WIDTH-1:0] temp;

        file = $fopen("./scnn_script/send_values_bin.txt", "r");

        if (!file) begin
            $display("ERROR: Could not open send_values_bin.txt");
            $finish;
        end

        // read line by line until EOF
        while (!$feof(file)) begin
            status = $fscanf(file, "%b\n", temp);
            if (status == 1) begin
                Packet.push_back(temp);
            end
        end

        $fclose(file);

        // send each packet
        foreach (Packet[i]) begin
            SendValue = Packet[i];
            #FL;
            r.Send(SendValue);
            $display("DG %m sends data = %b @ %t", SendValue, $time);
        end

        $display("DG %m finished sending all packets.");
        #10;
        $finish;
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