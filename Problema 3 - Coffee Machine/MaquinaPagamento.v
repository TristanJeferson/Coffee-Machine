module MaquinaPagamento(CLK, TIMER, PRODUTO, CEDULA, SAIDA);

 input CLK, TIMER;
 input [1:0] PRODUTO, CEDULA;
 output [2:0] SAIDA;
 
 reg [2:0] ESTADO;
 parameter AGUARDANDO = 3'b000 ;
 parameter RECEBEU2 = 3'b001 ;
 parameter RECEBEU4= 3'b010 ;
 parameter RECEBEU6 = 3'b011 ;
 parameter RECEBEU8 = 3'b100 ;
 parameter RECEBEU5 = 3'b101;
 parameter INCORRETO = 3'b110;
 parameter PAGO = 3'b111;
 
 always @ ( posedge CLK )
  case (ESTADO)
   
   AGUARDANDO: begin
    if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[0]) ESTADO = RECEBEU2;
    else if(!TIMER && CEDULA[1] && !CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU5;
    else if (!TIMER && CEDULA[1] && !PRODUTO[1] && !PRODUTO[0]) ESTADO = INCORRETO;
    else if((!TIMER && !CEDULA[1] && CEDULA[0] && !PRODUTO[1] && !PRODUTO[0]) || !TIMER && CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
    //else if(TIMER); TEM QUE IR PRA ESPERANDO DA MAQUINA DE CAFE
    //else if(!TIMER && !CEDULA[1] && !CEDULA[0]); TEM QUE IR PARA DEVOLVER DINHEIRO
   end
    
   RECEBEU2: begin
    if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU4;
    else if(CEDULA[1] && PRODUTO[0]) ESTADO = INCORRETO;
    else if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
   end
    
   RECEBEU4: begin
    if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU6;
    else ESTADO = INCORRETO;
   end 
    
   RECEBEU6: begin
    if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = RECEBEU8;
    else ESTADO = INCORRETO;
   end
   
   RECEBEU8: begin
    if(!TIMER && !CEDULA[1] && CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
    else ESTADO = INCORRETO;
   end
   
 RECEBEU5: begin
  if(TIMER ((!TIMER && !CEDULA[1] && !CEDULA[0])(!TIMER && !CEDULA[1] && CEDULA[0])||
  (!TIMER && CEDULA[1] && CEDULA[0])) && PRODUTO[1] && PRODUTO[0]) ESTADO = INCORRETO;
  else if (!TIMER && CEDULA[1] && !CEDULA[0] && PRODUTO[1] && PRODUTO[0]) ESTADO = PAGO;
 end
   //INCORRETO: begin deve sair para maquina maior
   //end
   
   //PAGO: begin Deve sair para maquina maior
   //end
   
  endcase
 
 assign SAIDA = ESTADO;
endmodule