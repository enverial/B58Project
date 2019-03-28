module test1 (SW, LEDR);
    input SW[15:0];
	output LEDR;
	
	hitDetector hd(
		.fruitx(SW[3:0]),
		.fruity(SW[11:8]),
		.charx(SW[7:4]),
		.chary(SW[15:12]),
		.out(LEDR)
	);
	
endmodule


module hitDetector(fruitx, fruity, charx, chary, out);
    input [3:0] fruitx;
	input [3:0] fruity;
	input [3:0] charx;
	input [3:0] chary;
	output out;
	assign out = (fruitx == charx) && (fruity == chary);
endmodule