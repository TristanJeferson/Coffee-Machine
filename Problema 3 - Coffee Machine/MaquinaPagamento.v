module MaquinaPagamento(CLK, TIMER, PRODUTO, CEDULA, SAIDA_DISPLAY, SAIDA);

	input CLK, TIMER;
	input [1:0] PRODUTO, CEDULA;
	output reg [1:0] SAIDA;
	output reg [3:0] SAIDA_DISPLAY;

	
	reg [2:0] ESTADO;
	parameter AGUARDANDO = 3'b000 ;
	parameter RECEBEU2 = 3'b001 ;
	parameter RECEBEU4= 3'b010 ;
	parameter RECEBEU6 = 3'b011 ;
	parameter RECEBEU8 = 3'b100 ;
	parameter RECEBEU5 = 3'b101;
	parameter INCORRETO = 3'b110;
	parameter PAGO = 3'b111;
	
	initial begin 
		ESTADO = AGUARDANDO;
	end
	
	always @ ( posedge CLK ) begin
		case (ESTADO)
			
			AGUARDANDO: begin
				if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[0]) ESTADO = RECEBEU2;
				else if(!TIMER && CEDULA[1] && !CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU5;
				else if ((!TIMER && CEDULA[1] && !PRODUTO[1] && !PRODUTO[0]) || (!TIMER && !CEDULA[1] && !CEDULA[0]) || TIMER) ESTADO = INCORRETO;
				else if(!TIMER && !CEDULA[1] && CEDULA[0] && !PRODUTO[1] && !PRODUTO[0]) ESTADO = PAGO;
				SAIDA_DISPLAY = 1'b1000;
				SAIDA = 2'b00;
			end
				
			RECEBEU2: begin
				if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU4;
				else if((CEDULA[1] && PRODUTO[0]) || TIMER) ESTADO = INCORRETO;
				else if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
				SAIDA_DISPLAY = 1'b1001;
				SAIDA = 2'b01;
			end
				
			RECEBEU4: begin
				if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU6;
				else ESTADO = INCORRETO;
				SAIDA_DISPLAY = 1'b1010;
				SAIDA = 2'b01;
			end	
				
			RECEBEU6: begin
				if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU8;
				else ESTADO = INCORRETO;
				SAIDA_DISPLAY = 1'b1100;
				SAIDA = 2'b01;
			end
			
			RECEBEU8: begin
				if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
				else ESTADO = INCORRETO;
				SAIDA_DISPLAY = 1'b1101;
				SAIDA = 2'b01;
			end
			
			RECEBEU5: begin
				if (!TIMER && CEDULA[1] && !CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
				else ESTADO = INCORRETO;
				SAIDA_DISPLAY = 1'b1011;
				SAIDA = 2'b01;
			end
				
			INCORRETO: begin
				SAIDA = 2'b10;
			end
			
			PAGO: begin
				SAIDA = 2'b11;
			end
			
		endcase
	end
endmodule