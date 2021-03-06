module EraseCharacter(PrevState, WriteEn, Clock, Reset, XOut, YOut, DoneDrawing, Color);
	input [3:0] PrevState;
	input Clock, Reset, WriteEn;
	
	// X and Y coordinates mark top left corner
	// Character is 9 x 5 rectangle
	output reg [7:0] XOut;
	output reg [6:0] YOut;
	output reg DoneDrawing;
	output [2:0] Color;
	
	reg [3:0] SavedState;
	reg [3:0] XCounter;
	reg [2:0] YCounter;

	localparam  
		POS0 = 4'd0,
		POS1 = 4'd1,
		POS2 = 4'd2,
		POS3 = 4'd3;
	
	always @(*)
		begin
		if (WriteEn)
			SavedState <= PrevState;
		end
	
	always @(posedge Clock)
		begin
			case (SavedState)
			POS0: 
				begin
				XOut <= 8'd6 + XCounter;
				YOut <= 7'd102 + YCounter;
				end
			POS1:
				begin
				XOut <= 8'd24 + XCounter;
				YOut <= 7'd102 + YCounter;
				end
			POS2:
				begin
				XOut <= 8'd78 + XCounter;
				YOut <= 7'd102 + YCounter;
				end
			POS3:
				begin
				XOut <= 8'd132 + XCounter;
				YOut <= 7'd102 + YCounter;
				end
			endcase
			
	always @(posedge Clock)
		begin
		Color <= 3'b111;
		if (!Reset)
			begin
			XCounter <= 9;
			YCounter <= 5;
			DoneDrawing <= 0;
			end
		else if (WriteEn)
			begin
				if (XCounter > 0)
					XCounter <= XCounter - 1;
				if (YCounter > 0)
				YCounter <= YCounter - 1;
			end
		if (XCounter == 0 && YCounter == 0)
			DoneDrawing <= 1;
		end
endmodule 
