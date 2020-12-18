module inputs(sw_out, enter, stop, reset, sw_in, btn_enter, btn_stop, btn_reset, clk);
	input btn_enter, btn_stop, btn_reset, clk;
	input [5:0] sw_in;
	output enter, stop, reset;
	output[5:0] sw_out;
	
	assign sw_out = sw_in;
	
	button_debouncer bd_enter(clk,1,~btn_enter,enter);
	button_debouncer bd_stop(clk,1,~btn_stop,stop);
	button_debouncer bd_reset(clk,1,~btn_reset,reset);
	
endmodule