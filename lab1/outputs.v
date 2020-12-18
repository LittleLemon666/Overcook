module outputs(seg7, cnt_in, acc_in, mem_in,sel);
	input [1:0]sel;
	input [12:0]cnt_in,acc_in,mem_in;
	output [31:0] seg7;
	reg [12:0] data;
	
	Bin2Dec bin2dec_inst(data,seg7);
	
	always@(sel)begin
		case(sel)
			0: data = cnt_in;
			1: data = acc_in;
			2: data = mem_in;
			default: data = acc_in;
		endcase
	end
endmodule