//EECS 3201 Final Project: Morse Code Display: Visual and Audio
//Group Member:
//Jaideep Singh 218472241
//Bhavneet kaur 218501361

module Project_3201MorseCode(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, IO12, KEY,CLOCK_50, LEDR);

input [4:0] SW;//the five input switches that determine the letter to be represented
input [1:0] KEY;//the buttons that will allow the circuit to transmit the morse code to external led and buzzer 
					//and stopping the transmission
input CLOCK_50; //the clock that will run to allow led to blink
output [0:0] LEDR; //the de10 board's led that will be used for debugging
//the hex displays that will display the alphabetical position and morse representation of each letter
output wire [7:0] HEX0;
output wire [7:0] HEX1;
output wire [7:0] HEX2;
output wire [7:0] HEX3; 
output wire [7:0] HEX4; 
output wire [7:0] HEX5;
output IO12; //the transmitted signal is outputted to a breadboard via Arduino pin 12


reg S0, S1, S2, S3, S4, ltr0; //these registers are used to calculate the decimal ascii of the letter
reg [7:0] parts0;
reg [7:0] parts1; 
reg [7:0] parts2; 
reg [7:0] parts3; 
reg [7:0] parts4; 
reg [7:0] parts5;

assign HEX0 = parts0;
assign HEX1 = parts1;
assign HEX2 = parts2;
assign HEX3 = parts3;
assign HEX4 = parts4;
assign HEX5 = parts5;


wire [3:0] length; // number of ones represent length of morse code
	wire [3:0] morse; // morse code translation
	wire able; // enables the clock signal every .5 seconds
	
translateMorse mT (SW[4:0], morse[3:0], length[3:0]);
clk_xx (CLOCK_50, able);
fsm (KEY[1], KEY[0], morse[3:0], length[3:0], CLOCK_50, able, IO12, LEDR[0]);

//assigning the letter parameters based on the switch positions
parameter A = 5'b00001, B = 5'b00010, C = 5'b00011, D = 5'b00100;
	parameter E = 5'b00101, F = 5'b00110, G = 5'b00111, H = 5'b01000;
	parameter I = 5'b01001, J = 5'b01010, K = 5'b01011, L = 5'b01100;
	parameter M = 5'b01101, N = 5'b01110, O = 5'b01111, P = 5'b10000;
	parameter Q = 5'b10001, R = 5'b10010, S = 5'b10011, T = 5'b10100;
	parameter U = 5'b10101, V = 5'b10110, W = 5'b10111, X = 5'b11000;
	parameter Y = 5'b11001, Z = 5'b11010;



always @(SW[4:0])
	begin
	
	ltr0 = 64 + S4 + S3 + S2 + S1 + S0;
		
		case({SW[0]})
		1'b0: S0 = 0;
		1'b1: S0 = 1;
		endcase
		
		case({SW[1]})
		1'b0: S1 = 0;
		1'b1: S1 = 2;
		endcase
		
		case({SW[2]})
		1'b0: S2 = 0;
		1'b1: S2 = 4;
		endcase
		
		case({SW[3]})
		1'b0: S3 = 0;
		1'b1: S3 = 8;
		endcase
		
		case({SW[4]})
		1'b0: S4 = 0;
		1'b1: S4 = 16;
		endcase
		
		 case({SW[4:0]})
        5'b00001: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b11110111; parts3 = 8'b01111111; parts4 = 8'b11111001; parts5 = 8'b11000000; end // A
        5'b00010: begin parts0 = 8'b01111111; parts1 = 8'b01111111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b10100100; parts5 = 8'b11000000; end // B
        5'b00011: begin parts0 = 8'b01111111; parts1 = 8'b11110111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b10110000; parts5 = 8'b11000000; end // C
        5'b00100: begin parts0 = 8'b11111111; parts1 = 8'b01111111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b10011001; parts5 = 8'b11000000; end // D
        5'b00101: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b11111111; parts3 = 8'b01111111; parts4 = 8'b10010010; parts5 = 8'b11000000; end // E
        5'b00110: begin parts0 = 8'b01111111; parts1 = 8'b11110111; parts2 = 8'b01111111; parts3 = 8'b01111111; parts4 = 8'b10000010; parts5 = 8'b11000000; end // F
        5'b00111: begin parts0 = 8'b11111111; parts1 = 8'b01111111; parts2 = 8'b11110111; parts3 = 8'b11110111; parts4 = 8'b11111000; parts5 = 8'b11000000; end // G
        5'b01000: begin parts0 = 8'b01111111; parts1 = 8'b01111111; parts2 = 8'b01111111; parts3 = 8'b01111111; parts4 = 8'b10000000; parts5 = 8'b11000000; end // H
        5'b01001: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b01111111; parts3 = 8'b01111111; parts4 = 8'b10011000; parts5 = 8'b11000000; end // I
        5'b01010: begin parts0 = 8'b11110111; parts1 = 8'b11110111; parts2 = 8'b11110111; parts3 = 8'b01111111; parts4 = 8'b11000000; parts5 = 8'b11111001; end // J
        5'b01011: begin parts0 = 8'b11111111; parts1 = 8'b11110111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b11111001; parts5 = 8'b11111001; end // K
        5'b01100: begin parts0 = 8'b01111111; parts1 = 8'b01111111; parts2 = 8'b11110111; parts3 = 8'b01111111; parts4 = 8'b10100100; parts5 = 8'b11111001; end // L
        5'b01101: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b11110111; parts3 = 8'b11110111; parts4 = 8'b10110000; parts5 = 8'b11111001; end // M
        5'b01110: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b10011001; parts5 = 8'b11111001; end // N
        5'b01111: begin parts0 = 8'b11111111; parts1 = 8'b11110111; parts2 = 8'b11110111; parts3 = 8'b11110111; parts4 = 8'b10010010; parts5 = 8'b11111001; end // O
        5'b10000: begin parts0 = 8'b01111111; parts1 = 8'b11110111; parts2 = 8'b11110111; parts3 = 8'b01111111; parts4 = 8'b10000010; parts5 = 8'b11111001; end // P
        5'b10001: begin parts0 = 8'b11110111; parts1 = 8'b01111111; parts2 = 8'b11110111; parts3 = 8'b11110111; parts4 = 8'b11111000; parts5 = 8'b11111001; end // Q
        5'b10010: begin parts0 = 8'b11111111; parts1 = 8'b01111111; parts2 = 8'b11110111; parts3 = 8'b01111111; parts4 = 8'b10000000; parts5 = 8'b11111001; end // R
        5'b10011: begin parts0 = 8'b11111111; parts1 = 8'b01111111; parts2 = 8'b01111111; parts3 = 8'b01111111; parts4 = 8'b10011000; parts5 = 8'b11111001; end // S
        5'b10100: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b11111111; parts3 = 8'b11110111; parts4 = 8'b11000000; parts5 = 8'b10100100; end // T
        5'b10101: begin parts0 = 8'b11111111; parts1 = 8'b11110111; parts2 = 8'b01111111; parts3 = 8'b01111111; parts4 = 8'b11111001; parts5 = 8'b10100100; end // U
        5'b10110: begin parts0 = 8'b11110111; parts1 = 8'b01111111; parts2 = 8'b01111111; parts3 = 8'b01111111; parts4 = 8'b10100100; parts5 = 8'b10100100; end // V
        5'b10111: begin parts0 = 8'b11111111; parts1 = 8'b11110111; parts2 = 8'b11110111; parts3 = 8'b01111111; parts4 = 8'b10110000; parts5 = 8'b10100100; end // W
        5'b11000: begin parts0 = 8'b11110111; parts1 = 8'b01111111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b10011001; parts5 = 8'b10100100; end // X
        5'b11001: begin parts0 = 8'b11110111; parts1 = 8'b11110111; parts2 = 8'b01111111; parts3 = 8'b11110111; parts4 = 8'b10010010; parts5 = 8'b10100100; end // Y
        5'b11010: begin parts0 = 8'b01111111; parts1 = 8'b01111111; parts2 = 8'b11110111; parts3 = 8'b11110111; parts4 = 8'b10000010; parts5 = 8'b10100100; end // Z
        default: begin parts0 = 8'b11111111; parts1 = 8'b11111111; parts2 = 8'b11111111; parts3 = 8'b11111111; parts4 = 8'b11111111; parts5 = 8'b11111111;	
			
			
			end
			
						
		endcase
		
	end
endmodule

// clock input: 50mHz; period = 1/50000000 = 20 nanoseconds per clock cycle
// counter range: 0 to 25,000,000  ; 25000000 cycles X 20 nanoseconds = 0.5 seconds
// able pulse frequency: 1 pulse every 0.5 seconds
module clk_xx(input Clock_in, output reg able); // convert 50mhz to half-second CLOCK cycles
	reg [24:0]counter;
	
	always @(posedge Clock_in)
		if (counter ==  25000000) begin
			counter <= 0;
			able <= 1;
		end
		else begin
			counter <= counter + 1;
			able <= 0;
		end
endmodule

module fsm (input start, input stop, input [3:0]morse, input [3:0]length, input clock, input able, output transmission, output [0:0] led); // leds for debugging

	reg [3:0] len_counter; // copy of length
	reg [2:0] sCurr, sNext; // current and next state of fsm
	reg [3:0] morse_reg; // left-most bit processed each time
	
	// states, a = reset
	//         b = key[1] is pressed
	//         c, d, e = 0.5 second led on each, totalling 1.5sec
	parameter a = 3'b000, b = 3'b001, c = 3'b010, d = 3'b011, e = 3'b100;
	
	// state table
	always @(*) begin
		case (sCurr)
		//look at the current state of the fsm
		//then update the next step according to the morse message that needs to be transmitted
		//each transition in states takes 0.5 seconds. So multiple transitions accumulate the time of signal.
			a: if (!start) 
					sNext = b; //if the button is pressed, the state goes to b
				else
					sNext = a;
					
			b: if (morse_reg[3]) //during b state, progress through each bit in the morse register
					sNext = c;        // button pressed -> c + d + e = 0.5 + 0.5 + 0.5 = 1.5 seconds 'dash'
				else
					sNext = e;        // button pressed -> e = 0.5 seconds 'dot'
				
			c: sNext = d;
			
			d: sNext = e;
			
			e: if (!len_counter[3])
					sNext = a; // done    // end of sequence
				else
					sNext = b;
					
			default: sNext = a;
			endcase
		end

		always @(posedge clock) begin
			if (able) begin
				sCurr <= sNext;
				
				if (sNext == a) begin
					len_counter <= length;
					morse_reg <= morse;
				end
				
				if (!stop)
					sCurr <= a;
				else 
					if (sNext == e) begin
					morse_reg[3] <= morse_reg[2];     // moves onto the next value
					morse_reg[2] <= morse_reg[1];
					morse_reg[1] <= morse_reg[0];
					morse_reg[0] <= 1'b0;
					len_counter[3] <= len_counter[2]; // decreases length by one after each pulse
					len_counter[2] <= len_counter[1];
					len_counter[1] <= len_counter[0];
					len_counter[0] <= 1'b0;
				end
			end
		end
		
		
	// assigns output
	assign transmission = (sCurr == b) | (sCurr == c) | (sCurr == d); 
	assign led = (sCurr == b) | (sCurr == c) | (sCurr == d); 
		
endmodule

module translateMorse (input [4:0] selector, output reg[3:0] morse, output reg[3:0] len);
  // defines dash/dot patterns for letters and the lengths of their sequences
  //morse - 1's indicate a dash, 0's indicate a dot
  //len - number of 1's indicate the length of the message, or total number of beeps
  
	parameter A = 5'b00001, B = 5'b00010, C = 5'b00011, D = 5'b00100;
	parameter E = 5'b00101, F = 5'b00110, G = 5'b00111, H = 5'b01000;
	parameter I = 5'b01001, J = 5'b01010, K = 5'b01011, L = 5'b01100;
	parameter M = 5'b01101, N = 5'b01110, O = 5'b01111, P = 5'b10000;
	parameter Q = 5'b10001, R = 5'b10010, S = 5'b10011, T = 5'b10100;
	parameter U = 5'b10101, V = 5'b10110, W = 5'b10111, X = 5'b11000;
	parameter Y = 5'b11001, Z = 5'b11010;

	always @(selector) begin
		case (selector[4:0])
			A: begin
				morse = 4'b0100;
				len = 4'b1100; 
				end
			B: begin
				morse = 4'b1000;
				len = 4'b1111; 
				end
			C: begin
				morse = 4'b1010;
				len = 4'b1111; 
				end
			D: begin
				morse = 4'b1000;
				len = 4'b1110; 
				end
			E: begin
				morse = 4'b0000;
				len = 4'b1000; 
				end
			F: begin
				morse = 4'b0010;
				len = 4'b1111; 
				end
			G: begin
				morse = 4'b1100;
				len = 4'b1110; 
				end
			H: begin
				morse = 4'b0000;
				len = 4'b1111; 
				end
			I: begin
				morse = 4'b0000;
				len = 4'b1100; 
				end
			J: begin
				morse = 4'b0111;
				len = 4'b1111; 
				end
			K: begin
				morse = 4'b1010;
				len = 4'b1110; 
				end
			L: begin
				morse = 4'b0100;
				len = 4'b1111; 
				end
			M: begin
				morse = 4'b1100;
				len = 4'b1100; 
				end
			N: begin
				morse = 4'b1000;
				len = 4'b1100; 
				end
			O: begin
				morse = 4'b1110;
				len = 4'b1110; 
				end
			P: begin
				morse = 4'b0110;
				len = 4'b1111; 
				end
			Q: begin
				morse = 4'b1101;
				len = 4'b1111; 
				end
			R: begin
				morse = 4'b0100;
				len = 4'b1110; 
				end
			S: begin
				morse = 4'b0000;
				len = 4'b1110; 
				end
			T: begin
				morse = 4'b1000;
				len = 4'b1000; 
				end
			U: begin
				morse = 4'b0110;
				len = 4'b1110; 
				end
			V: begin
				morse = 4'b0001;
				len = 4'b1111; 
				end
			W: begin
				morse = 4'b0110;
				len = 4'b1110; 
				end
			X: begin
				morse = 4'b1001;
				len = 4'b1111; 
				end
			Y: begin
				morse = 4'b1011;
				len = 4'b1111; 
				end
			Z: begin
				morse = 4'b1100;
				len = 4'b1111; 
				end
		endcase
	end
	
endmodule