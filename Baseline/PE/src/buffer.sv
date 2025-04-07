module buffer (interface left, interface right);
parameter FL = 2;
parameter BL = 1;
parameter WIDTH = 8;

logic [WIDTH-1:0] data;
  
always
begin
    left.Receive(data);
    #FL; 
    right.Send(data);
    #BL;
end
endmodule