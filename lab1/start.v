module start(sw_out, advance, particle,reset, sw_in, in_advance, in_particle,in_reset, clk, data);
	input in_advance, in_particle,in_reset, clk;
	input [9:0] sw_in;
	output advance, particle,reset;
	output[3:0] sw_out;
	output[31:0] data;
	parameter counter_max = 5_000_000;
	reg [31:0] seg;
	reg [24:0] counter;
	reg [3:0] change;
	reg [9:0] compare;
	
	initial
	begin
		seg = 32'b00000000000000000000000000000000;
		change = 4'b1111;
		compare = sw_in;
	end
	
	assign sw_out = change;
	assign data = seg;
	button_debouncer btn_advance(clk,1,~in_advance,advance);
	button_debouncer btn_particle(clk,1,~in_particle,particle);
	button_debouncer btn_reset(clk,1,~in_reset,res);
	
	always@ (sw_in)
	begin
		if( compare != sw_in )
		begin
			compare = sw_in;
			if(compare[0]!=sw_in[0])
			begin 
				change = 4'b0000;
			end
			else if(compare[1]!=sw_in[1])
			begin 
				change = 4'b0001;
			end
			else if(compare[2]!=sw_in[2])
			begin 
				change = 4'b0010;
			end
			else if(compare[3]!=sw_in[3])
			begin 
				change = 4'b0011;
			end
			else if(compare[4]!=sw_in[4])
			begin 
				change = 4'b0100;
			end
			else if(compare[5]!=sw_in[5])
			begin 
				change = 4'b0101;
			end
			else if(compare[6]!=sw_in[6])
			begin 
				change = 4'b0110;
			end
			else if(compare[7]!=sw_in[7])
			begin 
				change = 4'b0111;
			end
			else if(compare[8]!=sw_in[8])
			begin 
				change = 4'b1000;
			end
			else if(compare[9]!=sw_in[9])
			begin 
				change = 4'b1001;
			end
		end
	end
	


	always@ (posedge clk)
	begin
		if (counter == 0)
		begin
			counter <= counter_max;
			seg <= ~seg;
		end
		else
			counter <= counter - 1;
	end
	
endmodule