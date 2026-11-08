module ha(input wire a, input wire b, output wire s, output wire c); assign s=a^b; assign c=a&b; endmodule
module top(input wire a, input wire b, output wire y);
  wire [3:0] s; wire c;
  ha h0(.a(a), .b(b), .s(s), .c(c));
  assign y = s[0];
endmodule
