module compare( one_input, two_input, change,clk,reset,advance,practicle);

	input [9:0]one_input;
	input [9:0]two_input;
	input clk;
	input reset,advance,practicle;
	output reg [3:0]change;
	
	
	initial
	begin
		change <= 4'b1110;
	end
	
	always@(posedge clk or posedge reset)
	begin
		if(reset==1)
		begin
			change <= 4'b1110;
		end
		else
		begin
			if(advance == 0 && practicle == 0)
			begin
				change <= 4'b1110;
			end
			else if(one_input[0]!=two_input[0] )
			begin
				if (change != 4'b0000)
				begin
					change <= 4'b0000;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[1]!=two_input[1])
			begin
				if (change != 4'b0001)
				begin
					change <= 4'b0001;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[2]!=two_input[2])
			begin
				if (change != 4'b0010)
				begin
					change <= 4'b0010;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[3]!=two_input[3])
			begin
				if (change != 4'b0011)
				begin
					change <= 4'b0011;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[4]!=two_input[4])
			begin
				if (change != 4'b0100)
				begin
					change <= 4'b0100;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[5]!=two_input[5])
			begin
				if (change != 4'b0101)
				begin
					change <= 4'b0101;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[6]!=two_input[6])
			begin
				if (change != 4'b0110)
				begin
					change <= 4'b0110;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[7]!=two_input[7])
			begin
				if (change != 4'b0111)
				begin
					change <= 4'b0111;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[8]!=two_input[8])
			begin
				if (change != 4'b1000)
				begin
					change <= 4'b1000;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else if(one_input[9]!=two_input[9])
			begin
				if (change != 4'b1001)
				begin
					change <= 4'b1001;
				end
				else
				begin
					change <= 4'b1111;
				end 
			end
			else  
			begin
				change <= change;
			end
		end
	end
	
endmodule