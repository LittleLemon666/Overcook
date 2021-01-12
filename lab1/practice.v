module practice( input [2:0]lastdifficuty , output reg [7:0] seg7Out, output reg [3:0] lighting, output reg endEnable,	input clk, input [3:0] change, input enable , output reg[2:0]  nextdifficulty);
	reg [9:0] counter;
	reg [2:0] state;
	reg [7:0] level;
	reg [3:0] r_reg;
	reg [3:0] lightsBin [6:0];
	reg [2:0] lightIndex;
	reg [2:0] difficulty ;
	reg [3:0] lastchange;
	reg feedback_value;
	reg [2:0] iteral;
	reg [3:0] total;
	reg [3:0]lightMax;
	reg in;
	parameter LIGHT = 3'b000, APPLY = 3'b001, GOOD = 3'b010, END = 3'b011 , BURN = 3'b100;
	parameter GOODSHOW = 255;
	parameter BURNSHOW = 254;
	parameter ENDSHOW = 253;
	//parameter lightMax = 7;
	//assign feedback_value = r_reg[3] ^ r_reg[2] ^ r_reg[0]; //for random
	initial
		begin
			lightsBin[0] <= 1;
			lightsBin[1] <= 2;
			lightsBin[2] <= 3;
			lightsBin[3] <= 4;
			lightsBin[4] <= 5;
			lightsBin[5] <= 6;
			lightsBin[6] <= 7;
			lastchange<=15;
			total<=0;
			in <= 1;
			state<=0;
		end
	always@(change)
		begin
			if(lastchange!=change&&change!=15)	
			begin
				lastchange<=change;
			end
			 if(in==1)
				begin
				lastchange <=15;
				
				end
		end
	always@(posedge clk)
	begin
	//reset
		if(enable == 0)
			begin
				total<=0;
				in <= 1;
				lighting<=1;
				difficulty <=1; 
				nextdifficulty<=1;
				level <= 1;
				seg7Out <= level;
				endEnable <= 0;
				lightIndex <= 0;
				state <= 0;
				lighting <= 4'b1111;
				iteral <= 0;
				lightMax<= 5;
			end
		else
			begin
				case(state)
					LIGHT:  //lighting
					begin
					//difficulty<=lastdifficuty;
						if(lastdifficuty!=4)//==0 || difficulty==1 || difficulty==2 || difficulty==3||difficulty==5)
							begin
								
								if (iteral == 0) 
								begin 
									iteral <= 1;
									nextdifficulty <=4;
								end
								else
									begin
										if (iteral == 5)
										begin
											lightIndex <= lightIndex + 1; //LEDs cache index++
											//lighting
											seg7Out <= level; //show your level now
											iteral <= 6;
											nextdifficulty <=4;
										end
									end
							end
						else
						begin
							case (iteral)
								1:
								begin
									feedback_value <= lightsBin[lightIndex][3] ^ lightsBin[lightIndex][2] ^ lightsBin[lightIndex][0]; //for random
									iteral <= 2;
								end
								
								2:
								begin
									lightsBin[lightIndex] <= {feedback_value, lightsBin[(lightIndex + 6) % 7][3:1]}; //for random
									iteral <= 3;
								end
								
								3:
								begin
									lightsBin[lightIndex] <= (lightsBin[lightIndex] * 2) % 10;
									iteral <= 4;
								end
								
								4:
								begin
									lighting <= lightsBin[lightIndex]; //LEDs light the cache "lightsBin[lightIndex]"
									iteral <= 5;
									nextdifficulty <= 5 ;//改速度
								end
								
								6:
								begin
									if (lightIndex == lightMax) //after 7 of lights
										begin
											iteral <= 0;
											lightIndex <= 0; //from cache 0
											state <= APPLY; //start to recieve player sw
											lighting <= 4'b1111;
											nextdifficulty <= 5;
											total = total+1;
										end
									else
										begin
											iteral <= 0;
											lighting <= 15;
											nextdifficulty <=0;
										end
								end
								
							endcase
						end

						
	
					end	
					GOOD:  //show GOOD
					begin
						state <= LIGHT;
						level <= level + 1;
						seg7Out <= GOODSHOW;
						lightIndex <= 0;
						//difficulty <= lastdifficuty;
						if(lightMax<7)
							begin
								difficulty <=difficulty +1;
								
								lightMax<=lightMax+1;
							end
						else
							difficulty<=difficulty;
							
							
							nextdifficulty <=difficulty; 
						if (total == 11)
						begin
							lightIndex <= 0;
							state <= END;
						end
					end
					
					END:  //show END and
					begin		
						seg7Out <= ENDSHOW;
						endEnable <= 1;
						lighting <= 4'b1111;
					end
					
					BURN:
					begin
						if(total ==11)
							begin
								state <= END;
							end
						else
							begin
							
								//difficulty <= lastdifficuty;
								state <= LIGHT;
								lightIndex<=0;
								seg7Out <= BURNSHOW;
								if(lightMax>4)
									begin 
										difficulty <=difficulty -1;
										lightMax<=lightMax-1;
										 
									end
								else
									difficulty<=difficulty;
									
									nextdifficulty <=difficulty;
							end
						
					end
					
					APPLY:
						begin
						lighting <= lastchange;
						in <=0;
							if (lastchange != 15) //recieve SWs is not default
								begin
								//change<=15;
								in <= 1;
									if (lastchange == lightsBin[lightIndex])
										begin
											lightIndex <= lightIndex + 1; //correct!
											lighting <= lastchange;
											//lastchange<=15;
										end
									else
										begin
											lighting <= lastchange;
											//iteral <= 0;
											state <= BURN; 
										end
								end
						
							if (lightIndex == lightMax) //all correct!
								begin
									//lighting <= 7;
									lightIndex <= 0; //reset leds cache
									state <= GOOD;
									//iteral <= 0;
								end
								
							end
						
					default:
						state <= state;
				endcase
			end
			
		
	end
endmodule