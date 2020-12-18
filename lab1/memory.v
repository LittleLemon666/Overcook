module memory(out, clk, reset, w_rb, addr, data_in);
	input clk, reset, w_rb;
	input [5:0] addr;
	input [12:0] data_in;
	output[12:0] out;
	reg[12:0] mem[63:0];
	parameter max = 63;
	integer i;
	
	assign out = mem[addr];
	
	always@(posedge clk)
	begin
		if(w_rb)
			mem[addr] <= data_in;
		if(reset)
		begin
			for( i = 0; i <= max; i = i + 1 )
			begin
				mem[i] <= 0;
			end
		end
	end
	
endmodule