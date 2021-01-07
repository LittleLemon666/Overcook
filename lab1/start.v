module start(sw_out, advance, particle,reset, sw_in, in_advance, in_particle,in_reset, clk, data);
	input in_advance, in_particle,in_reset, clk;
	input [9:0] sw_in;
	output reg advance, particle,reset;
	output wire[3:0] sw_out;
	output[31:0] data;
	parameter counter_max = 5_000_000;
	reg [31:0] seg;
	reg [24:0] counter;
	reg  [2:0] previours_buttom;
	wire [9:0] compare;
	wire [2:0] buttom_reg;
	wire [9:0] switch_reg;
	
	dff_fu D1(switch_reg,compare,clk);
	compare C1(switch_reg,compare,sw_out,clk,reset,advance,particle);
	
	button_debouncer btn_advance(clk,1,~in_advance,buttom_reg[0]);
	button_debouncer btn_particle(clk,1,~in_particle,buttom_reg[1]);
	button_debouncer btn_reset(clk,1,~in_reset,buttom_reg[2]);
	
	button_debouncer sw_in_0(clk,1,sw_in[0],switch_reg[0]);
	button_debouncer sw_in_1(clk,1,sw_in[1],switch_reg[1]);
	button_debouncer sw_in_2(clk,1,sw_in[2],switch_reg[2]);
	button_debouncer sw_in_3(clk,1,sw_in[3],switch_reg[3]);
	button_debouncer sw_in_4(clk,1,sw_in[4],switch_reg[4]);
	button_debouncer sw_in_5(clk,1,sw_in[5],switch_reg[5]);
	button_debouncer sw_in_6(clk,1,sw_in[6],switch_reg[6]);
	button_debouncer sw_in_7(clk,1,sw_in[7],switch_reg[7]);
	button_debouncer sw_in_8(clk,1,sw_in[8],switch_reg[8]);
	button_debouncer sw_in_9(clk,1,sw_in[9],switch_reg[9]);
	
	initial
	begin
		seg = 32'b00000000000000000000010001010111;
		previours_buttom = 3'b000;
		{particle,advance,reset} = 3'b000;
	end
	
	assign data = seg;
	
	
	always@ (buttom_reg)
	begin
	if(buttom_reg[2] == 1'b1)
	begin
		previours_buttom = 3'b000;
	end
	else
	begin
		if(buttom_reg[1] == 1'b1 && previours_buttom != 3'b010 )
		begin
			previours_buttom = 3'b100;
		end
		else if(buttom_reg[0] == 1'b1 && previours_buttom != 3'b100 )
		begin
			previours_buttom = 3'b010;
		end
		else
		begin
			previours_buttom = previours_buttom;
		end
	end
	
	{particle,advance,reset} = previours_buttom;
	
	end
	
	
	always@ (posedge clk)
	begin
		if (counter == 0)
		begin
			counter = counter_max;
			if( seg != 32'b00000000000000000010001010111000 )
			begin
				seg = seg + 32'b00000000000000000000010001010111;
			end
			else
			begin
				seg = 32'b00000000000000000000010001010111;
			end
		end
		else
			counter = counter - 1;
		
	end
	
endmodule