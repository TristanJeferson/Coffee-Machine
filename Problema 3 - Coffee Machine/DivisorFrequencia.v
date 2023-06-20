module DivisorFrequencia (
  input clk,
  output reg clk_dividido760hz,
  output reg clk_dividido1hz
);

	reg [15:0] contador760hz;
	reg [9:0] contador1hz;
	initial begin 
		contador760hz = 0;
		contador1hz = 0;
	end

	always @(posedge clk) begin
		clk_dividido760hz= contador760hz[15];
		contador760hz <= contador760hz + 1; 
		
		if (contador760hz ==16'b1111111111111111)
	   begin
		 contador760hz <= 0;
	  end
	end
	
	always @(posedge clk_dividido760hz) begin
		if (contador1hz == 760) begin
		 contador1hz <= 0;
		 clk_dividido1hz<= ~clk_dividido1hz;
	  end else begin
		 contador1hz <= contador1hz + 1;
	  end
	end

endmodule