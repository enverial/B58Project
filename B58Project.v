module B58Project (SW, HEX0, HEX1, HEX2, CLOCK_50, LEDR);
	input [17:0] SW;
	input CLOCK_50;
	output [5:0] LEDR;
	output [7:0] HEX0, HEX1, HEX2;

	wire Reset;
	wire Enable;
	wire [7:0] Out;
	assign Reset = SW[17];
	
	RateDivider rateDiv(CLOCK_50, Enable, Reset);
	Timer timer(CLOCK_50, Enable, LEDR[1], Out, Reset);
	HexDisplay ones(Out[3:0], HEX0);
	HexDisplay tens(Out[7:4], HEX1);
	HexDisplay hundreds({3'b000, Out[2]}, HEX3);

endmodule

module RateDivider(Clock, OutTick, Reset);
	input Clock, Reset;
	output reg OutTick;
	
	// Register storing number of ticks
	reg [26:0] Ticks;
	
	always @(posedge Clock)
	begin
		if (!Reset)
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

module Timer(Clock, Enable, Done, Out, Reset);
	input Clock, Reset, Enable;
	output reg Done;
	output reg [7:0] Out;
	
	always @(posedge Clock)
	begin
		if (!Reset)
			begin
			Out <= 8'd120;
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

module HexDisplay(IN, OUT);
    input reg [2:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		// Shift Add 3 Input
		if (IN > 4'd4)
			IN <= IN + 4'd3;
		case(IN)
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
		endcase
	end
endmodule
