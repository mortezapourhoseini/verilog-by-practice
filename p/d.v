module d; integer s; initial begin s = 7; $display("r=%0d", $random(s)); $display("PASS: d"); $finish; end endmodule
