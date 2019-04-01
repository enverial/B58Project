module CharacterFSM(LeftIn, RightIn, CurrState, Clock, Reset);
	input LeftIn, RightIn, Clock, Reset;
	output [3:0] reg CurrState;
   	reg [3:0] current_state, next_state; 
   
	// Character will have 4 positions to move between, 0 at the left side
	// To 3 at the right side of the screen
	// Transition states in between each movement
	localparam  
		POS0 = 4'd0,
		T01 = 4'd4,
		T10 = 4'd5,
	   	POS1 = 4'd1,
		T12 = 4'd6,
		T21 = 4'd7,
	   	POS2 = 4'd2,
		T23 = 4'd8,
		T32 = 4'd9,
	   	POS3 = 4'd3;
	
	wire LeftDebounce, RightDebounce;
	
    	// LeftIn and RightIn inputs come from keys, need to use Debouncer and rate controller to stabalize
	DeBounce(Clock, Reset, LeftIn, LeftDebounce);
	DeBounce(Clock, Reset, RightIn, RightDebounce);
	
					 
    // Next state logic aka our state table
    always@(*)
    begin: 
        case (current_state)
	// Leftmost state, can only go right
	POS0: next_state = RightDebounce ? T01 : POS0;
	T01: next_state = RightDebounce ? T01 : POS1;
	T10: next_state = LeftDebounce ? T10 : POS0;
	POS1:
		begin
			if (RightDebounce)
				next_state = T12;
			else if (LeftDebounce)
				next_state = T10;
			else
				next_state = POS1;
		end
	T12: next_state = RightDebounce ? T12 : POS2;
	T21: next_state = LeftDebounce ? T21 : POS1;
	POS2:
		begin
		if (RightDebounce)
			next_state = T23;
		else if (LeftDebounce)
			next_state = T21;
		else
			next_state = POS2;
		end
	T23: next_state = RightDebounce ? T23 : POS3;
	T32: next_state = LeftDebounce ? T32 : POS2;
	
	// Rightmost state, can only go left
	POS3: next_state = LeftDebounce ? T32 : POS3;
        endcase
    end // state_table
	 
	 always @(posedge Clock)
		begin
		if (!Reset)
			curr_state = POS0;
		else
			curr_state = next_state;
		end
		
	always @(posedge Clock)
		begin
		CurrState <= curr_state;
		end
	
endmodule
	
   
