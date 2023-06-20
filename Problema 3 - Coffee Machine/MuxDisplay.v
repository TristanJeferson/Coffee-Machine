module MuxDisplay(cadeiaDeBits, bits, saida);

	input [27:0] cadeiaDeBits;
	input [1:0] bits;
	output reg [6:0] saida;
	 
	always @(*) begin
		case (bits)
			2'b00: saida <= cadeiaDeBits[6:0];
			2'b01: saida <= cadeiaDeBits[13:7];
			2'b10: saida <= cadeiaDeBits[20:14];
			2'b11: saida <= cadeiaDeBits[27:21];
		endcase
	end
endmodule