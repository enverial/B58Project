module B58Projectx(SW, LEDR);
	
	input [17:0] SW; // switches, 17 is clock, 14 is load_n, 15 is shift right, 16 is Arithmetic shift
	output [7:0] LEDR; // led out
	
	Shifter rightShifter ( 
		.LoadVal(SW[7:0]),
		.Load_n(SW[14]),
		.ShiftRight(SW[15]),
		.ASR(SW[16]),
		.clock(SW[17]),
		.reset_n(SW[9]),
		.q(LEDR[7:0])
	);


endmodule


// module for positive edge triggered flip flop
module DFlipFlop(in, out, clock, reset_n);
	input in; // input data
	input clock, reset_n; // clock and reset input
	output reg out; // output
	
	// positive edge flip flop, that is triggered everytime the clock rises
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)	
			out <= 0;
		else
			out <= in;
	end

endmodule

module mux2to1 (x, y, s, m);
	input x, y, s;
	output m;
	
	assign m = ~s & x | s & y;

endmodule

module ShifterBit (in, shift, load_val, load_n, clock, reset_n, out); // single bit shifter
	input in, shift, load_val, load_n, clock, reset_n;
	output out;
	
	wire mux0Data; // shift in from mux 0
	
	mux2to1 M0 ( 
		.x(out),
		.y(in),
		.s(shift),
		.m(mux0Data)
	);
	
	mux2to1 M1 ( // instantiates the 2nd mux
		.x(load_val), // the parallel load value
		.y(mux0Data),
		.s(load_n),
		.m(data_to_diff) //output to flip flop
	);
	
	wire data_to_diff;
	
	DFlipFlop F0 ( // instantiates flip flop
		.in(data_to_diff), //input to flip flop
		.out(out), //output from flip flop
		.clock(clock), // clock signal
		.reset_n(reset_n) // synchronous active low reset
	);

endmodule
	
// 8 bith right shifter
module Shifter (LoadVal, Load_n, ShiftRight, ASR, clock, reset_n, q);
	input [7:0] LoadVal; // bits for shift
	input Load_n, ShiftRight, ASR, clock, reset_n; // in for shifterbit
	wire first_in;
	output [7:0] q; //output of shift
	
	// instantiate 8 shifter bit, with first in as ASR
	// when ASR is high (Arithmetic Right Shift)
	// loads all 0s when ASR is low
	// out of prev shifter is in of next
	
	assign first_in = (q[6] ^ q[5]) ^ (q[4] ^ q[0]);
	ShifterBit bit0 (
		.in(q[1]),
		.shift(ShiftRight),
		.load_val(LoadVal[0]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[0])
	);

	ShifterBit bit1 (
		.in(q[2]),
		.shift(ShiftRight),
		.load_val(LoadVal[1]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[1])
	);

	ShifterBit bit2 (
		.in(q[3]),
		.shift(ShiftRight),
		.load_val(LoadVal[2]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[2])
	);
	
	ShifterBit bit3 (
		.in(q[4]),
		.shift(ShiftRight),
		.load_val(LoadVal[3]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[3])
	);
	
	ShifterBit bit4 (
		.in(q[5]),
		.shift(ShiftRight),
		.load_val(LoadVal[4]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[4])
	);
	
	ShifterBit bit5 (
		.in(q[6]),
		.shift(ShiftRight),
		.load_val(LoadVal[5]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),	
		.out(q[5])
	);
	
	ShifterBit bit6 (
		.in(q[7]),
		.shift(ShiftRight),
		.load_val(LoadVal[6]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[6])
	);
	
	ShifterBit bit7 (
		.in(first_in),
		.shift(ShiftRight),
		.load_val(LoadVal[7]),
		.load_n(Load_n),
		.clock(clock),
		.reset_n(reset_n),
		.out(q[7])
	);
	
endmodule