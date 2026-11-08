module top(input wire [7:0] a, input wire [7:0] b, output wire [7:0] sum, output wire cout);
  assign sum = a + b;
  assign cout = sum[8];
endmodule
