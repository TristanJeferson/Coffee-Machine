module Temporizador(
  input clk,
  input enable,
  output reg timer
);

  reg [2:0] contador;
  
  always @(posedge clk) begin
    if (enable) begin
      contador <= contador + 1;
      if (contador == 8)
        timer <= 1;
      else
        timer <= 0;
    end
    else begin
      contador <= 0;
      timer <= 0;
    end
  end
  
endmodule