module btb_file (
    input clk,
    input [2:0] read_index, // 2^3 = 8 possible sets
    input [2:0] update_index,
    input [2:0] write_index,
    input [127:0] write_set,
    input write_en,

    output wire [127:0] read_set,
    output wire [127:0] update_set  
);

    reg [127:0] file [7:0];

    // Not practical way but here we keep
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1)
            file[i] = 128'h0;
    end

    // Write operation
    always @(posedge clk) begin
        if (write_en)
            file[write_index] <= write_set;
    end

    // Read operation
    assign update_set = file[update_index];

    // In case read and write are to same address (when write enable = 1):
    // Forward write value to read set directly to save 1 cycle
    assign read_set = ((read_index == write_index) && write_en) ? write_set : file[read_index];

endmodule