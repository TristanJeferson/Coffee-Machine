module LevelToPulse (ruido, clk, sem_ruido);
	
	input ruido;
	input clk;
	output sem_ruido;

	reg FFD1, FFD2;
	
	initial begin
		FFD1 = 1'b0;
		FFD2 = 1'b0;
	end

	always @(posedge clk) begin
	  FFD1 <= ruido;
	  FFD2 <= FFD1 & ruido;
	end
	
	wire aneg;
	not (aneg, FFD2);
	and (sem_ruido, FFD1, aneg);

endmodule