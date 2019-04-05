// Part 2 skeleton

module project58
    (
        CLOCK_50,                        //    On Board 50 MHz
        // Your inputs and outputs here
        KEY,
        SW,
        // The ports below are for the VGA output.  Do not change.
        VGA_CLK,                           //    VGA Clock
        VGA_HS,                            //    VGA H_SYNC
        VGA_VS,                            //    VGA V_SYNC
        VGA_BLANK_N,                        //    VGA BLANK
        VGA_SYNC_N,                        //    VGA SYNC
        VGA_R,                           //    VGA Red[9:0]
        VGA_G,                             //    VGA Green[9:0]
        VGA_B,                           //    VGA Blue[9:0]
        HEX0,
        HEX1,
		  HEX2,
		  HEX3,
		  LEDR
    );
    input            CLOCK_50;                //    50 MHz
    input   [9:0]   SW;
    input   [3:0]   KEY;
	 output [7:0] LEDR;
    output   [6:0] HEX0;
    output   [6:0] HEX1;
	 output   [6:0] HEX2;
	 output   [6:0] HEX3;
    // Declare your inputs and outputs here
    // Do not change the following outputs
    output            VGA_CLK;                   //    VGA Clock
    output            VGA_HS;                    //    VGA H_SYNC
    output            VGA_VS;                    //    VGA V_SYNC
    output            VGA_BLANK_N;                //    VGA BLANK
    output            VGA_SYNC_N;                //    VGA SYNC
    output    [9:0]    VGA_R;                   //    VGA Red[9:0]
    output    [9:0]    VGA_G;                     //    VGA Green[9:0]
    output    [9:0]    VGA_B;                   //    VGA Blue[9:0]
   
    wire resetn;
    assign resetn = alwaysOne ;
   
    // Create the colour, x, y and writeEn wires that are inputs to the controller.
    reg [2:0] colour;// notice they were originally wire ,  I made them reg     edit:Mar20, 2:30am
    reg [6:0] x;
    reg [6:0] y;
    reg  writeEn;
   

    // Create an Instance of a VGA controller - there can be only one!
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
    vga_adapter VGA(
            .resetn(resetn),
            .clock(CLOCK_50),
            .colour(colour),
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
    reg alwaysOne = 1'b1;
    reg alwaysZero = 1'b0;
	reg speed1 = 2'b00;
	reg speed2 = 2'b01;
	reg speed3 = 2'b10;
	
	// score reset stuff
	
	wire [7:0] out;
	wire done;
	wire tick;
	
	RateDividerTimer rateDiv(.Clock(CLOCK_50), .OutTick(tick), .Reset(done));
	Timer timer(.Clock(CLOCK_50), .Enable(tick), .Done(done), .Out(out));
	hex_display hex3(.IN(out[7:4]), .OUT(HEX3));
	hex_display hex2(.IN(out[3:0]), .OUT(HEX2));
	
	
	
	// hit detection stuff
	
	wire [7:0] cur_score;
	score score1(.enable(isHit1), .reset(done), .colour(colour_fruit1),.scoreOut(cur_score));
	hex_display hex0(.IN(cur_score[3:0]), .OUT(HEX0));
	hex_display hex1(.IN(cur_score[7:4]), .OUT(HEX1));

    wire ld_x, ld_y;
    wire [3:0] stateNum;
    reg  [6:0] init_player_coord = 7'b0101111; // this is x coord
    wire [2:0] colour_player;
    wire [6:0] x_player;
    wire [6:0] y_player;
    wire writeEn_player;
    reg [25:0] counter_for_player = 26'b00000000000000000000000000;
    reg [6:0] init_y_p = 7'b1110000;
    reg [2:0] acolour_p = 3'b100;
	 

    // Instansiate datapath                             
    datapatha d0(.clk(CLOCK_50), .ld_x(ld_x), .ld_y(ld_y), .in(  init_player_coord), .reset_n(resetn), .x(x_player), .y(y_player), .colour(colour_player), .write(writeEn_player), .stateNum(stateNum), .init_y(init_y_p), .acolour(acolour_p));
   
    // Instansiate FSM control
    controla c0(.clk(CLOCK_50), .move_r(~KEY[0]), .move_l(~KEY[3]), .move_d(alwaysZero), .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x), .ld_y(ld_y), .stateNum(stateNum), .reset_game(reset_game), .dingding(counter_for_player), .how_fast(speed1));
	  
	  
    // --------------------------------------fruit movement starts here, for all fruits----------------------------------------------------------
    wire qconnection;
    wire ld_x_fruit0, ld_y_fruit0;
    wire [3:0] stateNum_fruit0;
    reg  [6:0] fruit0_coord = 7'b1100;
    wire [2:0] colour_fruit0;
    wire [6:0] x_fruit0;
    wire [6:0] y_fruit0;
    wire writeEn_fruit0;
    reg [25:0] counter_for_fruit0 = 26'b00000000000000000000000001;
    reg [6:0] init_y_c0 = 7'b0;
    reg [2:0] acolour_c0 = 8'b00000000;
	 
	 
    // Instansiate datapath                                
    datapath fruit_0_d(.clk(CLOCK_50), .ld_x(ld_x_fruit0), .ld_y(ld_y_fruit0), .in(fruit0_coord), .reset_n(resetn), .x(x_fruit0), .y(y_fruit0), .colour(colour_fruit0), .write(writeEn_fruit0), .stateNum(stateNum_fruit0),  .init_y(init_y_c0), .icolour(acolour_c0), .q(qconnection));
   
    // Instansiate FSM control
    control fruit_0_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit0), .ld_y(ld_y_fruit0), .stateNum(stateNum_fruit0), .reset_game(alwaysZero), .dingding(counter_for_fruit0), .how_fast(speed3), .q(qconnection));
    //The outputs are: x_fruit0, y_fruit0, colour_fruit0, writeEn_fruit0
    //fruit0 movement ends here----------------------------------------------------------------------------------------------------

	 wire qconnection1;
    wire ld_x_fruit1, ld_y_fruit1;
    wire [3:0] stateNum_fruit1;
    reg  [6:0] fruit1_coord = 7'b100100;
    wire [2:0] colour_fruit1;
    wire [6:0] x_fruit1;
    wire [6:0] y_fruit1;
    wire writeEn_fruit1;
    reg [25:0] counter_for_fruit1 = 26'b00000000000000000000000001;
    reg [6:0] init_y_c1 = 7'b0;
    reg [2:0] acolour_c1 = 8'b01110101;
	 wire isHit1;
	 
	 
    // Instansiate datapath                                
    datapath fruit_1_d(.clk(CLOCK_50), .ld_x(ld_x_fruit1), .ld_y(ld_y_fruit1), .in(fruit1_coord), .reset_n(resetn), .x(x_fruit1), .y(y_fruit1), .colour(colour_fruit1), .write(writeEn_fruit1), .stateNum(stateNum_fruit1),  .init_y(init_y_c1), .icolour(acolour_c1), .q(qconnection1));
   
    // Instansiate FSM control
    control fruit_1_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit1), .ld_y(ld_y_fruit1), .stateNum(stateNum_fruit1), .reset_game(alwaysZero), .dingding(counter_for_fruit1), .how_fast(speed3), .q(qconnection1));
	 
	 // instantiate hitdetector
	 hitDetector hd1( .clk(CLOCK_50), .fruitx(x_fruit1), .fruitx2(x_fruit3), .fruitx3(x_fruit4), .fruitx4(x_fruit5), .fruitx5(x_fruit6),.fruitx6(x_fruit7), .fruitx7(x_fruit8), .charx(x_player), .fruity(y_fruit1), .chary(y_player), .colour(colour_fruit1), .out(isHit1));
    //fruit1 movement ends here----------------------------------------------------------------------------------------------------
	 
	 wire qconnection2;
    wire ld_x_fruit2, ld_y_fruit2;
    wire [3:0] stateNum_fruit2;
    reg  [6:0] fruit2_coord = 7'b100100; // this is init x coord!!!
    wire [2:0] colour_fruit2;
    wire [6:0] x_fruit2;
    wire [6:0] y_fruit2;
    wire writeEn_fruit2;
    reg [25:0] counter_for_fruit2 = 26'b00000000000000000000000011;
    reg [6:0] init_y_c2 = 7'b0;
    reg [2:0] acolour_c2 = 8'b0101011;
    // Instansiate datapath                                
    datapath fruit_2_d(.clk(CLOCK_50), .ld_x(ld_x_fruit2), .ld_y(ld_y_fruit2), .in(fruit2_coord), .reset_n(resetn), .x(x_fruit2), .y(y_fruit2), .colour(colour_fruit2), .write(writeEn_fruit2), .stateNum(stateNum_fruit2),  .init_y(init_y_c2), .icolour(acolour_c2), .q(qconnection2));
   
    // Instansiate FSM control
    control fruit_2_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit2), .ld_y(ld_y_fruit2), .stateNum(stateNum_fruit2), .reset_game(alwaysZero), .dingding(counter_for_fruit2), .how_fast(speed3), .q(qconnection2));
    //fruit2 movement ends here-

	 wire qconnection3;
    wire ld_x_fruit3, ld_y_fruit3;
    wire [3:0] stateNum_fruit3;
    reg  [6:0] fruit3_coord = 7'b110000; // this is init x coord!!!
    wire [2:0] colour_fruit3;
    wire [6:0] x_fruit3;
    wire [6:0] y_fruit3;
    wire writeEn_fruit3;
    reg [25:0] counter_for_fruit3 = 26'b00000000000000000000000100;
    reg [6:0] init_y_c3 = 7'b0;
    reg [2:0] acolour_c3 = 8'b00001011;
	 wire isHit2;

    // Instansiate datapath                                
    datapath fruit_3_d(.clk(CLOCK_50), .ld_x(ld_x_fruit3), .ld_y(ld_y_fruit3), .in(fruit3_coord), .reset_n(resetn), .x(x_fruit3), .y(y_fruit3), .colour(colour_fruit3), .write(writeEn_fruit3), .stateNum(stateNum_fruit3),  .init_y(init_y_c3), .icolour(acolour_c3), .q(qconnection3));
   
    // Instansiate FSM control
    control fruit_3_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit3), .ld_y(ld_y_fruit3), .stateNum(stateNum_fruit3), .reset_game(alwaysZero), .dingding(counter_for_fruit3), .how_fast(speed3), .q(qconnection3));
    //fruit3 movement ends here----------------------------------------------------------------------------------------------------
    
	 wire qconnection4;
    wire ld_x_fruit4, ld_y_fruit4;
    wire [3:0] stateNum_fruit4;
    reg  [6:0] fruit4_coord = 7'b111100; // this is init x coord!!!
    wire [2:0] colour_fruit4;
    wire [6:0] x_fruit4;
    wire [6:0] y_fruit4;
    wire writeEn_fruit4;
    reg [25:0] counter_for_fruit4 = 26'b00000000000000000000000101;
    reg [6:0] init_y_c4 = 7'b0;
    reg [2:0] acolour_c4 = 8'b10010001;
    // Instansiate datapath                                
    datapath fruit_4_d(.clk(CLOCK_50), .ld_x(ld_x_fruit4), .ld_y(ld_y_fruit4), .in(fruit4_coord), .reset_n(resetn), .x(x_fruit4), .y(y_fruit4), .colour(colour_fruit4), .write(writeEn_fruit4), .stateNum(stateNum_fruit4),  .init_y(init_y_c4), .icolour(acolour_c4), .q(qconnection4));
   
    // Instansiate FSM control
    control fruit_4_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit4), .ld_y(ld_y_fruit4), .stateNum(stateNum_fruit4), .reset_game(alwaysZero), .dingding(counter_for_fruit4), .how_fast(speed3), .q(qconnection4));
    //fruit4 movement ends here----------------------------------------------------------------------------------------------------
     
    wire qconnection5;
    wire ld_x_fruit5, ld_y_fruit5;
    wire [3:0] stateNum_fruit5;
    reg  [6:0] fruit5_coord = 7'b1001000; // this is init x coord!!!
    wire [2:0] colour_fruit5;
    wire [6:0] x_fruit5;
    wire [6:0] y_fruit5;
    wire writeEn_fruit5;
    reg [25:0] counter_for_fruit5 = 26'b00000000000000000000000110;
    reg [6:0] init_y_c5 = 7'b0;
    reg [2:0] acolour_c5 = 8'b11111110;
    // Instansiate datapath                                
    datapath fruit_5_d(.clk(CLOCK_50), .ld_x(ld_x_fruit5), .ld_y(ld_y_fruit5), .in(fruit5_coord), .reset_n(resetn), .x(x_fruit5), .y(y_fruit5), .colour(colour_fruit5), .write(writeEn_fruit5), .stateNum(stateNum_fruit5),  .init_y(init_y_c5), .icolour(acolour_c5), .q(qconnection5));
   
    // Instansiate FSM control
    control fruit_5_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwayZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit5), .ld_y(ld_y_fruit5), .stateNum(stateNum_fruit5), .reset_game(alwaysZero), .dingding(counter_for_fruit5), .how_fast(speed3), .q(qconnection5));
    //fruit5 movement ends here----------------------------------------------------------------------------------------------------
     
    wire qconnection6;
    wire ld_x_fruit6, ld_y_fruit6;
    wire [3:0] stateNum_fruit6;
    reg  [6:0] fruit6_coord = 7'b1010100; // this is init x coord!!!
    wire [2:0] colour_fruit6;
    wire [6:0] x_fruit6;
    wire [6:0] y_fruit6;
    wire writeEn_fruit6;
    reg [25:0] counter_for_fruit6 = 26'b00000000000000000000000111;
    reg [6:0] init_y_c6 = 7'b0;
    reg [2:0] acolour_c6 = 8'b01001011;
    // Instansiate datapath                                
    datapath fruit_6_d(.clk(CLOCK_50), .ld_x(ld_x_fruit6), .ld_y(ld_y_fruit6), .in(fruit6_coord), .reset_n(resetn), .x(x_fruit6), .y(y_fruit6), .colour(colour_fruit6), .write(writeEn_fruit6), .stateNum(stateNum_fruit6),  .init_y(init_y_c6), .icolour(acolour_c6), .q(qconnection6));
   
    // Instansiate FSM control
    control fruit_6_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit6), .ld_y(ld_y_fruit6), .stateNum(stateNum_fruit6), .reset_game(alwaysZero), .dingding(counter_for_fruit6), .how_fast(speed3), .q(qconnection6));
    //fruit6 movement ends here----------------------------------------------------------------------------------------------------
     
	 wire qconnection7;
    wire ld_x_fruit7, ld_y_fruit7;
    wire [3:0] stateNum_fruit7;
    reg  [6:0] fruit7_coord = 7'b1100000; // this is init x coord!!!
    wire [2:0] colour_fruit7;
    wire [6:0] x_fruit7;
    wire [6:0] y_fruit7;
    wire writeEn_fruit7;
    reg [25:0] counter_for_fruit7 = 26'b00000000000000000000001000;
    reg [6:0] init_y_c7 = 7'b0;
    reg [2:0] acolour_c7 = 8'b11011101;
    // Instansiate datapath                                
    datapath fruit_7_d(.clk(CLOCK_50), .ld_x(ld_x_fruit7), .ld_y(ld_y_fruit7), .in(fruit7_coord), .reset_n(resetn), .x(x_fruit7), .y(y_fruit7), .colour(colour_fruit7), .write(writeEn_fruit7), .stateNum(stateNum_fruit7),  .init_y(init_y_c7), .icolour(acolour_c7), .q(qconnection7));
   
    // Instansiate FSM control
    control fruit_7_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit7), .ld_y(ld_y_fruit7), .stateNum(stateNum_fruit7), .reset_game(alwaysZero), .dingding(counter_for_fruit7), .how_fast(speed3), .q(qconnection7));
    //fruit7 movement ends here----------------------------------------------------------------------------------------------------
     
	 wire qconnection8;
    wire ld_x_fruit8, ld_y_fruit8;
    wire [3:0] stateNum_fruit8;
    reg  [6:0] fruit8_coord = 7'b1101100; // this is init x coord!!!
    wire [2:0] colour_fruit8;
    wire [6:0] x_fruit8;
    wire [6:0] y_fruit8;
    wire writeEn_fruit8;
    reg [25:0] counter_for_fruit8 = 26'b00000000000000000000001001;
    reg [6:0] init_y_c8 = 7'b0;
    reg [2:0] acolour_c8 = 8'b00110110;
    // Instansiate datapath                                
    datapath fruit_8_d(.clk(CLOCK_50), .ld_x(ld_x_fruit8), .ld_y(ld_y_fruit8), .in(fruit8_coord), .reset_n(resetn), .x(x_fruit8), .y(y_fruit8), .colour(colour_fruit8), .write(writeEn_fruit8), .stateNum(stateNum_fruit8),  .init_y(init_y_c8), .icolour(acolour_c8), .q(qconnection8));
   
    // Instansiate FSM control
    control fruit_8_c(.clk(CLOCK_50), .move_r(alwaysZero), .move_l(alwaysZero), .move_d(alwaysOne),  .move_u(alwaysZero), .reset_n(resetn), .ld_x(ld_x_fruit8), .ld_y(ld_y_fruit8), .stateNum(stateNum_fruit8), .reset_game(alwaysZero), .dingding(counter_for_fruit8), .how_fast(speed3), .q(qconnection8));
    //fruit8 movement ends here----------------------------------------------------------------------------------------------------
     
     
    //The following for processing player movement and fruit movement (make sure that only one of play or the fruit can move on the same clock cycle)
    // If player is moving ,then link the vga to the player, if the fruit is moving, than link the vga to the fruit
    // If both of them are moving in the same clock cycle (very unlikely), then move the player
    // edited: mar 20, 5pmreset_n
    // Notice: writeEn_player is write Enable for player; writeEn_fruit0 is write enable for fruit_0
    // The following is for choosing to print the player movement or to print the fruit movement
   
    always @(posedge CLOCK_50)
    begin
	      if(writeEn_player) 
            begin
                writeEn <= writeEn_player;   //  Do I use   <=   or   =   ????? writeEn, x, y and colour are originally type wire, but I need to make them type reg???  ????????????????????????????????
                x <= x_player;       
                y <= y_player;
                colour = colour_player; // Notice: I made the following variable type reg: writeEn, x, y, colour
            end
        else if (writeEn_fruit0)    // if player isnt moving, then let the fruit move
            begin
                writeEn <= writeEn_fruit0;    
                x <= x_fruit0;                       
                y <= y_fruit0;
                colour <= colour_fruit0;
            end
		  else if (writeEn_fruit1) 
            begin
                writeEn <= writeEn_fruit1;    
                x <= x_fruit1;                       
                y <= y_fruit1;
                colour <= colour_fruit1;
            end   
        else if (writeEn_fruit2)   
            begin
                writeEn <= writeEn_fruit2;    
                x <= x_fruit2;                       
                y <= y_fruit2;
                colour <= colour_fruit2;
            end   
        else if (writeEn_fruit3)   
            begin
                writeEn <= writeEn_fruit3;    
                x <= x_fruit3;                       
                y <= y_fruit3;
                colour <= colour_fruit3;
            end   
        else if (writeEn_fruit4)  
            begin
                writeEn <= writeEn_fruit4;    
                x <= x_fruit4;                       
                y <= y_fruit4;
                colour <= colour_fruit4;
            end   
        else if (writeEn_fruit5)   
            begin
                writeEn <= writeEn_fruit5;    
                x <= x_fruit5;                       
                y <= y_fruit5;
                colour <= colour_fruit5;
            end   
        else if (writeEn_fruit6)   
            begin
                writeEn <= writeEn_fruit6;    
                x <= x_fruit6;                       
                y <= y_fruit6;
                colour <= colour_fruit6;
            end   
        else if (writeEn_fruit7)  
            begin
                writeEn <= writeEn_fruit7;    
                x <= x_fruit7;                       
                y <= y_fruit7;
                colour <= colour_fruit7;
            end   
        else if (writeEn_fruit8)   
            begin
                writeEn <= writeEn_fruit8;    
                x <= x_fruit8;                       
                y <= y_fruit8;
                colour <= colour_fruit8;
            end     
	 end

endmodule

module controla(clk, move_r, move_l, move_d, move_u, reset_n, ld_x, ld_y, stateNum, reset_game, dingding, how_fast);
    input [25:0] dingding; // dingding is the counter! It counts like this: Ding!!! Ding!!! Ding!!! Ding!!! Ding!!!
    input reset_game;
    input clk, move_r, move_l, move_d, move_u, reset_n;
	 input [1:0] how_fast;
    output reg ld_y, ld_x;
    reg [3:0] curr, next;
    output reg [3:0] stateNum;
    localparam    S_CLEAR    = 4'b0000;
    localparam S_LOAD_X    = 4'b0001;
    localparam S_WAIT_Y    = 4'b0010;
    localparam S_LOAD_Y    = 4'b0011;
   
    localparam    wait_input    = 4'b0100;
    localparam    clear_all    = 4'b0101;
    localparam    print_right    = 4'b0110;
    localparam    print_left    = 4'b0111;
    localparam    print_down    = 4'b1000;
    localparam    print_up    = 4'b1001;
    localparam  temp_selecting_state = 4'b1010;
    localparam after_drawing = 4'b1011;
    localparam cleanUp = 4'b1100;
    wire [26:0] press_now;   
    wire [26:0] press_now_for_fruit;   
    wire result_press_now;
	 reg [25:0] speed;
    //wire result_for_fruit;
    
	 always @(*)
	 begin
		if (how_fast == 2'b00)
		   speed <= 26'b0101111101011110000100;

		else if (how_fast == 2'b01)
		   speed <= 26'b010111110101111000010;
		else
		   speed <= 26'b01011111010111100001;
	 end
	 RateDivider player_counter1(clk, press_now, reset_n, speed);
	 
    assign result_press_now = (press_now == dingding) ? 1 : 0;
   
    always @(*)
    begin: state_table
        case (curr)
            S_CLEAR: next = S_LOAD_X ;
            S_LOAD_X: next = S_WAIT_Y;
            S_WAIT_Y: next = S_LOAD_Y;

            S_LOAD_Y: next = temp_selecting_state; // the next line is edited on Mar 27
            temp_selecting_state: next = reset_game ? cleanUp : ( ((move_r || move_l || move_d || move_u) && result_press_now) ? clear_all : S_LOAD_Y );
           
            clear_all:
                begin
                    if(move_r)  // is this how to connect two wires ?????????????????????????????????????????????????????????
                        next <= print_right;
                    else if (move_l)    // if player isnt moving, then let the fruit move
                        next <= print_left;
                    else if (move_d)   // if player isnt moving, then let the fruit move
                        next <= print_down;
                    else if (move_u)   // if player isnt moving, then let the fruit move
                        next <= print_up;
                end
            cleanUp: next = S_CLEAR;
            //
            print_right: next = reset_game ? S_LOAD_Y : after_drawing;
            print_left: next =  reset_game ? S_LOAD_Y : after_drawing;
            print_down: next = reset_game ? S_LOAD_Y : after_drawing;
            print_up: next = reset_game ? S_LOAD_Y : after_drawing;
            after_drawing: next= temp_selecting_state;
           
        default: next = S_CLEAR;
        endcase
    end

    always@(*)
    begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
        //write = 1'b0;
        stateNum = 4'b0000;
        case (curr)
            S_LOAD_X: begin
                ld_x = 1'b1;
                end
            S_LOAD_Y: begin
                ld_y = 1'b1;
                end
            cleanUp: begin // this IS suppose to be the same as clear all (edited on mar27)
                stateNum = 4'b0001;
                ld_y = 1'b0;
                //write = 1'b1;
                end
            clear_all: begin
                stateNum = 4'b0001;
                ld_y = 1'b0;
                //write = 1'b1;
                end
           
            print_right: begin
                stateNum = 4'b0100;
                ld_y = 1'b0;
                //write = 1'b1;
                end
           
            print_down: begin
                stateNum = 4'b0011;
                ld_y = 1'b0;
                //write = 1'b1;
                end
               
            print_left: begin
                stateNum = 4'b0010;
                ld_y = 1'b0;
   
                //write = 1'b1;
                end
               
            print_up: begin
                stateNum = 4'b1001;
                ld_y = 1'b0;
   
                //write = 1'b1;
                end
               
            after_drawing: begin
                stateNum = 4'b1000;
                end
           
           
        endcase
    end

    always @(posedge clk)
    begin: states
        if(!reset_n)
            curr <= S_LOAD_X;
        else
            curr <= next;
    end

endmodule

module datapatha(clk, ld_x, ld_y, in, reset_n, x, y, colour, stateNum, write, init_y, acolour);
    input clk;
    input [6:0] in;
    input [6:0] init_y;
    input [2:0] acolour;
    input ld_x, ld_y;
    input reset_n;
    output reg [2:0] colour;
    output reg write;
    output reg [6:0] y;
    output reg [6:0] x;
    input [3:0] stateNum;

    always @(posedge clk)
    begin
        if(!reset_n)
        begin
            x <= 6'b000000;
            y <= 6'b000000;
            colour <= 3'b000;
        end
        else
        begin
            if(ld_x)
                begin
                    x[6:0] <= in;
                    y <= init_y;
                    write <= 1'b0;
                end
            else if(ld_y)
                begin
                    write <= 1'b0;
                end
               
            // The following is for clearing
            else if(stateNum == 4'b0001)
                begin
                    colour <= 3'b000;
                    write <= 1'b1;
                end
               
            // The following is for moving right
            else if(stateNum == 4'b0100)   
                begin
               
                    x[6:0] <= x + 6'b000001;
                    colour <= acolour;
                    write <= 1'b1;
                end
               
            // The following is for moving left
            else if(stateNum == 4'b0010)   
                begin
               
                    x[6:0] <= x - 6'b000001;
                    colour <= acolour;
                    write <= 1'b1;
                end
               
            // The following is for moving down
            else if(stateNum == 4'b0011)
					 begin
							begin
							if (x != 7'b1110000)
								begin
						  
								  y[6:0] <= y + 6'b000001;
								  colour <= acolour;
								  write <= 1'b1;
								end
							else
									write <= 1'b0;
							
							end
                end
               
            else if(stateNum == 4'b1001)//for moving up
                begin
               
                    y[6:0] <= y - 6'b000001;
                    colour <= acolour;
                    write <= 1'b1;
                end
               
            else if(stateNum == 4'b1000)//after drawing
                begin
                    write <= 1'b0;
                end
               
        end
    end
   
endmodule


module control(clk, move_r, move_l, move_d, move_u, reset_n, ld_x, ld_y, stateNum, reset_game, dingding, how_fast, q);
    input [25:0] dingding; // dingding is the counter! It counts like this: Ding!!! Ding!!! Ding!!! Ding!!! Ding!!!
    input reset_game;
    input clk, move_r, move_l, move_d, move_u, reset_n;
	 input [1:0] how_fast;
    output reg ld_y, ld_x;
    reg [3:0] curr, next;
    output reg [3:0] stateNum;
    localparam    S_CLEAR    = 4'b0000;
    localparam S_LOAD_X    = 4'b0001;
    localparam S_WAIT_Y    = 4'b0010;
    localparam S_LOAD_Y    = 4'b0011;
   
    localparam    wait_input    = 4'b0100;
    localparam    clear_all    = 4'b0101;
    localparam    print_right    = 4'b0110;
    localparam    print_left    = 4'b0111;
    localparam    print_down    = 4'b1000;
    localparam    print_up    = 4'b1001;
    localparam  temp_selecting_state = 4'b1010;
    localparam after_drawing = 4'b1011;
    localparam cleanUp =	 4'b1100;
	 localparam done = 4'b1101;
	 input q;
	 
    wire [26:0] press_now;   
    wire [26:0] press_now_for_fruit;   
    wire result_press_now;
	 reg [25:0] speed;
    //wire result_for_fruit;
    
	 always @(*)
	 begin
		if (how_fast == 2'b00)
		   speed <= 26'b0101111101011110000100;

		else if (how_fast == 2'b01)
		   speed <= 26'b010111110101111000010;
		else
		   speed <= 26'b01011111010111100001;
	 end
	 RateDivider player_counter1(clk, press_now, reset_n, speed);
	 
    assign result_press_now = (press_now == dingding) ? 1 : 0;
   
    always @(*)
    begin: state_table
        case (curr)
            S_CLEAR: next = S_LOAD_X ;
            S_LOAD_X: next = S_WAIT_Y;
            S_WAIT_Y: next = S_LOAD_Y;
            S_LOAD_Y: next = temp_selecting_state;
				// the next line is edited on Mar 27
            temp_selecting_state: next = reset_game ? cleanUp : ( ((move_r || move_l || move_d || move_u) && result_press_now) ? clear_all : S_LOAD_Y );
           
            clear_all:
                begin
                    if(move_r)  // is this how to connect two wires ?????????????????????????????????????????????????????????
                        next <= print_right;
                    else if (move_l)    // if player isnt moving, then let the fruit move
                        next <= print_left;
                    else if (move_d)   // if player isnt moving, then let the fruit move
                        next <= print_down;
                    else if (move_u)   // if player isnt moving, then let the fruit move
                        next <= print_up;
                end
            cleanUp: next = S_CLEAR;
            //
            print_right: next = reset_game ? S_LOAD_Y : after_drawing;
            print_left: next =  reset_game ? S_LOAD_Y : after_drawing;
            print_down: next = reset_game ? S_LOAD_Y : after_drawing;
            print_up: next = reset_game ? S_LOAD_Y : after_drawing;
            after_drawing:next =  q ? done: temp_selecting_state;
				done: next = temp_selecting_state;
           
        default: next = S_CLEAR;
        endcase
    end

    always@(*)
    begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
        //write = 1'b0;
        stateNum = 4'b0000;
        case (curr)
            S_LOAD_X: begin
                ld_x = 1'b1;
                end
            S_LOAD_Y: begin
                ld_y = 1'b1;
                end
            cleanUp: begin // this IS suppose to be the same as clear all (edited on mar27)
                stateNum = 4'b0001;
                ld_y = 1'b0;
                //write = 1'b1;
                end
            clear_all: begin
                stateNum = 4'b0001;
                ld_y = 1'b0;
                //write = 1'b1;
                end
           
            print_right: begin
                stateNum = 4'b0100;
                ld_y = 1'b0;
                //write = 1'b1;
                end
           
            print_down: begin
                stateNum = 4'b0011;
                ld_y = 1'b0;
                //write = 1'b1;
                end
               
            print_left: begin
                stateNum = 4'b0010;
                ld_y = 1'b0;
   
                //write = 1'b1;
                end
               
            print_up: begin
                stateNum = 4'b1001;
                ld_y = 1'b0;
   
                //write = 1'b1;
                end
               
            after_drawing: begin
                stateNum = 4'b1000;
                end
            done: begin
			       stateNum = 4'b1101;
					end 
           
        endcase
    end

    always @(posedge clk)
    begin: states
        if(!reset_n)
            curr <= S_LOAD_X;
        else
            curr <= next;
    end

endmodule

module datapath(clk, ld_x, ld_y, in, reset_n, x, y, colour, stateNum, write, init_y, icolour, q);
    input clk;
    input [6:0] in;
    input [6:0] init_y;
    input [7:0] icolour;
    input ld_x, ld_y;
    input reset_n;
    output reg [2:0] colour;
    output reg write;
    output reg [6:0] y;
    output reg [6:0] x;
    input [3:0] stateNum;
	 output reg q;
	 wire [7:0] acolour;
	 reg shift;
	 reg load;
	 reg alwaysOne = 1'b1;
	 initial
	 begin
	     shift = 1'b0;
		  load = 1'b0;
	 end
	 
	 // rng for color
	 	LFSR rightShifter ( 
		.LoadVal(icolour),
		.Load_n(load),
		.ShiftRight(shift),
		.clock(clk),
		.reset_n(alwaysOne),
		.q(acolour)
	);
	

	 
    always @(posedge clk)
    begin
        if(!reset_n)
        begin
            x <= 6'b000000;
            y <= 6'b000000;
            colour <= 3'b000;
        end
        else
        begin
            if(ld_x)
                begin
                    x[6:0] <= in;
                    y <= init_y;
                    write <= 1'b0;
						  load <= 1'b1;
                end
            else if(ld_y)
                begin
                    write <= 1'b0;
					 end
            // The following is for clearing
            else if(stateNum == 4'b0001)
                begin
                    colour <= 3'b000;
                    write <= 1'b1;
                end
               
            // The following is for moving right
            else if(stateNum == 4'b0100)   
                begin
               
                    x[6:0] <= x + 6'b000001;
                    colour <= acolour[2:0];
                    write <= 1'b1;
                end
               
            // The following is for moving left
            else if(stateNum == 4'b0010)   
                begin
               
                    x[6:0] <= x - 6'b000001;
                    colour <= acolour[2:0];
                    write <= 1'b1;
                end
               
            // The following is for moving down
            else if(stateNum == 4'b0011)
					 begin
							begin
							if (x != 7'b1110000)
								begin
						  
								  y[6:0] <= y + 6'b000001;
								  colour <= acolour[2:0];
								  write <= 1'b1;
								end
							else
									write <= 1'b0;
							
							end
							if (y == 7'b1111110) begin
						      q <= 1'b1;
								shift <= 1'b1;
						   end
						  else
						  begin
						      q <= 1'b0;
								shift <= 1'b0;
						  end
                end
               
            else if(stateNum == 4'b1001)//for moving up
                begin
               
                    y[6:0] <= y - 6'b000001;
                    colour <= acolour[2:0];
                    write <= 1'b1;
                end
               
            else if(stateNum == 4'b1000)//after drawing
                begin
                    write <= 1'b0;
                end
				else if(stateNum == 4'b1101) // changing color
				    begin
					     q <= 1'b0;
						  shift <= 1'b0;
					end
        end
    end
   
endmodule
   
   
module RateDivider (clock, q, Clear_b, how_speedy);  // Note that fruit is 4 times faster than the player
    input [0:0] clock;
    input [0:0] Clear_b;
	input [25:0] how_speedy;
    output reg [26:0] q; // declare q
    //wire [27:0] d; // declare d, not needed
    always@(posedge clock)   // triggered every time clock rises
    begin
    // else if (ParLoad == 1'b1) // Check if parallel load, not needed!!!!
    //        q <= d; // load d
        if (q == how_speedy) // when q is the maximum value for the counter, this number is 50 million - 1
            q <= 0; // q reset to 0
        else if (clock == 1'b1) // increment q only when Enable is 1
            q <= q + 1'b1;  // increment q
    //    q <= q - 1'b1;  // decrement q
    end
endmodule

