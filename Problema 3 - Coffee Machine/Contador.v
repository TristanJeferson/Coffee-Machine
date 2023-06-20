module Contador(clk, bits);
	input clk;
	output reg [1:0] bits;
	
	always @(posedge clk)begin
		if (bits == 3'b11) begin
			bits = 	0;
		end
		bits = bits + 1;
	end
endmodule 