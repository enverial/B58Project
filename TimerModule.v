module TimerModule (SW, HEX0, HEX1, HEX2, CLOCK_50, LEDR);
	input [17:0] SW;
	input CLOCK_50;
	output [5:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2;

	wire Reset;
	wire Enable;
	wire [3:0] Ones;
	wire [3:0] Tens;
	wire [7:0] Out;
	assign Reset = SW[17];
	
	// Used to convert 50MHZ clock signal to 1Hz
	RateDivider rateDiv(CLOCK_50, Enable, Reset);
	
	// Takes enable signal from Rate Divider and counts down from a specific value.
	// Sends done signal through Done when complete, counts down when reset is not low
	Timer timer(CLOCK_50, Enable, LEDR[1], Out, Reset);
	ShiftRegister(Out, Ones, Tens, CLOCK_50, Reset); 
	
	// Hex displays digits based on timer module
	HexDisplay ones(Ones, HEX0, CLOCK_50);
	HexDisplay tens(Tens, HEX1, CLOCK_50);

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

module ShiftRegister(IN, ones, tens, Clock, Reset);
	input [7:0] IN;
	input Clock, Reset, Enable
	reg [7:0] OUT;
	
	reg [3:0] i;
	output reg [3:0] ones, tens;
	
	always @(posedge Clock)
		begin
		if (!Reset)
			begin
			OUT <= 0;
			i <= 7;
			end
		else
			begin
			// Shift
			OUT <= {OUT, IN[i]};
			i <= i - 1;
			if (i == 0)
				i <= 7;
			end
		end
	
	// Shifts digits of input 1 at a time into output and adds 3 to each group of 4 bits
	// If they are greater than 4
	always @(*)
		begin
		ones <= OUT[3:0];
		tens <= OUT[7:4];
			if (ones > 4)
				ones <= ones + 3;
			if (tens > 4)
				tens <= tens + 3;
		end
endmodule

module HexDisplay(IN, OUT, Clock);
    	input [3:0] IN;
    	input Clock;
	output reg [6:0] OUT;
	 	 
	 always @(*)
	 begin
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
