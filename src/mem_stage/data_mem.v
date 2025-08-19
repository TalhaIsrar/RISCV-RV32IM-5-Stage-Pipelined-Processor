module data_mem (
    input clk,
    input rst,
    input mem_write,       // 1 = write, 0 = read
    input [1:0] store_type, // 2'b00=SB , 2'b01=SH , 2'b10=SW
    input [2:0] load_type,  // 3'b000=LB, 3'b001=LH, 3'b010=LW, 3'b011=LBU, 3'b100=LHU
    input [11:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    // Declare memory as word-addressable.
    // 1KB = 1024 bytes = 256 words of 32 bits.
    // The `ram_style` attribute explicitly tells Vivado to use BRAM.
    (* ram_style = "block" *) reg [31:0] mem [0:255];

    // Address for the 32-bit word.
    wire [9:0] word_addr = addr[11:2];
    wire [1:0] byte_offset = addr[1:0];

    // Use a separate register to hold the raw word read from memory.
    reg [31:0] read_data_word;

    // Implement a single, synchronous read operation.
    // This is the core of BRAM inference.
    always @(posedge clk) begin
        read_data_word <= mem[word_addr];
    end

    // Implement synchronous write with byte-enables.
    // This maps directly to BRAM's byte-write enable feature.
    always @(posedge clk) begin
        if (mem_write) begin
            case (store_type)
                2'b00: begin // SB - store byte
                    if (byte_offset == 2'b00) mem[word_addr][7:0]   <= write_data[7:0];
                    if (byte_offset == 2'b01) mem[word_addr][15:8]  <= write_data[15:8];
                    if (byte_offset == 2'b10) mem[word_addr][23:16] <= write_data[23:16];
                    if (byte_offset == 2'b11) mem[word_addr][31:24] <= write_data[31:24];
                end
                2'b01: begin // SH - store halfword
                    if (byte_offset[1] == 1'b0) mem[word_addr][15:0]  <= write_data[15:0];
                    else                       mem[word_addr][31:16] <= write_data[31:16];
                end
                2'b10: begin // SW - store word
                    mem[word_addr] <= write_data;
                end
            endcase
        end
    end

    // Perform byte/half-word selection and sign/zero extension *after* the read.
    // This logic is combinatorial and will be synthesized as muxes outside the BRAM.
    always @(*) begin
        case (load_type)
            3'b000: begin // LB - load byte, sign extend
                case (byte_offset)
                    2'b00: read_data = {{24{read_data_word[7]}},  read_data_word[7:0]};
                    2'b01: read_data = {{24{read_data_word[15]}}, read_data_word[15:8]};
                    2'b10: read_data = {{24{read_data_word[23]}}, read_data_word[23:16]};
                    2'b11: read_data = {{24{read_data_word[31]}}, read_data_word[31:24]};
                    default: read_data = 32'h00000000;
                endcase
            end
            3'b001: begin // LH - load halfword, sign extend
                if (byte_offset[1] == 1'b0) read_data = {{16{read_data_word[15]}}, read_data_word[15:0]};
                else                        read_data = {{16{read_data_word[31]}}, read_data_word[31:16]};
            end
            3'b010: begin // LW - load word
                read_data = read_data_word;
            end
            3'b011: begin // LBU - load byte, zero extend
                case (byte_offset)
                    2'b00: read_data = {24'h0, read_data_word[7:0]};
                    2'b01: read_data = {24'h0, read_data_word[15:8]};
                    2'b10: read_data = {24'h0, read_data_word[23:16]};
                    2'b11: read_data = {24'h0, read_data_word[31:24]};
                    default: read_data = 32'h00000000;
                endcase
            end
            3'b100: begin // LHU - load halfword, zero extend
                if (byte_offset[1] == 1'b0) read_data = {16'h0, read_data_word[15:0]};
                else                        read_data = {16'h0, read_data_word[31:16]};
            end
            default: read_data = read_data_word;
        endcase
    end

endmodule