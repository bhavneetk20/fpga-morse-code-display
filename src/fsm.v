// ============================================================
// fsm.v — Morse transmission finite-state machine
//
// Sequences the external LED + mechanical relay through the
// selected letter's Morse pattern. Each state transition takes
// one 0.5 s tick from clk_xx, so durations accumulate:
//   dot  = 1 tick  (0.5 s on)
//   dash = 3 ticks (1.5 s on)
//   gap  = 1 tick  (0.5 s off between elements)
//
// EECS 3201 project — reconstructed from the original
// project report (module design by Bhavneet Kaur & Jaideep Singh)
// ============================================================

module fsm (
    input  wire       clk,        // 50 MHz clock
    input  wire       rst_n,      // active-low reset (KEY[0])
    input  wire       en,         // 0.5 s tick from clk_xx
    input  wire       start,      // start transmission (KEY[1], debounced)
    input  wire [3:0] morse,      // dash/dot pattern from translateMorse
    input  wire [3:0] len,        // thermometer-coded element count
    output reg        signal_out, // drives LED + relay (via transistor amp)
    output reg        busy        // high while transmitting
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam SEND = 2'd1;   // element on (LED/relay energized)
    localparam GAP  = 2'd2;   // 0.5 s silence between elements
    localparam DONE = 2'd3;

    reg [1:0] state;
    reg [3:0] pattern;     // remaining pattern, MSB = current element
    reg [2:0] elems_left;  // elements still to send
    reg [1:0] on_ticks;    // ticks remaining for current element

    // Decode thermometer-coded len into a count (0-4)
    wire [2:0] num_elems = len[3] + len[2] + len[1] + len[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            signal_out <= 1'b0;
            busy       <= 1'b0;
            pattern    <= 4'b0;
            elems_left <= 3'd0;
            on_ticks   <= 2'd0;
        end else begin
            case (state)

                IDLE: begin
                    signal_out <= 1'b0;
                    busy       <= 1'b0;
                    if (start && num_elems != 3'd0) begin
                        pattern    <= morse;
                        elems_left <= num_elems;
                        on_ticks   <= morse[3] ? 2'd3 : 2'd1; // dash : dot
                        busy       <= 1'b1;
                        state      <= SEND;
                    end
                end

                SEND: begin
                    signal_out <= 1'b1;              // LED + relay on
                    if (en) begin
                        if (on_ticks == 2'd1) begin  // element finished
                            if (elems_left == 3'd1)
                                state <= DONE;       // last element sent
                            else
                                state <= GAP;
                        end else begin
                            on_ticks <= on_ticks - 2'd1;
                        end
                    end
                end

                GAP: begin
                    signal_out <= 1'b0;              // 0.5 s silence
                    if (en) begin
                        pattern    <= pattern << 1;  // advance to next element
                        elems_left <= elems_left - 3'd1;
                        on_ticks   <= pattern[2] ? 2'd3 : 2'd1;
                        state      <= SEND;
                    end
                end

                DONE: begin
                    signal_out <= 1'b0;
                    busy       <= 1'b0;
                    state      <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
