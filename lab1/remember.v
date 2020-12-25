module remember(reset, good,clk,difficulty,SW);
	input reg [3:0] good;
	input clk;
	input reset;
	input reg [9:0]SW;
	input reg difficulty;
	output reg [7:0] seg7Decode;
	reg [31;0]Seg;
	always @(difficulty)
	begin
		case (difficulty)
			00:
			//改難度
				max <= 250000;
				my_pll(clk_in, clk_out,max,reset);
				//rand燈亮
				for(int i=0;i<3;i++)
				{
					int a = $random%10;
					Bin2Dec(a,Seg);
				} 
			01:
			
			10:
			
			11:
			default :
				
		endcase
	end
endmodule
