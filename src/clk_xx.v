// ============================================================
// clk_xx.v — Clock divider
// Divides the DE10-Lite's 50 MHz clock into a 0.5 s enable
// pulse used to time Morse dots (1 tick) and dashes (3 ticks).
// 50,000,000 cycles/s -> pulse every 25,000,000 cycles = 0.5 s
//
// EECS 3201 project — reconstructed from the original
// project report (module design by Bhavneet Kaur & Jaideep Singh)
// ============================================================

module clk_xx (
    input  wire clk,     // 50 MHz board clock
    input  wire rst_n,   // active-low reset
    output reg  en       // single-cycle enable pulse every 0.5 s
);

    reg [24:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 25'd0;
            en      <= 1'b0;
        end else if (counter == 25'd24_999_999) begin
            counter <= 25'd0;
            en      <= 1'b1;   // pulse for one clock cycle
        end else begin
            counter <= counter + 25'd1;
            en      <= 1'b0;
        end
    end

endmodule
