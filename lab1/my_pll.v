module my_pll(clk_in, clk_out,reset);
	input reset, clk_in;
	output clk_out;
	reg clk_out;
	reg [24:0] counter;
	parameter counter_max = 250_000;

	always@ (posedge clk_in)
	begin
		if(reset)
		begin
			clk_out <= 0;
			counter <= counter_max;
		end
		if (counter == 0)
		begin
			counter <= counter_max;
			clk_out <= ~clk_out;
		end
		else
			counter <= counter - 1;
	end
endmodule