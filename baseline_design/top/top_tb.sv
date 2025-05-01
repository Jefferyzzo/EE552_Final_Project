module data_generator (interface r);

    parameter PACKET_WIDTH = 33;
    parameter FL = 0; // ideal environment no forward delay

    logic [PACKET_WIDTH-1:0] SendValue = 0;
    logic [PACKET_WIDTH-1:0] Packet [0:19];

    logic [4:0] counter = 5'b00000;

    initial begin
        integer file, status0, i;

        file = $fopen("./scnn_script/send_values_bin.txt", "r");

        if (!file) begin
            $display("ERROR: Could not open send_values_bin.txt");
            $finish;
        end

        for (i = 0; i < 20; i = i + 1) begin
            status0 = $fscanf(file, "%b\n", Packet[i]);
        end

        $fclose(file);
    end

    always begin 
        SendValue = Packet[counter]; 
        #FL;   

        if (counter < 5'd20) begin
            r.Send(SendValue);
            $display("DG %m sends data = %b @ %t", SendValue, $time);
            counter = counter + 1;
        end else begin
            #10;
        end
    end

endmodule

module data_bucket (interface r);

    parameter PACKET_WIDTH = 8;
    parameter BL = 0; // ideal environment, no backward delay

    logic [PACKET_WIDTH-1:0] ReceiveValue = 0;
    
    logic [4:0] counter = 5'b00000;

    integer out_fh;

    initial begin
        out_fh = $fopen("data_bucket_output.log", "w");
        if (out_fh == 0)
            $fatal("ERROR: could not open output file");
    end

    always begin
        if (counter < 5'd20) begin
            r.Receive(ReceiveValue);
            $display("DB %m receives output data = %b @ %0t", ReceiveValue, $time);
            $display("Timestep = %b, OutSpike = %b, PE Node = %d, Residue = %d", ReceiveValue[0], ReceiveValue[4], ReceiveValue[6:5], ReceiveValue[32:16]);
            $fdisplay(out_fh, "DB %m receives output data = %b @ %0t", ReceiveValue, $time);
            $fdisplay(out_fh, "Timestep = %b, OutSpike = %b, PE Node = %d, Residue = %d", ReceiveValue[0], ReceiveValue[4], ReceiveValue[6:5], ReceiveValue[32:16]);
            #BL;
            counter = counter + 1;
        end else begin
            #10;
        end
    end

    final begin
        $fclose(out_fh);
    end
endmodule


module top_tb ();

    parameter FILTER_WIDTH = 8;
    parameter IFMAP_SIZE   = 9;
    parameter OUTPUT_WIDTH = 12;
    parameter THRESHOLD    = 16;
    parameter FL           = 2;
    parameter BL           = 1;
    parameter ROW          = 2;
    parameter COL          = 3;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_in ();
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_out ();

    // Instantiate DUT
    data_generator #(.PACKET_WIDTH(3*FILTER_WIDTH+9), .FL(0)) dg (Packet_in);

    top #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(THRESHOLD),
        .FL(FL),
        .BL(BL),
        .ROW(ROW),
        .COL(COL)
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