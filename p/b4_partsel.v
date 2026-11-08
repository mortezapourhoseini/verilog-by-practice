module top(input wire [31:0] w, input wire [1:0] k, output wire [7:0] y); assign y = w[8*k+7 : 8*k]; endmodule
