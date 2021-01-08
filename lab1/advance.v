module advance(output reg [7:0] seg7Out, output reg [3:0] lighting, output reg endEnable,input clk, input [3:0] change, input enable);
	
	reg [25:0] counter; //for divide clk
	reg [1:0] state; //state in advance.v
	reg [7:0] level; //your level now
	reg [3:0] lightsBin [6:0]; //store what LEDs light
	reg feedback_value; //random given
	reg [2:0] lightIndex; //index of LEDs cache
	reg [1:0] lightIndexChange;
	parameter LIGHT = 2'b00, APPLY = 2'b01, GOOD = 2'b10, END = 2'b11; //state in advance.v
	parameter GOODSHOW = 255;
	parameter ENDSHOW = 253;
	parameter counter_max = 12_500_000; // 0.5s
	parameter lightMax = 7;
	reg [2:0] iteral;
	
	initial
	begin
		lightsBin[0] <= 1;
		lightsBin[1] <= 2;
		lightsBin[2] <= 3;
		lightsBin[3] <= 4;
		lightsBin[4] <= 5;
		lightsBin[5] <= 6;
		lightsBin[6] <= 7;
	end
	
	always@(posedge clk)
	begin
		if(enable == 0)
		begin
			counter <= counter_max;
			level <= 1; //level is 1 in the beginning
			seg7Out <= level; //seg7 show level
			endEnable <= 0; //lock END.v
			lightIndex <= 0; //reset leds cache
			state <= 2'b00;
			lighting <= 4'b1111;
			iteral <= 0;
		end
		else
		begin
			if (counter == 0) //action
			begin
				counter <= counter_max;
				case(state)
					LIGHT:  //lighting
					begin
					if(lighting == 4'b1111)
					begin
						if (iteral == 0) iteral <= 1;
						else
						begin
							if (iteral == 5)
							begin
								lightIndex <= lightIndex + 1; //LEDs cache index++
								seg7Out <= level; //show your level now
								iteral <= 6;
							end
						end
					end
					else lighting <= 4'b1111;
						
					end
					GOOD:  //show GOOD
					begin
						state <= LIGHT;
						level <= level + 1; //level up
						seg7Out <= GOODSHOW; //show GOOD on seg7
						lightIndex <= 0;  //reset leds cache
						lighting <= 4'b1111;
						counter <= 50_000_000;
					end
					
					END:  //show END and
					begin
						seg7Out <= ENDSHOW; //show END on seg7
						endEnable <= 1; //enable END.v
						lighting <= 4'b1111;
					end
					
					default:
					begin
						state <= state;
					end
				endcase
			end
			else
			begin
				counter <= counter - 1;
				if (state == LIGHT)
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
						end
						
						6:
						begin
							if (lightIndex == lightMax) //after 7 of lights
							begin
								lightIndex <= 0; //from cache 0
								state <= APPLY; //start to recieve player sw
								lighting <= 4'b1111;
							end
							else iteral <= 0;
						end
					endcase
				end
			end
		end
		
		
		if (state == APPLY) //input what sw be changed
		begin
			if (change != 4'b1111) //recieve SWs is not default
			begin
				if (change == lightsBin[lightIndex])
				begin
					lightIndex <= lightIndex + 1; //correct!
					lighting <= change; //show you press
				end
				else
				begin
					lighting <= change;
					state <= END; //see you next time
					counter <= 50_000_000;
					iteral <= 7;
				end
			end
			
			if (lightIndex == lightMax) //all correct!
			begin
				lightIndex <= 0; //reset leds cache
				state <= GOOD;
				iteral <= 0;
			end
		end
		
		if (state == END && counter == 0 && iteral == 7)
		begin
			if (seg7Out == ENDSHOW) seg7Out <= level;
			else seg7Out <= ENDSHOW;
			counter <= 50_000_000;
		end
	end
	
endmodule