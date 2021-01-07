module advance(output reg [7:0] seg7Out, output reg [3:0] lighting, output reg endEnable,input clk, input [3:0] change, input enable);
	
	reg [9:0] counter; //for divide clk
	reg [1:0] state; //state in advance.v
	reg [7:0] level; //your level now
	reg [3:0] lightsBin [6:0]; //store what LEDs light
	reg [3:0] r_reg; //random reg
	wire [3:0] r_next; //random given
	wire feedback_value;
	reg [2:0] lightIndex; //index of LEDs cache
	parameter LIGHT = 2'b00, APPLY = 2'b01, GOOD = 2'b10, END = 2'b11; //state in advance.v
	parameter GOODSHOW = 255;
	parameter ENDSHOW = 253;
	parameter counter_max = 10000000; // 0.5s
	parameter lightMax = 7;
	
	// rand_num_generator
	// Author : Meher Krishna Patel
	// N = 3
	// Feedback polynomial : x^3 + x^2 + 1
	// total sequences (maximum) : 2^3 - 1 = 7
	assign feedback_value = r_reg[3] ^ r_reg[2] ^ r_reg[0]; //for random
	assign r_next = {feedback_value, r_reg[3:1]}; //for random
	
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
		end
		else
		begin
			if (counter == 0) //action
			begin
				counter <= counter_max;
				case(state)
					LIGHT:  //lighting
					begin
						r_reg <= r_next; //random the index of light
						lightsBin[lightIndex] <= r_reg;
						lighting <= lightsBin[lightIndex]; //LEDs light the cache "lightsBin[lightIndex]"
						lightIndex <= lightIndex + 1; //LEDs cache index++
						seg7Out <= level; //show your level now
						if (lightIndex == lightMax) //after 7 of lights
						begin
							lightIndex <= 0; //from cache 0
							state <= APPLY; //start to recieve player sw
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
					begin
						state <= state;
					end
				endcase
			end
			else
			begin
				counter <= counter - 1;
			end
		end
		
		
		if (state == APPLY) //input what sw be changed
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
		else
		begin
			lighting <= lighting;
		end
	end
	
endmodule