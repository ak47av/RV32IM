`timescale 1ns / 1ps

module ImmediateGenerator(
    input logic [31:0] ins,
    input logic [2:0] immSel,
    output logic [31:0] imm31_0
    );
    
    logic [11:0] imm11_0;
    logic [4:0] imm4_0;
    logic [6:0] imm11_5;
    logic imm11_B, imm11_J;
    logic [3:0] imm4_1;
    logic [5:0] imm10_5;
    logic imm12;
    logic [7:0] imm19_12;
    logic [9:0] imm10_1;
    logic imm20;
    logic [19:0] imm31_12;
    
    ISplitter ispl(.ins(ins), .opcode(), .rd(), .funct3(), .rs1(), .imm11_0(imm11_0));
    JSplitter jspl(.ins(ins), .opcode(), .rd(), .imm19_12(imm19_12), .imm11(imm11_J), .imm10_1(imm10_1), .imm20(imm20));
    BSplitter bspl(.ins(ins), .opcode(), .imm11(imm11_B), .imm4_1(imm4_1), .funct3(), .rs1(), .rs2(), .imm10_5(imm10_5), .imm12(imm12));
    USplitter uspl(.ins(ins), .opcode(), .rd(), .imm31_12(imm31_12));
    SSplitter sspl(.ins(ins), .opcode(), .imm4_0(imm4_0), .funct3(), .rs1(), .rs2(), .imm11_5(imm11_5));
    
    logic [31:0] iout;
    logic [31:0] sout;
    logic [31:0] bout;
    logic [31:0] jout;
    logic [31:0] uout;
    
    assign iout = {{20{imm11_0[11]}}, imm11_0};
    assign sout = {{20{imm11_5[6]}}, imm11_5, imm4_0};
    assign bout = {{19{imm12}}, imm12, imm11_B, imm10_5, imm4_1, 1'b0};
    assign jout = {{11{imm20}} , imm20, imm19_12 , imm11_J, imm10_1, 1'b0};
    assign uout = {imm31_12, 12'b0};
    
    always @ (*) begin
        case(immSel)
            3'b000: imm31_0 = iout;
            3'b001: imm31_0 = sout;
            3'b010: imm31_0 = bout;
            3'b011: imm31_0 = jout;
            3'b100: imm31_0 = uout;
            3'b101: imm31_0 = 0;
            3'b110: imm31_0 = 0;
            3'b111: imm31_0 = 0;
        endcase
    end   
    
endmodule
