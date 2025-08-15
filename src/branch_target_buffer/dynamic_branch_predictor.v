`include "../defines.vh"

module dynamic_branch_predictor(
    input [1:0] current_state,
    input mispredicted,
    output reg [1:0] next_state
);

    // FSM implementation based on case select logic
    // current state + mispredicted -> next_state
    always @(*) begin
        case (current_state)
            `STRONG_NOT_TAKEN: next_state = mispredicted ? `WEAK_NOT_TAKEN  : `STRONG_NOT_TAKEN;
            `WEAK_NOT_TAKEN:   next_state = mispredicted ? `STRONG_TAKEN    : `STRONG_NOT_TAKEN;
            `STRONG_TAKEN:     next_state = mispredicted ? `WEAK_TAKEN      : `STRONG_TAKEN;
            `WEAK_TAKEN:       next_state = mispredicted ? `STRONG_NOT_TAKEN: `STRONG_TAKEN;
            default:           next_state = current_state;
        endcase
    end

endmodule
