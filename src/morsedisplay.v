// ============================================================
// morsedisplay.v — Top-level module (Intel DE10-Lite)
//
// * SW[4:0] selects a letter: A=1, B=2, ... Z=26
// * HEX1:HEX0 show the letter's alphabet position (01-26)
// * HEX5:HEX2 show the Morse pattern (dash = '-', dot = '.')
// * KEY[1] starts transmission, KEY[0] resets
// * The external LED + mechanical relay (transistor-amplified,
//   on Arduino_IO12) blink/click the pattern:
//   dot = 0.5 s, dash = 1.5 s
//
// EECS 3201 project — reconstructed from the original
// project report (module design by Bhavneet Kaur & Jaideep Singh)
// ============================================================

module morsedisplay (
    input  wire       MAX10_CLK1_50,  // 50 MHz board clock
    input  wire [9:0] SW,
    input  wire [1:0] KEY,            // active-low pushbuttons
    output wire [7:0] HEX0,
    output wire [7:0] HEX1,
    output wire [7:0] HEX2,
    output wire [7:0] HEX3,
    output wire [7:0] HEX4,
    output wire [7:0] HEX5,
    output wire [9:0] LEDR,
    output wire       ARDUINO_IO12    // drives transistor -> LED + relay
);

    wire        clk   = MAX10_CLK1_50;
    wire        rst_n = KEY[0];
    wire [4:0]  letter = SW[4:0];

    // ------------------------------------------------------------
    // Morse lookup
    // ------------------------------------------------------------
    wire [3:0] morse, len;
    translateMorse u_translate (
        .letter (letter),
        .morse  (morse),
        .len    (len)
    );

    // ------------------------------------------------------------
    // 0.5 s timing tick
    // ------------------------------------------------------------
    wire tick;
    clk_xx u_clkdiv (
        .clk   (clk),
        .rst_n (rst_n),
        .en    (tick)
    );

    // ------------------------------------------------------------
    // Start button edge detect (KEY[1] is active-low)
    // ------------------------------------------------------------
    reg [1:0] key1_sync;
    always @(posedge clk) key1_sync <= {key1_sync[0], ~KEY[1]};
    wire start_pulse = key1_sync[0] & ~key1_sync[1];

    // ------------------------------------------------------------
    // Transmission FSM -> LED + relay
    // ------------------------------------------------------------
    wire signal_out, busy;
    fsm u_fsm (
        .clk        (clk),
        .rst_n      (rst_n),
        .en         (tick),
        .start      (start_pulse),
        .morse      (morse),
        .len        (len),
        .signal_out (signal_out),
        .busy       (busy)
    );

    assign ARDUINO_IO12 = signal_out;
    assign LEDR[0]      = signal_out;  // mirror on board LED
    assign LEDR[9]      = busy;
    assign LEDR[8:1]    = 8'b0;

    // ------------------------------------------------------------
    // 7-segment display (active low, DP = bit 7)
    // ------------------------------------------------------------
    function [7:0] seg_digit(input [3:0] d);
        case (d)
            4'd0: seg_digit = 8'hC0;  4'd1: seg_digit = 8'hF9;
            4'd2: seg_digit = 8'hA4;  4'd3: seg_digit = 8'hB0;
            4'd4: seg_digit = 8'h99;  4'd5: seg_digit = 8'h92;
            4'd6: seg_digit = 8'h82;  4'd7: seg_digit = 8'hF8;
            4'd8: seg_digit = 8'h80;  4'd9: seg_digit = 8'h90;
            default: seg_digit = 8'hFF;  // blank
        endcase
    endfunction

    localparam SEG_DASH  = 8'hBF;  // '-'  (segment g)
    localparam SEG_DOT   = 8'h7F;  // '.'  (decimal point)
    localparam SEG_BLANK = 8'hFF;

    // Letter position as two decimal digits (01-26)
    wire [3:0] tens = (letter >= 5'd20) ? 4'd2 :
                      (letter >= 5'd10) ? 4'd1 : 4'd0;
    wire [3:0] ones = letter - (tens * 4'd10);

    assign HEX1 = seg_digit(tens);
    assign HEX0 = seg_digit(ones);

    // Morse pattern on HEX5..HEX2 (first element on HEX5)
    wire [2:0] num_elems = len[3] + len[2] + len[1] + len[0];

    assign HEX5 = (num_elems >= 3'd1) ? (morse[3] ? SEG_DASH : SEG_DOT) : SEG_BLANK;
    assign HEX4 = (num_elems >= 3'd2) ? (morse[2] ? SEG_DASH : SEG_DOT) : SEG_BLANK;
    assign HEX3 = (num_elems >= 3'd3) ? (morse[1] ? SEG_DASH : SEG_DOT) : SEG_BLANK;
    assign HEX2 = (num_elems >= 3'd4) ? (morse[0] ? SEG_DASH : SEG_DOT) : SEG_BLANK;

endmodule
