module project58u (SW, HEX0, HEX1, CLOCK_50, LEDR);
	input [17:0] SW;
	input CLOCK_50;
	output [5:0] LEDR;
	output [6:0] HEX0, HEX1;
	wire tick;
	wire [7:0] out;
	wire done;
	
	assign LEDR[0] = done;
	RateDividerTimer rateDiv(.Clock(CLOCK_50), .OutTick(tick), .Reset(done));
	Timer timer(.Clock(CLOCK_50), .Enable(tick), .Done(done), .Out(out));
	hex_display hd1(.IN(out[7:4]), .OUT(HEX1));
	hex_display hd2(.IN(out[3:0]), .OUT(HEX0));
	
endmodule

module RateDividerTimer(Clock, OutTick, Reset);
	input Clock, Reset;
	output reg OutTick;
	
	// Register storing number of ticks
	reg [26:0] Ticks;
	
	always @(posedge Clock)
	begin
		if (Reset)
			Ticks <= 27'd50000000;
		// Reset back to full once counter hits 0
		else if (Ticks == 27'd0)
			begin
			Ticks <= 27'd50000000;
			OutTick <= 1'd1;
			end
		else
			begin
			Ticks <= Ticks - 27'd1;
			OutTick <= 1'd0;
			end
	end
endmodule

module Timer(Clock, Enable, Done, Out);
	input Clock, Enable;
	output reg Done;
	output reg [7:0] Out;
	initial
	begin
	Done = 1'b1;
	end
	
	always @(posedge Clock)
	begin
		if (Done)
			begin
			Out <= 8'd30;
			Done <= 1'b0;
			end
			
		// Sends done signal when complete
		else if (Out == 8'd0)
			Done <= 1'b1;
			
		// Ticks when enable signal is recived
		else if (Enable == 1'b1)
			Out <= Out - 8'b1;
	end
endmodule


