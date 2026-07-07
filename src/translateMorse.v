// ============================================================
// translateMorse.v — Letter to Morse pattern lookup
//
// Encoding (as designed in the original project report):
//   morse — 4-bit pattern, MSB first: 1 = dash, 0 = dot
//   len   — thermometer code: the number of 1s gives the
//           number of elements in the letter's Morse sequence
//
//   Example:  A = ".-"  -> morse = 4'b0100, len = 4'b1100 (2 elements)
//             B = "-..."-> morse = 4'b1000, len = 4'b1111 (4 elements)
//
// EECS 3201 project — reconstructed from the original
// project report (module design by Bhavneet Kaur & Jaideep Singh)
// ============================================================

module translateMorse (
    input  wire [4:0] letter,  // 1 = A ... 26 = Z
    output reg  [3:0] morse,   // dash/dot pattern, MSB first
    output reg  [3:0] len      // thermometer-coded element count
);

    always @(*) begin
        case (letter)
            5'd1 : begin morse = 4'b0100; len = 4'b1100; end // A .-
            5'd2 : begin morse = 4'b1000; len = 4'b1111; end // B -...
            5'd3 : begin morse = 4'b1010; len = 4'b1111; end // C -.-.
            5'd4 : begin morse = 4'b1000; len = 4'b1110; end // D -..
            5'd5 : begin morse = 4'b0000; len = 4'b1000; end // E .
            5'd6 : begin morse = 4'b0010; len = 4'b1111; end // F ..-.
            5'd7 : begin morse = 4'b1100; len = 4'b1110; end // G --.
            5'd8 : begin morse = 4'b0000; len = 4'b1111; end // H ....
            5'd9 : begin morse = 4'b0000; len = 4'b1100; end // I ..
            5'd10: begin morse = 4'b0111; len = 4'b1111; end // J .---
            5'd11: begin morse = 4'b1010; len = 4'b1110; end // K -.-
            5'd12: begin morse = 4'b0100; len = 4'b1111; end // L .-..
            5'd13: begin morse = 4'b1100; len = 4'b1100; end // M --
            5'd14: begin morse = 4'b1000; len = 4'b1100; end // N -.
            5'd15: begin morse = 4'b1110; len = 4'b1110; end // O ---
            5'd16: begin morse = 4'b0110; len = 4'b1111; end // P .--.
            5'd17: begin morse = 4'b1101; len = 4'b1111; end // Q --.-
            5'd18: begin morse = 4'b0100; len = 4'b1110; end // R .-.
            5'd19: begin morse = 4'b0000; len = 4'b1110; end // S ...
            5'd20: begin morse = 4'b1000; len = 4'b1000; end // T -
            5'd21: begin morse = 4'b0010; len = 4'b1110; end // U ..-
            5'd22: begin morse = 4'b0001; len = 4'b1111; end // V ...-
            5'd23: begin morse = 4'b0110; len = 4'b1110; end // W .--
            5'd24: begin morse = 4'b1001; len = 4'b1111; end // X -..-
            5'd25: begin morse = 4'b1011; len = 4'b1111; end // Y -.--
            5'd26: begin morse = 4'b1100; len = 4'b1111; end // Z --..
            default: begin morse = 4'b0000; len = 4'b0000; end
        endcase
    end

endmodule
