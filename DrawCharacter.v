module DrawCharacter(CurrState, Clock, Reset, XOut, YOut);
	input [3:0] CurrState;
	input Clock, Reset;
	
	// X and Y coordinates mark top left corner
	// Character is 9 x 5 rectangle
	output reg [7:0] XOut;
	output reg [6:0] YOut;
	
	reg [3:0] XCounter;
	reg [2:0] YCounter;
	
	reg [3:0] SavedState;
	
	localparam  POS0 = 4'd0,
				   POS1 = 4'd1,
				   POS2 = 4'd2,
				   POS3 = 4'd3,
				   POS4 = 4'd4,
				   POS5 = 4'd5;
				   POS6 = 4'd6;
				   POS7 = 4'd7;
				   POS8 = 4'd8;
	
	always @(posedge Clock)
		begin
			case (SavedState)
			POS0: 
				begin
				XOut <= 8'd6 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			POS1:
				begin
				XOut <= 8'd24 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			POS2:
				begin
				XOut <= 8'd42 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			POS3:
				begin
				XOut <= 8'd60 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			POS4:
				begin
				XOut <= 8'd78 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			POS5:
				begin
				XOut <= 8'd96 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			POS6:
				begin
				XOut <= 8'd114 + XCounter;
				YOut <= 7'd7 - YCounter;
				end			
			POS7:
				begin
				XOut <= 8'd132 + XCounter;
				YOut <= 7'd7 - YCounter;
				end	
			POS8:
				begin
				XOut <= 8'd150 + XCounter;
				YOut <= 7'd7 - YCounter;
				end
			endcase
		
	always @(posedge Clock)
		begin
		if (!Reset)
			SavedState <= POS4;
		else
			SavedState <= CurrState; 
		end
        
	always @(posedge Clock)
		begin
		if (!Reset)
			begin
			XCounter <= 0;
			YCounter <= 0;
			end
		else
			begin
			XCounter <= XCounter + 1;
			YCounter <= YCounter + 1;
			end
		end
endmodule 
