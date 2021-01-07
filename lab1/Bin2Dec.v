module Bin2Dec (Sw, Seg7);
	input [31:0] Sw;
	output [31:0] Seg7;
	reg [3:0] n0, n1, n2, n3;
	
	Seg7Decode s0 (n0, Seg7 [7:0]);
	Seg7Decode s1 (n1, Seg7 [15:8]);
	Seg7Decode s2 (n2, Seg7 [23:16]);
	Seg7Decode s3 (n3, Seg7 [31:24]);
	
	always@(Sw)
	begin
		if(Sw == 255)
		begin
			n3 = 10;
			n2 = 11;
			n1 = 11;
			n0 = 12;
		end
		else if(Sw == 253)
		begin
			n3 = 15;
			n2 = 13;
			n1 = 14;
			n0 = 12;
		end
		else
		begin
			n3 = Sw/1000;
			n2 = (Sw%1000)/100;
			n1 = (Sw%100)/10;
			n0 = (Sw%10);
		end
	end
	
	
	
endmodule