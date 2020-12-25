module advance(output [7:0] score, input clk, input [9:0] sw, input [2:0] buttom, input enable);
	
	reg [7:0] level;
	
	reg [9:0] counter;
	parameter counter_max = 1000;
	
	always@(posedge clk)
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