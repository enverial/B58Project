module B58Project(SW, KEY, LEDR, CLOCK_50, HEX0, HEX1);
	input [17:0] SW;
	input CLOCK_50;
	output [5:0] LEDR;
	output [6:0] HEX0, HEX1;
  
  wire Reset;
	assign Reset = SW[17];
  
  // Timer Section --------------------------------------------------------------------------------------------------------------
  wire EnableTick, TimerDone;
	wire [3:0] Ones;
	wire [3:0] Tens;
	wire [7:0] Out;
  
  // Used to convert 50MHZ clock signal to 1Hz
	RateDivider(CLOCK_50, EnableTick, Reset);
	
	// Takes enable signal from Rate Divider and counts down from a specific value.
	// Sends done signal through Done when complete, counts down when reset is not low
	Timer(CLOCK_50, EnableTick, TimerDone, Out, Reset);
  
  // Shifts output of Timer so that HEX Displays remain accurate
	ShiftRegister(Out, Ones, Tens, CLOCK_50, Reset); 
	
	// Hex displays digits based on timer module
	HexDisplay ones(Ones, HEX0, CLOCK_50);
	HexDisplay tens(Tens, HEX1, CLOCK_50);
	
	// Game state determines if fruit can be drawn or not
	GameState(TimerDone, StartGame, State, CLOCK_50);
  
  // Character Section --------------------------------------------------------------------------------------------------------
  wire LeftIn, RightIn;
  assign LeftIn = ~Key[1];
  assign RightIn = ~Key[0];
  
  wire [3:0] CurrState, PrevState;
  
  // CharacterFSM determines which position the character is in based on left and right key presses
  // CurrState sends information to DrawCharacter to draw where the character is
  // PrevState sends information to EraseCharacter to erase where the character was
  CharacterFSM(LeftIn, RightIn, CurrState, PrevState, CLOCK_50, Reset, DoneDrawing);
  
  // Draw character and Erase character work in tandem. Draw creates character in new position, erase erases old position
  // So only one character appears on screen
  DrawCharacter(CurrState, CLOCK_50, Reset, XOut, YOut, DoneDrawing, Color);
  EraseCharacter(PrevState, CLOCK_50, Reset, XOut, YOut, DoneDrawing, Color);

  // Fruit Section -------------------------------------------------------------------------------------------------------------------------------
	// Determines if a fruit was caught if its X and Y match CurrState of character
	hitDetector(CLOCK_50, FruitX, FruitY, CurrState, Colour, Out);
	score(Enable, Colour, Enable2, Colour2, ScoreOut);
		    
		    
