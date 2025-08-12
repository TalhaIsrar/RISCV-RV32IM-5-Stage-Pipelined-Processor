module data_mem(
    input clk,
    input rst,
    input mem_write,       // 1 = write, 0 = read
    input [1:0] store_type, // 2'b00=SB , 2'b01=SH , 2'b10=SW
    input [2:0] load_type,  // 3'b000=LB, 3'b001=LH, 3'b010=LW, 3'b011=LBU, 3'b100=LHU
    input [11:0] addr,
    input [31:0]  write_data,
    output reg [31:0]  read_data
);
    //reg [7:0] mem [0:4095];  // 4KB memory 
    reg [7:0] mem [0:31]; // USE SMALL SIZE FOR DEBUGGING

    wire [11:0] word_addr   = addr[11:2];
    wire [1:0] byte_offset = addr[1:0];

    reg [31:0] read_data_reg;
    reg [3:0] byte_write_en;

    always @(*) begin
            case (store_type)
                2'b00: // SB - store byte
                    case (byte_offset)
                        2'b00: byte_write_en = 4'b0001;
                        2'b01: byte_write_en = 4'b0010;
                        2'b10: byte_write_en = 4'b0100;
                        2'b11: byte_write_en = 4'b1000;
                        default: byte_write_en = 4'b0000;
                    endcase
                2'b01: // SH - store halfword (2 bytes)
                    case (byte_offset[1])
                        1'b0: byte_write_en = 4'b0011; // lower halfword
                        1'b1: byte_write_en = 4'b1100; // upper halfword
                        default: byte_write_en = 4'b0000;
                    endcase
                2'b10: // SW - store word (4 bytes)
                    byte_write_en = 4'b1111;
                default:
                    byte_write_en = 4'b0000;
            endcase
        end

    // Store logic
    always @(posedge clk) begin
        if (mem_write) begin
            if (byte_write_en[0]) mem[{word_addr, 2'b00}] <= write_data[7:0];
            if (byte_write_en[1]) mem[{word_addr, 2'b01}] <= write_data[15:8];
            if (byte_write_en[2]) mem[{word_addr, 2'b10}] <= write_data[23:16];
            if (byte_write_en[3]) mem[{word_addr, 2'b11}] <= write_data[31:24];
        end
    end

    // Load logic
    always @(posedge clk) begin
        if (rst) begin
            read_data_reg <= 32'h00000000;
        end else begin
            read_data_reg <= {
                mem[{word_addr, 2'b11}],
                mem[{word_addr, 2'b10}],
                mem[{word_addr, 2'b01}],
                mem[{word_addr, 2'b00}]
                };
        end
    end

    // Load sign or zero extension logic
    always @(*) begin
        case (load_type)
            3'b000: begin // LB - load byte, sign extend
                case (byte_offset)
                    2'b00: read_data = {{24{read_data_reg[7]}}, read_data_reg[7:0]};
                    2'b01: read_data = {{24{read_data_reg[15]}}, read_data_reg[15:8]};
                    2'b10: read_data = {{24{read_data_reg[23]}}, read_data_reg[23:16]};
                    2'b11: read_data = {{24{read_data_reg[31]}}, read_data_reg[31:24]};
                    default: read_data = 32'b0;
                endcase
            end
            3'b001: begin // LH - load halfword, sign extend
                case (byte_offset[1])
                    1'b0: read_data = {{16{read_data_reg[15]}}, read_data_reg[15:0]};
                    1'b1: read_data = {{16{read_data_reg[31]}}, read_data_reg[31:16]};
                    default: read_data = 32'b0;
                endcase
            end
            3'b010: read_data = read_data_reg; // LW - load word, no extension needed
            3'b011: begin // LBU - load byte, zero extend
                case (byte_offset)
                    2'b00: read_data = {24'b0, read_data_reg[7:0]};
                    2'b01: read_data = {24'b0, read_data_reg[15:8]};
                    2'b10: read_data = {24'b0, read_data_reg[23:16]};
                    2'b11: read_data = {24'b0, read_data_reg[31:24]};
                    default: read_data = 32'b0;
                endcase
            end
            3'b100: begin // LHU - load halfword, zero extend
                case (byte_offset[1])
                    1'b0: read_data = {16'b0, read_data_reg[15:0]};
                    1'b1: read_data = {16'b0, read_data_reg[31:16]};
                    default: read_data = 32'b0;
                endcase
            end
            default: read_data = read_data_reg;
        endcase
    end


endmodule