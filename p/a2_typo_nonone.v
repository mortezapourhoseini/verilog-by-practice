module ha(input wire a, input wire b, output wire s, output wire c); assign s=a^b; assign c=a&b; endmodule
module top(input wire a, input wire b, output wire y);
  wire carry_mid;
  ha h0(.a(a), .b(b), .s(), .c(cary_mid));
  assign y = carry_mid;
endmodule
