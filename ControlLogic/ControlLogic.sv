`timescale 1ns / 1ps

module ControlLogic #(parameter IN=9, parameter OUT=9) (
    input logic [31:0] ins,
    input logic clk,
    input logic rst,
    output logic [3:0] aluControl,
    output logic [2:0] immSel,
    output logic regwen,
    output logic bsel
    );
    
    logic [IN-1:0] index;
    logic [OUT-1:0] control;
    
    logic        bit30;
    logic [2:0]  funct3;
    logic [4:0]  opcode;

    assign bit30  = ins[30];
    assign funct3 = ins[14:12];
    assign opcode = ins[6:2];
    
    assign index = {bit30, funct3, opcode};
    
    always_comb begin
        case(index)
            9'h0C: control = 9'b000010000;
            9'h10C: control = 9'b100010000;
            9'hCC: control = 9'b011010000;
            9'hEC: control = 9'b011110000;
            9'h2C: control = 9'b000110000;
            9'hAC: control = 9'b010110000;
            9'h1AC: control = 9'b110110000;
            9'h4C: control = 9'b001010000;
            9'h6C: control = 9'b001110000;
            9'h8C: control = 9'b010010000;
            9'h04: control = 9'b000010001;
            9'h104: control = 9'b000010001;
            9'h84: control = 9'b010010001;
            9'h184: control = 9'b010010001;
            9'hC4: control = 9'b011010001;
            9'h1C4: control = 9'b011010001;
            9'hE4: control = 9'b011110001;
            9'h1E4: control = 9'b011110001;
            9'h24: control = 9'b000110001;
            9'hA4: control = 9'b010110001;
            9'h1A4: control = 9'b110110001;
            9'h44: control = 9'b001010001;
            9'h144: control = 9'b001010001;
            9'h64: control = 9'b001110001;
            9'h164: control = 9'b001110001;
            default: begin
                control = 9'b000010001; // Control signals for NOP
            end
        endcase
    end
    
    assign {aluControl, regwen, immSel, bsel} = control;
    
//    always_ff @(posedge clk or posedge rst) begin
//        if (rst) begin
//            {aluControl, regwen, immSel, bsel} <= 9'b000010001;
//        end else begin
//            {aluControl, regwen, immSel, bsel} <= control;
//        end
//    end
    
endmodule
