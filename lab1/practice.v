module practice(reset,clk,level,good,difficulty,answer,SW);
	input reset,clk;
	input [3:0] level;
	input reg [3:0]good;
	input reg[9:0] SW;
	reg [1:0]difficulty;// 00 : 0.8  01 : 0.7  02 : 0.6  03 : 0.5 
	output reg [3:0] answer;	
	always @(level)
	begin
		case (level):
			9:
				remember(reset, good,clk,difficulty,SW);
				break;
			default:
				remember(reset, good,clk,difficulty,SW);
				level++;
			
		endcase
	end
endmodule
