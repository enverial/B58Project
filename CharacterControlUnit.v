module B(LEDR, CLOCK_50, PS2_KBDAT);
	output [2:0] LEDR;
	input CLOCK_50;
	input PS2_KBDAT;

	wire [7:0] KeyboardOut;
	
	CharacterControlUnit(LEDR[1], LEDR[0], KeyboardOut, CLOCK_50);
	Keyboard (CLOCK_50, PS2_KBDAT, KeyboardOut);
endmodule

module CharacterControlUnit(GoLeft, GoRight, KeyboardIn, Clock);
	input Clock;
	input [7:0] KeyboardIn;
	output reg GoLeft, GoRight;
	
	// If keyboard input is E07B go left
	// if keyboard is E074 go right
	always @(posedge Clock)
		begin
		GoLeft <= 1'b0;
		GoRight <= 1'b0;
		if (KeyboardIn == 8'h16)
			GoLeft <= 1'b1;
		else if (KeyboardIn == 8'h1e)
			GoRight <= 1'b1;
		end
endmodule


// Code from http://students.iitk.ac.in/eclub/assets/tutorials/keyboard.pdf
module Keyboard(Clock, Data, KeyboardOut);
	input Clock, Data;
	output reg [7:0] KeyboardOut;
	reg [7:0] data_curr, data_pre;
	reg [3:0] b;
	reg flag;
	
	initial
		begin
		b <= 4'h1;
		flag <=1'b0;
		data_curr <= 8'hf0;
		data_pre <= 8'hf0;
		KeyboardOut <= 8'hf0;
		end
	
	always @(negedge Clock)
		begin
		case (b)
		1:;
		2: data_curr[0] <= Data;
		3: data_curr[1] <= Data;
		4: data_curr[2] <= Data;
		5: data_curr[3] <= Data;
		6: data_curr[4] <= Data;
		7: data_curr[5] <= Data;
		8: data_curr[6] <= Data;
		9: data_curr[7] <= Data;
		10: flag <= 1'b1;
		11: flag <= 1'b0;
		endcase
		
		if (b <= 10)
			b <= b+1;
		else if (b == 11)
			b <= 1;
		end
	
	always @(posedge flag)
	begin
		if (data_curr == 8'hf0)
			KeyboardOut <= data_pre;
		else
			data_pre <= data_curr;
	end
endmodule
	