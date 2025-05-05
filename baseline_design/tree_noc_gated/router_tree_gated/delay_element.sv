`timescale 1ns/1ns

module delay_element #(
    parameter DELAY = 1) (
    input           din,
    output  wire    dout
);
    assign #DELAY dout = din;
    

endmodule
