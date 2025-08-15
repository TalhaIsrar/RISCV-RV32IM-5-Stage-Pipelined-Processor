module lru_next(
    input [2:0] index,
    input [2:0] update_index,
    input update_lru_read,
    input update_lru_write,
    input [7:0] LRU,
    output reg [7:0] next_LRU
);

    always @* begin
        // One-hot masks for read and write
        reg [7:0] read_mask;
        reg [7:0] write_mask;
        reg [7:0] update_mask;
        reg [7:0] update_bits;

        read_mask   = (8'b00000001 << index);
        write_mask  = (8'b00000001 << update_index);

        // Combine all bits we want to update
        update_mask = read_mask | write_mask;

        // Build the new values to set
        update_bits = (update_lru_read  ? read_mask  : 8'b00000000)
                    | (update_lru_write ? write_mask : 8'b00000000);

        // Apply updates
        LRU_next = (LRU_prev & ~update_mask) | update_bits;
    end

endmodule