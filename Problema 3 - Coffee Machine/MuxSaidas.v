module MuxSaidas(SD_Pagamento, SD_Sensores, SD_Escolha, SD_Maquina, Estado, bitsDisplay);

	input [1:0] SD_Pagamento, SD_Sensores, SD_Escolha;
	input [2:0] SD_Maquina, Estado;
	output reg [3:0] bitsDisplay;
	
	always @(*) begin
		case(Estado)
			3'b000: bitsDisplay = SD_Maquina;
			3'b001: bitsDisplay = SD_Escolha;
			3'b010: bitsDisplay = SD_Sensores;
			3'b011: bitsDisplay = SD_Pagamento;
			3'b100: bitsDisplay = SD_Maquina;
			3'b101: bitsDisplay = 4'b1111;
			3'b110: bitsDisplay = 4'b1111;
			3'b111: bitsDisplay = 4'b1111;
		endcase
	end

endmodule
