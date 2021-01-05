module remember(reset, good,clk,difficulty,SW,memory,preSW);
	input reg [3:0] good;
	input clk;
	input reset;
	//input reg [9:0]SW;
	//input reg [9:0] preSW;
	input reg [1:0]difficulty;
	input reg [4:0] memory[6:0];
	input reg change;
	output reg [7:0] seg7Decode;
	output reg nextSW;
	output [4:0]light;
	reg [31;0]Seg;
	int i=0;
	output success;
	
	
	always @(reset)
	begin 
		case(reset)
		0:
		
		1:
		
	end
	
	
	
	always @(memory)
	begin
		case (memory[change])
			15:
				
			default:
				if(i>=difficulty+3)
				{	
					good=good + 1;
				}
				else if(memory[change]!=i)
				{
					i <= 0;
					
				}
				else
				{
					i = i + 1;
				}
		
	end
	//level 255 good
	
	always @(difficulty)
	begin
		SW<=nextSW;
		case (difficulty)
			00:
			//改難度
				max <= 250000;
				my_pll(clk_in, clk_out,max,reset);
				//rand燈亮
				for(int count=0;count<3;count++)
				{
					int light = $random%10;
					//Bin2Dec(a,Seg);
					//亮燈
					memory[light] = count;
				} 
			01:
			
			10:
			
			11:
			default :
				
		endcase
	end
endmodule
