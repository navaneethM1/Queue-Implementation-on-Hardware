module tb;
	reg clk, reset;
	reg [3:0] din;
	reg rw;
	wire [3:0] dout;
	wire empty, full;
	initial begin $dumpfile("test.vcd"); $dumpvars(0,tb); end

	initial begin reset = 1'b1; #5 reset = 1'b0; end
	initial clk = 1'b0; always #5 clk =~ clk;
	queue q0(clk, reset, rw, din, empty, full, dout);
	initial begin
		 rw = 0;
		#10 rw = 1; din = 4'b1010;
		#10 rw = 1; din = 4'b1100;
		#10 rw = 0;
		#10 rw = 0;
		#15 $finish;
	end
endmodule
