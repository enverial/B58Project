module GameState(TimerDone, StartGame, State, Clock);
  input TimerDone, StartGame, Clock;
  output reg State;
  reg [1:0] current_state, next_state;
  
  localparam
    GameDone = 0;
    GameDoneWait = 1;
    GameInProgress = 2;
    GameInProgressWait = 3;
  
  always @(*)
    begin
    // Game starts in GameDone state
    case (current_state)
      GameDone: next_state <= StartGame ? GameDoneWait : GameDone;
      GameDoneWait: next_state <= StartGame ? GameDoneWait : GameInProgress;
      GameInProgress: next_state <= TimerDone ? GameInProgressWait : GameInProgress;
      GameInProgressWait: next_state <= TimerDone ? GameInProgressWait : GameDone;
      endcase
    end
   
   always @(posedge Clock)
    begin
    current_state <= next_state;
    if (current_state == GameDone)
      State <= 0;
    else if (current_state == GameInProgress)
      State <= 1;
    end
endmodule
