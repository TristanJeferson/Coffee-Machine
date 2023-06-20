module MEFCafe( CLK , CONFIRMA, TIMER_AQU, TIMER_PAG, TIMER_PRO, TIMER_ERRO, TIMER_PRE, S_SENSORES, S_PAGAMENTO, S_ESCOLHA, SAIDA_DISPLAY, SAIDA, TEMP);
	input CLK , CONFIRMA, TIMER_AQU, TIMER_PAG, TIMER_PRO, TIMER_ERRO, TIMER_PRE;
	input [1:0] S_SENSORES, S_PAGAMENTO, S_ESCOLHA;
	output reg [3:0] SAIDA_DISPLAY;
	output reg [2:0] SAIDA;
	output reg [6:0] TEMP;
	
	reg [2:0] ESTADO;
	parameter ESPERANDO = 3'b000;
	parameter ESCOLHENDO = 3'b001;
	parameter SENSORES= 3'b010;
	parameter PAGAMENTO = 3'b011;
	parameter ERRO_VALOR = 3'b100;
	parameter PRESSURIZACAO = 3'b101;
	parameter AQUECIMENTO = 3'b110;
	parameter PRONTO = 3'b111;
	
	initial begin
		ESTADO = ESPERANDO;
	end
	
	always @ ( posedge CLK ) begin
		case (ESTADO)
			ESPERANDO : begin 
				if (CONFIRMA) ESTADO = ESCOLHENDO;
					SAIDA_DISPLAY = 4'b0000;
					SAIDA = 3'b000;
					TEMP = 7'b0000000;
			end
		
			ESCOLHENDO: begin
				if (S_ESCOLHA[1] && S_ESCOLHA[0]) ESTADO = S_SENSORES;
				else if (S_ESCOLHA[1] && !S_ESCOLHA[0]) ESTADO = ESPERANDO;
				SAIDA = 3'b001;
				TEMP = 7'b1000000;
			end
				
			S_SENSORES: begin
				if (S_SENSORES[1] && !S_SENSORES[0]) ESTADO = PAGAMENTO;
				else if (S_SENSORES[1] && S_SENSORES[0]) ESTADO = ESPERANDO;
				SAIDA = 3'b010;
				TEMP = 7'b0100000;
			end
			
			PAGAMENTO: begin
				if (!S_PAGAMENTO[1] && S_PAGAMENTO[0]) ESTADO = ERRO_VALOR;
				else if (S_PAGAMENTO[1] && S_PAGAMENTO[0]) ESTADO = PRESSURIZACAO;
				else if(TIMER_PAG) ESTADO = ESPERANDO;
				SAIDA = 3'b011;
				TEMP = 7'b0010000;
			end
			
			ERRO_VALOR: begin
				if (TIMER_ERRO) ESTADO = ESPERANDO;
				SAIDA_DISPLAY = 4'b1111;
				SAIDA = 3'b100;
				TEMP = 7'b0001000;
			end
				
			PRESSURIZACAO: begin
				if (TIMER_PRE) ESTADO = AQUECIMENTO;
				SAIDA_DISPLAY = 4'b1110;
				SAIDA = 3'b101;
				TEMP = 7'b0000100;
			end
				
			AQUECIMENTO: begin
				if (TIMER_AQU) ESTADO = PRONTO;
				SAIDA = 3'b110;
				TEMP = 7'b0000010;
			end
				
			PRONTO: begin
				if (TIMER_PRO) ESTADO = ESPERANDO;
				SAIDA = 3'b111;
				TEMP = 7'b0000001;
			end
		endcase
	end
endmodule