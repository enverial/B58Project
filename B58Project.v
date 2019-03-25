// Part 2 skeleton taken from Lab6
module B58Project
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input	  CLOCK_50;				//	50 MHz
	input   [17:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = SW[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	wire LeftIn, RightIn, DoneDrawing;
	assign LeftIn = KEY[0];
	assign RightIn = KEY[1];
	
	wire [3:0] CurrState;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(KEY[2]),
			.clock(CLOCK_50),
			.colour(3'b011),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
    DrawCharacter(CurrState, CLOCK_50, resetn, x, y, writeEn, DoneDrawing);

    // Instansiate FSM control
    CharacterFSM charfsm(~LeftIn, ~RightIn, CurrState, CLOCK_50, resetn, writeEn, ~SW[17], DoneDrawing);
    
endmodule


module DrawCharacter(CurrState, Clock, Reset, XOut, YOut, WriteEn, DoneDrawing);
	input [4:0] CurrState;
	input Clock, Reset, WriteEn;
	
	output reg DoneDrawing;
	
	// X and Y coordinates mark top left corner
	// Character is 5 x 9 rectangle
	output reg [7:0] XOut;
	output reg [6:0] YOut;
	
	reg [6:0] Counter;
	reg [3:0] YCounter; 
	reg [2:0] XCounter;
	
	always @(*)
		begin
		XCounter <= Counter[2:0];
		YCounter <= Counter[6:3];
		end
		
	localparam  POS0 = 5'd0,
				   POS1 = 5'd1,
				   POS2 = 5'd2,
				   POS3 = 5'd3,
				   POS4 = 5'd4,
				   POS5 = 5'd5,
				   POS6 = 5'd6,
				   POS7 = 5'd7,
				   POS8 = 5'd8;
	
	always @(posedge Clock)
		begin
			case (CurrState)
			POS0:
				begin
				XOut <= 8'd6 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			POS1:
				begin
				XOut <= 8'd24 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			POS2:
				begin
				XOut <= 8'd42 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			POS3:
				begin
				XOut <= 8'd60 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			POS4:
				begin
				XOut <= 8'd78 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			POS5:
				begin
				XOut <= 8'd96 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			POS6:
				begin
				XOut <= 8'd114 + XCounter;
				YOut <= 7'd106 + YCounter;
				end			
			POS7:
				begin
				XOut <= 8'd132 + XCounter;
				YOut <= 7'd106 + YCounter;
				end	
			POS8:
				begin
				XOut <= 8'd150 + XCounter;
				YOut <= 7'd106 + YCounter;
				end
			endcase
		end
			
	always @(posedge Clock)
	begin
		if (!Reset)
			begin
			Counter <= 0;
			DoneDrawing <= 0;
			end		
			
		else if (Counter == 7'd45)
			begin
			Counter <= 7'd0;
			DoneDrawing <= 1;
			end
			
		else if (WriteEn)
			Counter <= Counter + 1;
	end
endmodule 


module CharacterFSM(LeftIn, RightIn, CurrState, Clock, Reset, WriteEn, Go, DoneDrawing);
	input LeftIn, RightIn, Clock, Reset, Go, DoneDrawing;
	output reg [4:0] CurrState;
	output reg WriteEn;
   reg [4:0] wait_trans, current_state, next_state; 
   
	localparam  Initial = 5'd0,
					POS0 = 5'd10,
				   POS1 = 5'd1,			
				   POS2 = 5'd2,
				   POS3 = 5'd3,
				   POS4 = 5'd4,
				   POS5 = 5'd5,
				   POS6 = 5'd6,
				   POS7 = 5'd7,
				   POS8 = 5'd8,
					WAIT = 5'd9;
	
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
				wait_trans = WAIT;
            case (current_state)
					Initial: 
						begin
						next_state = Go ? POS0 : Initial;
						end
						
					// Leftmost state, can only go right
					POS0:
						begin
						next_state = RightIn ? POS1 : POS0;
						end
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
					
					WAIT:
						begin
						if (DoneDrawing == 1)
							wait_trans = next_state;
						end
        endcase
    end // state_table
	 
	 always @(posedge Clock)
		begin enable_signals:
		if (current_state != Initial)
			WriteEn = 1'b1;
			
		if (current_state != Initial && current_state != WAIT)
			CurrState <= current_state;
			
		else
			WriteEn = 1'b0;
		end
	
	always @(*)
	begin
		if (!Reset)
			current_state = Initial;
		else
			current_state = wait_trans;
	end
endmodule
