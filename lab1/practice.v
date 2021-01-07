module practice( input [1:0]lastdifficuty , output reg [7:0] seg7Out, output reg [3:0] lighting, output reg endEnable,	input clk, input [3:0] change, input enable , output reg[1:0]  nextdifficulty);
	reg [9:0] counter;
	reg [2:0] state;
	reg [7:0] level;
	reg [3:0] r_reg;
	reg [3:0] lightsBin [6:0];
	reg [2:0] lightIndex;
	reg [1:0] difficulty ;
	wire [3:0] r_next; //random given
	wire feedback_value;
	
	parameter LIGHT = 3'b000, APPLY = 3'b001, GOOD = 3'b010, END = 3'b011 , BURN = 3'b100;
	parameter GOODSHOW = 255;
	parameter ENDSHOW = 253;
	parameter lightMax = 7;
	assign feedback_value = r_reg[3] ^ r_reg[2] ^ r_reg[0]; //for random
	assign r_next = {feedback_value, r_reg[3:1]}; //for random
	
	always@(posedge clk)
	begin
	//reset
		if(enable == 1'b0)
		begin
			level <= 1;
			seg7Out <= level;
			endEnable <= 0;
			lightIndex <= 0;
		end
		else
			begin
				case(state)
					LIGHT:  //lighting
					begin
						difficulty <=lastdifficuty ;
						r_reg <= r_next; //random the index of light
						lightsBin[lightIndex] <= r_reg;
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
						if (change != 4'b1111)
						begin
							if (change == lightsBin[lightIndex])					
								begin
									lightIndex <= lightIndex + 1;
								end
							else
								state<=BURN;
								
							if(level ==10)
							begin
								state <= END;
							end
						end
						else
						begin
							state<=state;
						end
						
						if (lightIndex == lightMax)
						begin
							lightIndex <= 0;
							state <= GOOD;
						end
						else
						begin
							state<=state;
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
						endEnable <= 1;
					end
					
					BURN:
					begin
						state <= LIGHT;
						seg7Out <= ENDSHOW;
						difficulty <=difficulty -1;
						nextdifficulty <=difficulty; 
					end
					
					default:
						state <= 0;
				endcase
			end
			//else
			//	counter <= counter - 1;
		end
	
endmodule