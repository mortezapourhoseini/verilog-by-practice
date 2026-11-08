module a; initial begin $display("FAIL: a"); $fatal(1, "boom"); end endmodule
