module advance(output reg [7:0] seg7Out, output reg [3:0] lighting, output reg endEnable,
				input clk, input reset, input [3:0] change, input [2:0] buttom, input enable);
	
	reg [9:0] counter; //for divide clk
	reg [1:0] state; //state in advance.v
	reg [7:0] level; //your level now
	reg [3:0] lightsBin [6:0]; //store what LEDs light
	reg [2:0] lightIndex; //index of LEDs cache
	parameter LIGHT = 2'b00, APPLY = 2'b01, GOOD = 2'b10, END = 2'b11; //state in advance.v
	parameter GOODSHOW = 255;
	parameter ENDSHOW = 253;
	parameter counter_max = 1000; // 0.5s
	parameter lightMax = 7;
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			counter <= counter_max;
			level <= 1; //level is 1 in the beginning
			seg7Out <= level; //seg7 show level
			endEnable <= 0; //lock END.v
			lightIndex <= 0; //reset leds cache
		end
		if (counter == 0) //action
		begin
			counter <= counter_max;
			case(state)
				LIGHT:  //lighting
				begin
					lightsBin[lightIndex] <= $random % 10; //random the index of light
					lighting <= lightsBin[lightIndex]; //LEDs light the cache "lightsBin[lightIndex]"
					lightIndex <= lightIndex + 1; //LEDs cache index++
					seg7Out <= level; //show your level now
					if (lightIndex == lightMax) //after 7 of lights
					begin
						lightIndex <= 0; //from cache 0
						state <= APPLY; //start to recieve player sw
					end
				end
				
				APPLY:  //input what sw be changed
				begin
					if (change != 4'b1111) //recieve SWs is not default
					begin
						if (change == lightsBin[lightIndex])
						begin
							lightIndex <= lightIndex + 1; //correct!
						end
						else
						begin
							state <= END; //see you next time
						end
					end
					
					if (lightIndex == lightMax) //all correct!
					begin
						lightIndex <= 0; //reset leds cache
						state <= GOOD;
					end
				end
				
				GOOD:  //show GOOD
				begin
					state <= LIGHT;
					level <= level + 1; //level up
					seg7Out <= GOODSHOW; //show GOOD on seg7
					lightIndex <= 0;  //reset leds cache
				end
				
				END:  //show END and
				begin
					seg7Out <= ENDSHOW; //show END on seg7
					endEnable <= 1; //enable END.v
				end
				
				default:
					state <= 0;
			endcase
		end
		else
			counter <= counter - 1;
	end
	
endmodule