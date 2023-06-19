module MaquinaSensores(CLK, TIMER, SN, SP, SR);

 input CLK, TIMER, SN, SP, SR;
 reg [2:0] ESTADO;
 parameter ANALISE = 3'b000 ;
 parameter ERRO_AGUA = 3'b001 ;
 parameter ERRO_CAPSULA= 3'b010 ;
 parameter ERRO_COPO = 3'b011 ;
 parameter ERRO_SENSORES = 3'b100 ;
 parameter SEM_ERROS = 3'b101;
 always @ ( posedge CLK )
  case (ESTADO)
   ANALISE: begin
    if (SN) ESTADO = ERRO_AGUA;
    else if (!SN && SP) ESTADO = ERRO_CAPSULA;
    else if (!SN && !SP && SR) ESTADO = ERRO_COPO;
    else ESTADO = SEM_ERROS;
   end
   ERRO_AGUA: begin
    if (!TIMER && !SN && SP) ESTADO = ERRO_CAPSULA;
    else if (!TIMER && !SN && !SP && SR) ESTADO = ERRO_COPO;
    else if (TIMER && SN) ESTADO = ERRO_SENSORES;
    else if (!SN && !SP && !SR) ESTADO = SEM_ERROS;
   end
   ERRO_CAPSULA: begin
    if (!TIMER && !SN && !SP && SR) ESTADO = ERRO_COPO;
    else if (TIMER && SP) ESTADO = ERRO_SENSORES;
    else if (!SN && !SP && !SR) ESTADO = SEM_ERROS;
   end
   ERRO_COPO: begin
    if (TIMER && SR) ESTADO = ERRO_SENSORES;
    else if (!SN && !SP && !SR) ESTADO = SEM_ERROS;
   end
//   ERRO_SENSORES:begin
//   end

//   SEM_ERROS:begin
//   end
  endcase
 assign SAIDA = ESTADO;
endmodule