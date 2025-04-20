// ************************************************** packet orgnization *******************************************************************************************************
//             |         HEADER          |                        |                                            3*FILTER_WIDTH                                                  |
//  Address    [0:1]        [2:3]    [4]      [5]         [6:8]    [9]         [10:11]    [12:8+3*filter_width-output_width]    [9+3*filter_width-output_width:8+3*filter_width]    
//             direction    x-hop    y-hop    timestep    000      outspike    PE node    0s                                    residue  
// *****************************************************************************************************************************************************************************

module data_generator (interface r);

    parameter WIDTH = 8;
    parameter FILTER_WIDTH = 8;
    parameter FL = 0; // ideal environment no forward delay

    logic [1:0] counter = 2'b00;
    logic timestep_counter = 1'b0;
    logic [WIDTH-1:0] SendValue = 0;
    logic [WIDTH-1:0] send_values [0:4];
    logic [FILTER_WIDTH-1:0] filter_part [0:8];
    logic ifmap_t1_part [0:8]; // 3x3 ifmap t1
    logic ifmap_t2_part [0:8]; // 3x3 ifmap t1

    assign filter_part[0] = 8'd5;
    assign filter_part[1] = 8'd5;
    assign filter_part[2] = 8'd5;
    assign filter_part[3] = 8'd5;
    assign filter_part[4] = 8'd4;
    assign filter_part[5] = 8'd3;
    assign filter_part[6] = 8'd0;
    assign filter_part[7] = 8'd2;
    assign filter_part[8] = 8'd5;

    assign ifmap_t1_part[0] = 1'b1;
    assign ifmap_t1_part[1] = 1'b1;
    assign ifmap_t1_part[2] = 1'b1;
    assign ifmap_t1_part[3] = 1'b0;
    assign ifmap_t1_part[4] = 1'b0;
    assign ifmap_t1_part[5] = 1'b0;
    assign ifmap_t1_part[6] = 1'b1;
    assign ifmap_t1_part[7] = 1'b1;
    assign ifmap_t1_part[8] = 1'b1;

    assign ifmap_t2_part[0] = 1'b0;
    assign ifmap_t2_part[1] = 1'b0;
    assign ifmap_t2_part[2] = 1'b1;
    assign ifmap_t2_part[3] = 1'b1;
    assign ifmap_t2_part[4] = 1'b1;
    assign ifmap_t2_part[5] = 1'b1;
    assign ifmap_t2_part[6] = 1'b0;
    assign ifmap_t2_part[7] = 1'b0;
    assign ifmap_t2_part[8] = 1'b0;

    initial begin 
        // SendValue = $random() % (2**WIDTH); // the range of random number is from 0 to 2^WIDTH
        send_values[0] = {filter_part[0], filter_part[1], filter_part[2], 4'b0110, 1'b0, 2'b10, 2'b11}; // filter row1
        send_values[1] = {filter_part[3], filter_part[4], filter_part[5], 4'b1010, 1'b0, 2'b10, 2'b11}; // filter row2
        send_values[2] = {filter_part[6], filter_part[7], filter_part[8], 4'b1110, 1'b0, 2'b10, 2'b11}; // filter row3
        send_values[3] = {ifmap_t1_part[6], ifmap_t1_part[7], ifmap_t1_part[8], ifmap_t1_part[3], ifmap_t1_part[4], ifmap_t1_part[5], ifmap_t1_part[0], ifmap_t1_part[1], ifmap_t1_part[2], 4'b0000, 1'b0, 2'b10, 2'b11}; // ifmap t1
        send_values[4] = {ifmap_t2_part[6], ifmap_t2_part[7], ifmap_t2_part[8], ifmap_t2_part[3], ifmap_t2_part[4], ifmap_t2_part[5], ifmap_t2_part[0], ifmap_t2_part[1], ifmap_t2_part[2], 4'b0001, 1'b0, 2'b10, 2'b11}; // ifmap t2
    end

    always begin
        if (counter == 2'b00) begin
            SendValue = send_values[0];     // Send filter row 1
        end else if(counter == 2'b01) begin
            SendValue = send_values[1];     // Send filter row 2
        end else if(counter == 2'b10) begin
            SendValue = send_values[2];     // Send filter row 3
        end else if(counter == 2'b11 && timestep_counter == 1'b0) begin
            SendValue = send_values[3];     // Send ifmap
        end else if(counter == 2'b11 && timestep_counter == 1'b1) begin
            SendValue = send_values[4];     // Send ifmap
        end else begin
            SendValue = 0;
        end
        #FL;
        
        r.Send(SendValue);
        if (counter == 2'b00) begin
            $display("DG %m sends filter row 1 data = %b @ %t", SendValue, $time);
        end else if(counter == 2'b01) begin
            $display("DG %m sends filter row 2 data = %h @ %t", SendValue, $time);
        end else if(counter == 2'b10) begin
            $display("DG %m sends filter row 3 data = %h @ %t", SendValue, $time);
        end else if(counter == 2'b11) begin
            $display("DG %m sends ifmap data = %b @ %t", SendValue, $time);
        end else begin
            $display("Error!!!", SendValue, $time);
        end

        if (counter < 2'b11) begin
            counter = counter + 1;
        end else begin
            counter = 2'b11;
            timestep_counter = ~timestep_counter;
        end
    end

endmodule

module data_bucket (interface r);
    parameter WIDTH = 8;
    parameter BL    = 0; //ideal environment no backward delay

    logic [WIDTH-1:0] ReceiveValue = 0;

    always begin
        r.Receive(ReceiveValue);
        $display("DB %m receives output data = %b @ %t", ReceiveValue, $time);
        #BL;
    end

endmodule


module top_tb ();

    parameter FILTER_WIDTH = 8;
    parameter IFMAP_SIZE   = 9;
    parameter OUTPUT_WIDTH = 12;
    parameter THRESHOLD = 64;
    parameter FL = 2;
    parameter BL = 1;
    parameter ROW = 2;
    parameter COL = 3;
    
    // Instantiate interfaces  
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_in ();
    Channel #(.WIDTH(3*FILTER_WIDTH+9), .hsProtocol(P4PhaseBD)) Packet_out ();

    // Instantiate DUT
    data_generator #(.WIDTH(3*FILTER_WIDTH+9), .FL(0), .FILTER_WIDTH(FILTER_WIDTH)) dg_content (Packet_in);

    top #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .IFMAP_SIZE(IFMAP_SIZE),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .THRESHOLD(64),
        .FL(FL),
        .BL(BL),
        .ROW(ROW),
        .COL(COL)
    ) top (
        .Packet_in(Packet_in), 
        .Packet_out(Packet_out)
    );

    data_bucket #(.WIDTH(3*FILTER_WIDTH+9), .BL(0)) db_content (Packet_out);

    initial begin
        $display("Start simulation!!!");
        #120
        $finish;
    end

endmodule