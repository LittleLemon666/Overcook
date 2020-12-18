module control(out_sel, addr, mem_w, sys_reset, cnt_reset, acc_clk, clk, enter, stop, reset, sw);

	input clk, reset, enter, stop;
	input [5:0] sw;
	output reg[1:0] out_sel;
	output reg[5:0] addr;
	output reg mem_w, sys_reset, cnt_reset, acc_clk;
	reg[2:0] state;
	reg start;
	
	always@(posedge clk)begin
		case(state)
			0:  //ready reset
			begin
				state <= 0;
				start <= 0;
				sys_reset <= 1;
				cnt_reset <= 1;
				addr <= 0;
				out_sel <= 0;
				acc_clk <= 0;
				mem_w <= 0;
				
				if(enter)
					state <= 1;
				else if(reset)
					state <= 0;
			end
			
			1:  //run
			begin
				sys_reset <= 0;
				cnt_reset <= 0;
				if(enter)
				begin
					state <= 2;
					if(start)
						mem_w <= 1;
					else
						mem_w <= 0;
				end
				else if(stop)
					state <= 4;
				else if(reset)
					state <= 0;
			end
			
			2:  //enter
			begin
				if(~enter)
				begin
					mem_w <= 0;
					state <= 3;
					if(start)
						acc_clk <= 1;
				end
				else if(stop)
					state <= 4;
				else if(reset)
					state <= 0;
			end
			
			3:  //write
			begin
				addr <= addr + 1;
				cnt_reset <= 1;
				state <= 1;
				acc_clk <= 0;
				start <= 1;
			end
			
			4:  //stop
			begin
			
				cnt_reset <= 1;
				mem_w <= 0;
				addr <= sw;
				
				if(addr == 0)
					out_sel <= 1;
				else
					out_sel <= 2;
					
				if(reset)
					state <= 0;
					
			end
			
			default:
				state <= 0;
		endcase
	end
	
endmodule