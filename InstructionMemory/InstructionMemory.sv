module InstructionMemory #(
    parameter ADDR_WIDTH = 8
) (
    input logic [ADDR_WIDTH-1:0] addr,    // byte address input
    output logic [31:0] ins_out
);

    logic [ADDR_WIDTH-3:0] word_addr; // word-aligned address

    always_comb begin

        word_addr = addr[ADDR_WIDTH-1:2];  // divide by 4 for instruction index

        case (word_addr)
            6'd0:  ins_out = 32'h00500193;
            6'd1:  ins_out = 32'h00700213;
            6'd2:  ins_out = 32'h010000EF;
            6'd3:  ins_out = 32'h014000EF;
            6'd4:  ins_out = 32'h00F00393;
            6'd5:  ins_out = 32'h00E00413;
            6'd6:  ins_out = 32'h00418333;
            6'd7:  ins_out = 32'h00008067;
            6'd8:  ins_out = 32'h00000013;
            default: ins_out = 32'h00000013; // NOP (addi x0,x0,0)
        endcase
    end

endmodule
