module MaquinaSensores(CLK, TIMER, SN, SP, SR, SAIDA, SAIDA_DISPLAY);

	input CLK, TIMER, SN, SP, SR;
	output reg [1:0] SAIDA;
	output reg [3:0] SAIDA_DISPLAY;
	
	reg [2:0] ESTADO;
	parameter ANALISE = 3'b000 ;
	parameter ERRO_AGUA = 3'b001 ;
	parameter ERRO_CAPSULA= 3'b010 ;
	parameter ERRO_COPO = 3'b011 ;
	parameter ERRO_SENSORES = 3'b100 ;
	parameter SEM_ERROS = 3'b101;
	
	initial begin
		ESTADO = ANALISE;
	end
	
	always @ ( posedge CLK ) begin
		case (ESTADO)
			
			ANALISE: begin
				if (SN) ESTADO = ERRO_AGUA;
				else if (!SN && SP) ESTADO = ERRO_CAPSULA;
				else if (!SN && !SP && SR) ESTADO = ERRO_COPO;
				else ESTADO = SEM_ERROS;
				SAIDA = 2'b00;
			end
			
			ERRO_AGUA: begin
				if (!TIMER && !SN && SP) ESTADO = ERRO_CAPSULA;
				else if (!TIMER && !SN && !SP && SR) ESTADO = ERRO_COPO;
				else if (TIMER) ESTADO = ERRO_SENSORES;
				else if (!SN && !SP && !SR) ESTADO = SEM_ERROS;
				SAIDA = 2'b01;
				SAIDA_DISPLAY = 4'b0101;
			end
			
			ERRO_CAPSULA: begin
				if (!TIMER && !SN && !SP && SR) ESTADO = ERRO_COPO;
				else if (TIMER) ESTADO = ERRO_SENSORES;
				else if (!SN && !SP && !SR) ESTADO = SEM_ERROS;
				SAIDA = 2'b01;
				SAIDA_DISPLAY = 4'b0110;
			end
			
			ERRO_COPO: begin
				if (TIMER) ESTADO = ERRO_SENSORES;
				else if (!SN && !SP && !SR) ESTADO = SEM_ERROS;
				SAIDA = 2'b01;
				SAIDA_DISPLAY = 4'b0111;
			end
			
			ERRO_SENSORES:begin
				SAIDA = 2'b11;
			end

			SEM_ERROS:begin
				SAIDA = 2'b10;
			end
		endcase
	end
endmodule