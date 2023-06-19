module MEFCafe( CLK , BOTAO_CONFIRMA, TIMER, SN, SP, SR, TIMER_2S,  SENSOR, PAGAR, SAIDA);
 input CLK , BOTAO_CONFIRMA, TIMER, SN, SP, SR, TIMER_2S;
 input [1:0] SENSOR, PAGAR;
 output
 
 reg [2:0] ESTADO;
 parameter ESPERANDO = 3'b000 ;
 parameter ESCOLHENDO = 3'b001 ;
 parameter SENSORES= 3'b010 ;
 parameter PAGAMENTO = 3'b011 ;
 parameter ERRO_VALOR = 3'b100 ;
 parameter PRESSURIZACAO = 3'b101;
 parameter AQUECIMENTO = 3'b110;
 parameter PRONTO = 3'b111;
 
 always @ ( posedge CLK )
  case (ESTADO)
   ESPERANDO : begin 
    if (BOTAO_CONFIRMA) ESTADO = ESCOLHENDO ;
    end
  
   ESCOLHENDO: begin
    if (!TIMER && BOTAO_CONFIRMA) ESTADO = SENSORES;
    else if (TIMER) ESTADO = ESPERANDO;
    end
    
   SENSORES: begin
    if (SENSOR[1] && !SENSOR[0]) ESTADO = PAGAMENTO;
    else if (SENSOR[1] && SENSOR[0]) ESTADO = ESPERANDO;
    end
   
   PAGAMENTO: begin
    if (!PAGAR[1] && PAGAR[0]) ESTADO = ERRO_VALOR;
    else if (PAGAR[1] && PAGAR[0]) ESTADO = PRESSURIZACAO;
    else if(TIMER) ESTADO = ESPERANDO;
    end
   
   ERRO_VALOR: begin
    if (TIMER) ESTADO = ESPERANDO;
    end
    
   PRESSURIZACAO: begin
    if (TIMER_2S) ESTADO = AQUECIMENTO;
    end
    
   AQUECIMENTO: begin
    if (TIMER) ESTADO = PRONTO;
    end
    
   PRONTO: begin
    if (TIMER) ESTADO = ESPERANDO;
    end
  endcase
  
 assign SAIDA = ESTADO;
 
endmodule

//000 = RGB(BLUE)
//001 = RGB(RED GREEN) LED 1 E 2
//010 = RGB(RED GREEN) LED 3 E 4
//011 = RGB(RED GREEN) LED 5 E 6
//100 = RGB(RED)
//101 = RGB(ALL) LED 7 E 8
//110 = RGB(ALL) LED 9 E 10
//111 = RGB(GREEN) LED TUDO