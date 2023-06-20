module display(clk, bits, digitos, cadeiaSegmentos);

	input clk;
	input [3:0] bits;
	output [3:0] digitos;
	output [6:0] cadeiaSegmentos;
	
	wire [1:0] contadorD;
	wire [27:0] cadeiaBits;
	
	Contador(clk, contadorD);
	DecodificadorDisplay(bits, cadeiaBits);
	MuxDisplay(cadeiaBits, contadorD, cadeiaSegmentos);
	DemuxDisplay(1, contadorD, digitos);

endmodule