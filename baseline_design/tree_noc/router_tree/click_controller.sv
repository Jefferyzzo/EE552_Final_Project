`timescale 1ns/1ns

module click_controller #(
    parameter WIDTH = 4, 
    parameter DELAY = 2) (
    input                   lreq,// Request from previous stage
    output  logic            rreq,// Request to next stage
    input                   rack,// Acknowledgment from next stag
    output  logic             lack,// Acknowledgment to previous stage
    input       [WIDTH-1:0] ldata,
    output  logic [WIDTH-1:0] rdata);

    reg     clk;  // clk for the latch
    reg     rreq_internal; // phase register

    always @(*) begin  // C-element for clk
        if(lreq && !rreq) clk = 1'b1;
        else if(!lreq && rreq && rack) clk = 1'b0;
    end

    always @(*) begin  // C-element for rreq_internal
        if(clk && !rack) rreq_internal = 1'b1;
        else if(!clk) rreq_internal = 1'b0;
    end

    always @(*) begin  // latch for data
        if(clk) begin
            rdata = ldata;
        end
    end

    // delay element for FL
    delay_element #(.DELAY(DELAY)) dly1(
                .din(rreq_internal),
                .dout(rreq)
    );

    // delay element for BL
    delay_element #(.DELAY(DELAY)) dly2(
                .din(clk),
                .dout(lack)
    );

    // intialize output handshake signals
    initial begin
        // rreq = 0;
        clk = 0;
        rreq = 0;
    end

endmodule