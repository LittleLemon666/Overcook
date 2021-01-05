module advance( input [1:0]lastdifficuty , output reg [7:0] seg7Out, out reg [3:0] lighting, output endEnable,
				input clk, input reset, input [3:0] change, input [2:0] buttom, input enable , output nextdiffucluty, output max);
	reg [9:0] counter;
	reg [1:0] state;
	reg [7:0] level;
	reg [3:0] lightsBin [6:0];
	reg [2:0] lightIndex;
	reg [1:0] difficulty ;
	parameter LIGHT = 2'b00, APPLY = 2'b01, GOOD = 2'b10, END = 2'b11;
	parameter GOODSHOW = 255;
	parameter ENDSHOW = 253;
	parameter counter_max = 1000; // 0.5s
	parameter lightMax = 7;
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			clk_out <= 0;
			counter <= counter_max;
			level <= 1;
			seg7Out <= level;
			assign endEnable = 0;
			lightIndex <= 0;
		end
		if (counter == 0) //action
		begin
			counter <= counter_max;
			clk_out <= ~clk_out;
			case(state)
				LIGHT:  //lighting
				begin
					difficulty <=lastdifficuty ;

					//改clk
					case(difficulty )
					00://
						max <=17500000; 
						lightMax<=4;
					01:
						max <=15000000; 
						lightMax<=5;
					02:
						max <=12500000; 
						lightMax<=6;
					03:				
						max <=10000000; 
						lightMax<=7;

					lightsBin[lightIndex] <= $random % 10;
					lighting <= lightsBin[lightIndex];
					lightIndex <= lightIndex + 1;
					seg7Out <= level;
					if (lightIndex == lightMax)
					begin
						lightIndex <= 0;
						state <= APPLY;
					end
				end
				
				APPLY:  //input what sw be changed
				begin
					if (change != 2'b1111)
					begin
						if (change == lightsBin[lightIndex])
						begin
							lightIndex <= lightIndex + 1;
						end
						else
						begin
							state <= END;
						end
					end
					
					if (lightIndex == lightMax)
					begin
						lightIndex <= 0;
						state <= GOOD;
					end
				end
				
				GOOD:  //show GOOD
				begin
					state <= LIGHT;
					level <= level + 1;
					seg7Out <= GOODSHOW;
					lightIndex <= 0;
					difficulty <=difficulty +1;
					nextdifficulty <=difficulty; 

				end
				
				END:  //show END and
				begin
					seg7Out <= ENDSHOW;
					assign endEnable = 1;
				end
				
				default:
					state <= 0;
			endcase
		end
		else
			counter <= counter - 1;
	end
	
endmodule