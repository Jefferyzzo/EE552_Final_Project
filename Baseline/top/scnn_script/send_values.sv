send_values[0] = {8'd1,8'd0,8'd1,4'b0110,1'b0,2'b10,2'b11} // filter row 1
send_values[1] = {8'd3,8'd4,8'd5,4'b1010,1'b0,2'b10,2'b11} // filter row 2
send_values[2] = {8'd3,8'd0,8'd3,4'b1110,1'b0,2'b10,2'b11} // filter row 3
send_values[3] = {1'b1,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,4'b0000,1'b0,2'b10,2'b11} // ifmap t1
send_values[4] = {1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,4'b0001,1'b0,2'b10,2'b11} // ifmap t2
