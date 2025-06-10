`timescale 1ns / 1ps

module RSplitter(
    input logic [31:0] ins,
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7
    );
    
    assign {funct7, rs2, rs1, funct3, rd, opcode} = ins; 
    
endmodule
