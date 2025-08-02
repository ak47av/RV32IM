`timescale 1ns / 1ps

module LoadControl(
    input logic clk,
    input logic [31:0] load_word,
    input logic [2:0] lsel,
    input logic [31:0] PC,
    input logic [31:0] immediate,
    output logic [31:0] out
    );
    
    always_comb begin
        case(lsel)
            3'b000: out = 0;
            3'b001: out = {{16{load_word[15]}}, load_word[15:0]}; // LH
            3'b010: out = load_word; // LW
            3'b011: out = {{24{load_word[7]}}, load_word[7:0]}; // LB
            3'b100: out = {24'b0, load_word[7:0]}; // LBU
            3'b101: out = {16'b0, load_word[15:0]}; // LHU
            3'b110: out = immediate; // LUI
            3'b111: out = immediate + PC; // AUIPC
            default: out = 32'h0;
        endcase
    end
    
    always @(posedge clk) begin
//        $display("[LD] loadWord:%0h | loadOut:%0h ", load_word, out);
    end
    
endmodule
