`timescale 1ns / 1ps

module ControlLogic #(parameter IN=10, parameter OUT=10) (
    input logic [31:0] ins,
    output logic [4:0] aluControl,
    output logic [2:0] immSel,
    output logic regwen,
    output logic bsel
    );
    
    logic [IN-1:0] index;
    logic [OUT-1:0] control;
    
    logic bit30;
    logic bit25;       
    logic [2:0]  funct3;
    logic [4:0]  opcode;

    assign bit30 = ins[30];
    assign bit25 = ins[25];
    assign funct3 = ins[14:12];
    assign opcode = ins[6:2];
    
    assign index = {bit30, bit25, funct3, opcode};
    
    always_comb begin
        case(index)
            10'b0000001100: control = 10'b0000010000;
            10'b1000001100: control = 10'b0100010000;
            10'b0011001100: control = 10'b0011010000;
            10'b0011101100: control = 10'b0011110000;
            10'b0000101100: control = 10'b0000110000;
            10'b0010101100: control = 10'b0010110000;
            10'b1010101100: control = 10'b0110110000;
            10'b0001001100: control = 10'b0001010000;
            10'b0001101100: control = 10'b0001110000;
            10'b0010001100: control = 10'b0010010000;
            10'b0100001100: control = 10'b1111010000;
            10'b0100101100: control = 10'b1111110000;
            10'b0101001100: control = 10'b1100010000;
            10'b0101101100: control = 10'b1100110000;
            10'b0110001100: control = 10'b1001010000;
            10'b0110101100: control = 10'b1001110000;
            10'b0111001100: control = 10'b1010010000;
            10'b0111101100: control = 10'b1010110000;
            10'b0000000100: control = 10'b0000010001;
            10'b1100000100: control = 10'b0000010001;
            10'b0100000100: control = 10'b0000010001;
            10'b1000000100: control = 10'b0000010001;
            10'b0010000100: control = 10'b0010010001;
            10'b1110000100: control = 10'b0010010001;
            10'b0110000100: control = 10'b0010010001;
            10'b1010000100: control = 10'b0010010001;
            10'b0011000100: control = 10'b0011010001;
            10'b1111000100: control = 10'b0011010001;
            10'b0111000100: control = 10'b0011010001;
            10'b1011000100: control = 10'b0011010001;
            10'b0011100100: control = 10'b0011110001;
            10'b1111100100: control = 10'b0011110001;
            10'b0111100100: control = 10'b0011110001;
            10'b1011100100: control = 10'b0011110001;
            10'b0000100100: control = 10'b0000110001;
            10'b0010100100: control = 10'b0010110001;
            10'b1010100100: control = 10'b0110110001;
            10'b0001000100: control = 10'b0001010001;
            10'b1101000100: control = 10'b0001010001;
            10'b0101000100: control = 10'b0001010001;
            10'b1001000100: control = 10'b0001010001;
            10'b0001100100: control = 10'b0001110001;
            10'b0101100100: control = 10'b0001110001;
            10'b1001100100: control = 10'b0001110001;
            10'b1101100100: control = 10'b0001110001;
            default: control = 10'b0000010001; // deafult for NOP
        endcase
    end
    
    assign {aluControl, regwen, immSel, bsel} = control;
    
endmodule
