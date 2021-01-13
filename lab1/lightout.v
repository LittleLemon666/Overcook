module light_DECODE(light_advance,light_practice,sel_1,sel_0 , light_out );
	input sel_1,sel_0;
	input [3:0]light_advance;
	input [3:0]light_practice;
	output [9:0] light_out;
	reg [3:0] data;
	reg [9:0] reg_out;
	
	initial
	begin
		data = 4'b1111;
		reg_out = 10'b1111111111;
	end
	
	always@({sel_1,sel_0})
	begin
		case({sel_1,sel_0})
			0: data = 4'b1111;
			2: data = light_advance;
			1: data = light_practice;
			default: data = 4'b1111;
		endcase
	end
	
	always@(data)
	begin
		case (data)
			0 : reg_out = 10'b1111111110; // 0
			1 : reg_out = 10'b1111111101; // 1
			2 : reg_out = 10'b1111111011; // 2
			3 : reg_out = 10'b1111110111; // 3
			4 : reg_out = 10'b1111101111; // 4
			5 : reg_out = 10'b1111011111; // 5
			6 : reg_out = 10'b1110111111; // 6
			7 : reg_out = 10'b1101111111; // 7
			8 : reg_out = 10'b1011111111; // 8
			9 : reg_out = 10'b0111111111; // 9
			default :
				reg_out =  10'b1111111111;
		endcase
	end
	
	assign light_out = ~reg_out;
	
endmodule