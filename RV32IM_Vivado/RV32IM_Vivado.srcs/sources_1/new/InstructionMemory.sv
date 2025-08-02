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
            6'd0:  ins_out = 32'hFEDCB0B7;
            6'd1:  ins_out = 32'h78900113;
            6'd2:  ins_out = 32'h001100B3;
            6'd3:  ins_out = 32'h02100E23;
            6'd4:  ins_out = 32'h02101823;
            6'd5:  ins_out = 32'h02102A23;
            6'd6:  ins_out = 32'h03400183;
            6'd7:  ins_out = 32'h03401203;
            6'd8:  ins_out = 32'h03404283;
            6'd9:  ins_out = 32'h03405303;
            6'd10:  ins_out = 32'h03402383;
            default: ins_out = 32'h00000013; // NOP (addi x0,x0,0)
        endcase
    end

endmodule