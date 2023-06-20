module main(CH7, CH6, CH5, CH4, CH3, CH2, CH1, B3, B0, CLK, RGB, BITS_DIGITOS, BITS_SEGMENTOS, LEDS, PONTO);
	
	input CH7, CH6, CH5, CH4, CH3, CH2, CH1, B3, B0, CLK;
	
	
	wire CLK760HZ, Timer, CLK1HZ, CONFIRMA, INSERIR_CEDULA;
	wire [1:0] S_SENSORES, S_PAGAMENTO, S_ESCOLHA, BITS;
	wire [2:0] S_MAQUINA;
	wire [3:0] BITS_DISPLAY;
	wire [6:0] TEMP, SAIDA_D_MAQUINA, SAIDA_D_SENSORES, SAIDA_D_PAGAMENTO, SAIDA_D_ESCOLHA;
	
	output PONTO;
	output [2:0] RGB;
	output [3:0] BITS_DIGITOS;
	output [6:0] BITS_SEGMENTOS;
	output [9:0] LEDS;
	
	assign PONTO = 1;
	
	Temporizador(CLK1HZ, TEMP[6], TIMER_ESC);
	Temporizador(CLK1HZ, TEMP[5], TIMER_SEN);
	Temporizador(CLK1HZ, TEMP[4], TIMER_PAG);
	Temporizador2S(CLK1HZ, TEMP[3], TIMER_ERRO);
	Temporizador2S(CLK1HZ, TEMP[2], TIMER_PRE);
	Temporizador(CLK1HZ, TEMP[1], TIMER_AQU);
	Temporizador(CLK1HZ, TEMP[0], TIMER_PRO);
	DivisorFrequencia(CLK, CLK760HZ, CLK1HZ);
	LevelToPulse(!B3, CLK760HZ, CONFIRMA);
	LevelToPulse(!B0, CLK760HZ, INSERIR_CEDULA);
	MEFCafe(CLK760HZ, CONFIRMA, TIMER_AQU, TIMER_PAG, TIMER_PRO, TIMER_ERRO, TIMER_PRE, S_SENSORES, S_PAGAMENTO, S_ESCOLHA, SAIDA_D_MAQUINA, S_MAQUINA, TEMP);
	MaquinaSensores(CLK760HZ, TIMER_SEN, CH5, CH4, CH3, S_SENSORES, SAIDA_D_SENSORES);
	MaquinaPagamento(INSERIR_CEDULA, TIMER_PAG, {CH7, CH6}, {CH2, CH1}, SAIDA_D_PAGAMENTO, S_PAGAMENTO);
	MaquinaEscolha(CLK760HZ, TIMER_ESC, CONFIRMA, CH7, CH6, SAIDA_D_ESCOLHA, S_ESCOLHA);
	MuxSaidas(SAIDA_D_PAGAMENTO, SAIDA_D_SENSORES, SAIDA_D_ESCOLHA, SAIDA_D_MAQUINA, S_MAQUINA, BITS_DISPLAY);
	display(CLK760HZ, BITS_DISPLAY, BITS_DIGITOS, BITS_SEGMENTOS);
	
	assign LEDS = {(((!S_MAQUINA[2] && !S_MAQUINA[1]) || (S_MAQUINA[2] && S_MAQUINA[1])) && S_MAQUINA[0]),
			(((!S_MAQUINA[2] && !S_MAQUINA[1]) || (S_MAQUINA[2] && S_MAQUINA[1])) && S_MAQUINA[0]),
			(((!S_MAQUINA[2] && !S_MAQUINA[0]) || (S_MAQUINA[2] && S_MAQUINA[0])) && S_MAQUINA[1]),
			(((!S_MAQUINA[2] && !S_MAQUINA[0]) || (S_MAQUINA[2] && S_MAQUINA[0])) && S_MAQUINA[1]),
			(S_MAQUINA[1] && S_MAQUINA[0]),
			(S_MAQUINA[1] && S_MAQUINA[0]),
			(S_MAQUINA[2] && S_MAQUINA[0]),
			(S_MAQUINA[2] && S_MAQUINA[0]),
			(S_MAQUINA[2] && S_MAQUINA[1]),
			(S_MAQUINA[2] && S_MAQUINA[1])};

	assign RGB = {((S_MAQUINA[2] && !S_MAQUINA[1]) || (!S_MAQUINA[2] && S_MAQUINA[0]) || (S_MAQUINA[1] && !S_MAQUINA[0])),
	(S_MAQUINA[1] || (!S_MAQUINA[1] && S_MAQUINA[0])),
	((!S_MAQUINA[2] && !S_MAQUINA[1] && !S_MAQUINA[0]) || (S_MAQUINA[2] && ((!S_MAQUINA[1] && S_MAQUINA[0]) || (S_MAQUINA[1] && !S_MAQUINA[0]))))};

endmodule