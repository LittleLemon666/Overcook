module my_pll(clk_in, clk_out,difficluty,reset,light);
	input reset, clk_in;
	input light;
	input  [2:0]difficluty;
	output reg clk_out;
	//reg clk_out;
	reg [25:0] counter;
	reg [25:0]counter_max = 5_000_000/4;
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
				000:
					begin 
						counter_max = 20_000_000/4;
						counter<=counter_max;
					end
				001:
					begin 
						counter_max = 17_500_000/4;
						counter<=counter_max;
					end
				010:
					begin
						counter_max = 15_000_000/4;
						counter<=counter_max;
					end
				011:
					begin
						counter_max = 12_500_000/4;
						counter<=counter_max;
					end
				100:
					begin
						counter_max = 1;
						counter<=counter_max;
					end
				101:
					begin
						counter_max = 50000;
						counter<=counter_max;
					end
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