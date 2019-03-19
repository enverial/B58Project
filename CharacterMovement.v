module CharacterFSM(LeftIn, RightIn, CurrState, Clock, Reset);
	input LeftIn, RightIn, Clock, Reset;
	output [3:0] reg CurrState;
   	reg [3:0] current_state, next_state; 
   
	localparam  POS0 = 4'd0,
				   POS1 = 4'd1,
				   POS2 = 4'd2,
				   POS3 = 4'd3,
				   POS4 = 4'd4,
				   POS5 = 4'd5;
				   POS6 = 4'd6;
				   POS7 = 4'd7;
				   POS8 = 4'd8;
					 
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
					// Leftmost state, can only go right
					POS0: next_state = RightIn ? POS1 : POS0;
					POS1:
						begin
						if (RightIn)
							next_state = POS2;
						else if (LeftIn)
							next_state = POS0;
						else
							next_state = POS1;
						end
					POS2:
						begin
						if (RightIn)
							next_state = POS2;
						else if (LeftIn)
							next_state = POS1;
						else
							next_state = POS2;
						end
					POS3:
					begin
						if (RightIn)
							next_state = POS4;
						else if (LeftIn)
							next_state = POS2;
						else
							next_state = POS3;
						end
					POS4:
						begin
						if (RightIn)
							next_state = POS5;
						else if (LeftIn)
							next_state = POS3;
						else
							next_state = POS4;
						end
					POS5:
						begin
						if (RightIn)
							next_state = POS6;
						else if (LeftIn)
							next_state = POS4;
						else
							next_state = POS5;
						end
					POS6:
						begin
						if (RightIn)
							next_state = POS7;
						else if (LeftIn)
							next_state = POS5;
						else
							next_state = POS6;
						end
					POS7:
						begin
						if (RightIn)
							next_state = POS8;
						else if (LeftIn)
							next_state = POS6;
						else
							next_state = POS7;
						end
						
					// Rightmost state, can only go left
					POS8: next_state = LeftIn ? POS7 : POS8;
        endcase
    end // state_table
	 
	 always @(posedge Clock)
		begin
		if (!Reset)
			curr_state = POS4;
		else
			curr_state = next_state;
		end
		
	always @(posedge Clock)
		begin
		CurrState <= curr_state;
		end
	
endmodule
	
   
