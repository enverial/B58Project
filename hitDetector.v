module project58xy (SW, LEDR);
   input [17:0] SW;
	output [3:0] LEDR;
	
	hitDetector hd(
		.fruitx(SW[3:0]),
		.fruity(SW[11:8]),
		.charx(SW[7:4]),
		.chary(SW[15:12]),
		.color(SW[17:16]),
		.out(LEDR[0])
	);
	
endmodule


module hitDetector(clk, fruitx, fruity, charx, chary, colour, out);
   input clk;
	input [6:0] fruitx;
	input [6:0] fruity;
	input [6:0] charx;
	input [6:0] chary;
	input [2:0] colour;
	output reg out;
	
	always @(posedge clk)
	begin
	    out = (fruitx == charx) && (fruity == chary) && (colour != 3'b111); // we want the coordinates to be the same and not be black
	end
endmodule

module score(enable, colour,enable2, colour2, scoreOut);
	input enable;
	input [2:0] colour;
	input enable2;
	input [2:0] colour2;
	output reg [7:0] scoreOut;
   initial
   begin
       scoreOut = 8'b0;
	end 
	
	always @(posedge enable, posedge enable2)
	begin
	   if (enable)
		begin
			case(colour)
				3'b000: scoreOut = scoreOut + 1'b1;
				3'b001: scoreOut = scoreOut + 2'b10;
				3'b010: scoreOut = scoreOut + 2'b11;
				3'b011: scoreOut = scoreOut + 3'b100;
				3'b100: scoreOut = scoreOut - 1'b1;
				3'b101: scoreOut = scoreOut + 3'b101;
				3'b110: scoreOut = scoreOut - 2'b10;
				3'b111: scoreOut = scoreOut + 2'b10;
				default: scoreOut = scoreOut + 1'b0;
			endcase
		end
	end
	
endmodule

module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
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
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule
