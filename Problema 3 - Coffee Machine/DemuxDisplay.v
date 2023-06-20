module DemuxDisplay(on, bits, cadeia);
	input on;
	input [1:0] bits;
	output reg [3:0] cadeia;
	
	always @ (bits, on) begin
		if (!on)
			cadeia <= 4'b0000;
		else begin
			case (bits)
				2'b00: cadeia <= 4'b1110;
				2'b01: cadeia <= 4'b1101;
				2'b10: cadeia <= 4'b1011;
				2'b11: cadeia <= 4'b0111;
				default: cadeia <= 4'b0000;
			endcase 
		end
	end
endmodule