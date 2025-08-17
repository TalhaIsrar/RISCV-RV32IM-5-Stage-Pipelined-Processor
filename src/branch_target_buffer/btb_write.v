`include "../defines.vh"

module btb_write(
    input [127:0] update_set,
    input [7:0] LRU,
    input [26:0] update_tag,
    input [2:0] update_index,
    input [31:0] update_target,
    input mispredicted,
    output [127:0] write_set,
    output next_LRU_write
);
    // EX Stage operations
    wire current_LRU_write;

    // Extract Signals from Set
    wire [63:0] branch1, branch2;
    wire valid1, valid2;
    wire [26:0] tag1, tag2;
    wire [31:0] target1, target2;
    wire [1:0] state1, state2;

    // Final write singals to put into BTB
    wire write_valid1, write_valid2;
    wire [26:0] write_tag1, write_tag2;
    wire [31:0] write_target1, write_target2;

    // Check for each branch in set
    wire check_branch1, check_branch2;
    wire new_entry_check;

    // Insert data branches
    wire insert_branch1, insert_branch2;

    // Branch to take
    wire take_branch1, take_branch2;

    // Current state of branches to consider
    wire [1:0] current_state_branch1, current_state_branch2;

    // Next state of branches
    wire [1:0] next_state_branch1, next_state_branch2;
    wire [1:0] write_state1, write_state2;

    // Set (128 bits) = Branch1 (64 bits) + Branch2(64 bits)
    // Branch (64 bits) = Valid (1 bit) + Tag (27 bits) + Target (32 bits) + State (2 bits) + N/A (2 bits)
    assign branch1 = update_set[127:64];
    assign branch2 = update_set[63:0];

    assign valid1 = branch1[63];
    assign valid2 = branch2[63];

    assign tag1 = branch1[62:36];
    assign tag2 = branch2[62:36];

    assign target1 = branch1[35:4];
    assign target2 = branch2[35:4];

    assign state1 = branch1[3:2];
    assign state2 = branch2[3:2];

    // 2 Possible cases:
    // Tag exists and we only need to update
    // Tag doesnt exist and we need to add new entry in BTB File

    // Comparator + AND Gate to check if required tag exists in branch and if value is valid    assign check_branch1 = valid1 && (read_tag == tag1);
    assign check_branch1 = valid1 && (update_tag == tag1);    
    assign check_branch2 = valid2 && (update_tag == tag2);

    // Check if entry doesnt exist in either branches in a set
    // New entry = 1 else 0 if exists
    assign new_entry_check = !(check_branch1 || check_branch2);

    // Read the LRU value for the current set
    assign current_LRU_write = LRU[update_index];

    // Path if tag doesnt exist
    // Use LRU to decide to write in Branch1 or branch0
    assign insert_branch1 = new_entry_check ? current_LRU_write : 1'b0;
    assign insert_branch2 = new_entry_check ? current_LRU_write : 1'b1;

    // Check if branch1 or branch2 is being updated or replaced 
    // Only 1 of these will be 1
    assign take_branch1 = check_branch1 || insert_branch1;
    assign take_branch2 = check_branch2 || !(insert_branch2);

    // Valid remain 1 if it was 1 and if new value is being inserted
    assign write_valid1 = valid1 || take_branch1;
    assign write_valid2 = valid2 || take_branch2;

    // Mux to select which branch to replace tag of and which to keep as old one
    assign write_tag1 = insert_branch1 ? update_tag : tag1;
    assign write_tag2 = insert_branch2 ? tag2 : update_tag;

    // Mux to select which branch to write new/updated target into and which to keep as old one
    assign write_target1 = take_branch1 ? update_target : target1;
    assign write_target2 = take_branch2 ? update_target : target2;

    // Use the MUX to check if entry is new/replacement
    // If entry is new value then initialize it with strongNotTaken(00) before passing to FSM
    // FSM will decide on base of old value and mispredicted, the new prediction for the address
    // FSM is using dynamic 2 bit predictor
    assign current_state_branch1 =  insert_branch1 ? `STRONG_NOT_TAKEN : state1;
    assign current_state_branch2 =  !(insert_branch2) ? `STRONG_NOT_TAKEN : state2;

    dynamic_branch_predictor fsm_branch1(
        .current_state(current_state_branch1),
        .mispredicted(mispredicted),
        .next_state(next_state_branch1)
    );

    dynamic_branch_predictor fsm_branch2(
        .current_state(current_state_branch2),
        .mispredicted(mispredicted),
        .next_state(next_state_branch2)
    );

    assign write_state1 = take_branch1 ? next_state_branch1 : state1;
    assign write_state2 = take_branch2 ? next_state_branch2 : state2;

    // Initialize the final set which we have to replace in BTB file
    // Set is formed from concationation of all results calculated above
    assign write_set = { write_valid1, write_tag1, write_target1, write_state1, 2'b00,
                         write_valid2, write_tag2, write_target2, write_state2, 2'b00};

    // Calculate the next LRU value for current set
    assign next_LRU_write = new_entry_check ? (insert_branch1 ? 1'b0 : 1'b1) : current_LRU_write;

endmodule