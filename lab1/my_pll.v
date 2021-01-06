module my_pll(clk_in, clk_out,max,reset);
	input reset, clk_in;
	input  [1:0]max;
	output reg clk_out;
	//reg clk_out;
	reg [24:0] counter;
	reg [24:0]counter_max = 1000000;
	always@ (posedge clk_in)
	begin
		
		if(reset)
		begin
			clk_out <= 0;
			counter <= counter_max;
		end
		case(max)
		
		00:
			counter_max = 1000000;
		01:
			counter_max = 1250000;
		10:
			counter_max = 1500000;
		11:
			counter_max = 1750000;
		endcase
		if (counter == 0)
		begin
			counter <= counter_max;
			clk_out <= ~clk_out;
		end
		else
			counter <= counter - 1;
	end
endmodule