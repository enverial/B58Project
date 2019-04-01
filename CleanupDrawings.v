module CharacterCleanup(Clock, Reset, State, HasMoved, XOut, YOut, Color);
  // Used to draw black where the character used to be so it doesn't leave an image
  input Clock, Reset, HasMoved;
  input [3:0] State;
  output [7:0] XOut;
  output [6:0] YOut;
