set +e
cd p
iverilog -g2001 -Wall -o rom.vvp rom_squares.v tb_rom_squares.v
mkdir -p sub; cd sub; vvp -n ../rom.vvp | head -5; cd ..
cat > m.v <<'X'
module t; reg [7:0] mem [0:15]; reg [3:0] addr; integer i;
initial begin for (i=0;i<16;i=i+1) mem[i]=i; addr=15; $display("mem[addr+1]=%h", mem[addr+1]); $dumpfile("m.vcd"); $dumpvars(0,t); #1 addr=1; #1 $finish; end endmodule
X
iverilog -g2001 -Wall -o m.vvp m.v && vvp -n m.vvp; grep -c "mem" m.vcd; grep '\$var' m.vcd
