module dff_fu( in, out , clk);

	input [9:0]in;
	input clk;
	output reg [9:0]out;

	
	always@(posedge clk)
	begin
		out <= in;
	end
	
endmodule