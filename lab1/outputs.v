module outputs(seg7, advance_display, particle_display ,start_in ,sel_1,sel_0);
	input sel_1,sel_0;
	input [7:0]advance_display;
	input [7:0]particle_display;
	input [31:0]start_in;
	output [31:0] seg7;
	reg [31:0] data;
	
	Bin2Dec bin2dec_inst(data,seg7); 
	
	always@({sel_1,sel_0})
	begin
	
		case({sel_1,sel_0})
			0: data = start_in[31:0];
			1: data = {24'b000000000000000000000000,particle_display};
			2: data = {24'b000000000000000000000000,advance_display};
			default: data = start_in[31:0];
		endcase
	
	end
	
endmodule