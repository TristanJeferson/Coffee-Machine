module MaquinaEscolha(CLK, Timer, Confirma, Sel1, Sel2, SAIDA_DISPLAY, SAIDA);
	
	input CLK, Timer, Sel1, Sel2, Confirma;
	output reg [3:0] SAIDA_DISPLAY;
	output reg [1:0] SAIDA;
	
	reg [2:0] ESTADO;
	parameter ANALISE = 3'b000;
	parameter CAFE_EXP = 3'b001;
	parameter CAFE_LEITE= 3'b010;
	parameter CHA = 3'b011;
	parameter CAPPUCCINO = 3'b100;
	parameter ESCOLHEU = 3'b101;
	parameter NAO_ESCOLHEU = 3'b110;
	
	initial begin 
		ESTADO = ANALISE;
	end
	
	always @(posedge CLK) begin
		case(ESTADO)
			ANALISE: begin
				if(!Sel1 && !Sel2 && Confirma) ESTADO = CAFE_EXP;
				else if (!Sel1 && Sel2 && Confirma) ESTADO = CAFE_LEITE;
				else if (Sel1 && !Sel2 && Confirma) ESTADO = CHA;
				else if (Sel1 && Sel2 && Confirma) ESTADO = CAPPUCCINO;
				SAIDA = 2'b00;
			end
			
			CAFE_EXP: begin
				if (!Sel1 && Sel2) ESTADO = CAFE_LEITE;
				else if (Sel1 && !Sel2) ESTADO = CHA;
				else if (Confirma) ESTADO = ESCOLHEU;
				else if (Timer) ESTADO = NAO_ESCOLHEU;
				SAIDA_DISPLAY = 4'b0001;
				SAIDA = 2'b01;
			end
			
			CAFE_LEITE: begin
				if (!Sel1 && !Sel2)	ESTADO = CAFE_EXP;
				else if (Sel1 && Sel2) ESTADO = CAPPUCCINO;
				else if (Confirma) ESTADO = ESCOLHEU;
				else if (Timer) ESTADO = NAO_ESCOLHEU;
				SAIDA_DISPLAY = 4'b0010;
				SAIDA = 2'b01;
			end	
			
			CHA: begin
				if (!Sel1 && !Sel2)	ESTADO = CAFE_EXP;
				else if(Sel1 && Sel2) ESTADO = CAPPUCCINO;
				else if (Confirma) ESTADO = ESCOLHEU;
				else if (Timer) ESTADO = NAO_ESCOLHEU;
				SAIDA_DISPLAY = 4'b0011;
				SAIDA = 2'b01;
			end
			
			CAPPUCCINO: begin
				if (!Sel1 && Sel2) ESTADO = CAFE_LEITE;
				else if (Sel1 && !Sel2) ESTADO = CHA;
				else if (Confirma) ESTADO = ESCOLHEU;
				else if (Timer) ESTADO = NAO_ESCOLHEU;
				SAIDA_DISPLAY = 4'b0100;
				SAIDA = 2'b01;
			end
			
			ESCOLHEU: begin
				SAIDA = 2'b11;
			end
			
			NAO_ESCOLHEU: begin
				SAIDA = 2'b10;
			end
		endcase
	end

endmodule