module my_pll(clk_in, clk_out,difficluty,reset,light);
	input reset, clk_in;
	input light;
	input  [1:0]difficluty;
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
		
		if(light==0)
		begin
			//clk_out <= 1 ;
			counter_max = 1;
		end
		else
		begin
				case(difficluty)
				00:
					counter_max = 1000000;
				01:
					counter_max = 1250000;
				10:
					counter_max = 1500000;
				11:
					counter_max = 1750000;
				endcase
		end	
		
		if (counter == 0)
		begin
			counter <= counter_max;
			clk_out <= ~clk_out;
		end
		else
		begin
			counter <= counter - 1;
		end
		
	end
endmodule