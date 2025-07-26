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
            6'd0:  ins_out = 32'h00500093;
            6'd1:  ins_out = 32'h00A00113;
            6'd2:  ins_out = 32'h002081B3;
            6'd3:  ins_out = 32'h40110233;
            6'd4:  ins_out = 32'h00408463;
            6'd5:  ins_out = 32'h00000293;
            6'd6:  ins_out = 32'h00100293;
            6'd7:  ins_out = 32'h00209463;
            6'd8:  ins_out = 32'h00000313;
            6'd9:  ins_out = 32'h00100313;
            6'd10:  ins_out = 32'h0020C463;
            6'd11:  ins_out = 32'h00000393;
            6'd12:  ins_out = 32'h00100393;
            6'd13:  ins_out = 32'h00000413;
            6'd14:  ins_out = 32'h00100463;
            6'd15:  ins_out = 32'h00100413;
            6'd16:  ins_out = 32'h00115463;
            6'd17:  ins_out = 32'h00000493;
            6'd18:  ins_out = 32'h00100493;
            6'd19:  ins_out = 32'h00000513;
            6'd20:  ins_out = 32'h00100463;
            6'd21:  ins_out = 32'h00100513;
            6'd22:  ins_out = 32'h0020A5B3;
            6'd23:  ins_out = 32'h00113633;
            default: ins_out = 32'h00000013; // NOP (addi x0,x0,0)
        endcase
    end

endmodule

