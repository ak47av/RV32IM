`timescale 1ns / 1ps

module Datapath(
    input logic clk,
    input logic rst
    );
    
    logic [31:0] ins;
    logic [4:0] rsi1, rsi2, rdi;
    
    logic [31:0] outPCPlus1, outPC;
    logic [31:0] ready;
    
    logic regwen, bsel;
    logic [4:0] ALUselect;
    //logic [2:0] Mselect;
    logic [2:0] IMMselect;
    
    logic [31:0] immediateValue;
    
    logic [31:0] rs1, rs2, rd;    
    
    logic [31:0] dataB, ALUoutput;
    
    assign rdi = ins[11:7];
    assign rsi1 = ins[19:15];
    assign rsi2 = ins[24:20];
    
    assign dataB = (bsel) ? immediateValue : rs2;
    assign rd = ALUoutput;
    
    
    
    ProgramCounter PC(
                    .inPC(outPCPlus1), 
                    .clk(clk), 
                    .rst(rst), 
                    .outPCPlus1(outPCPlus1), 
                    .outPC(outPC),
                    .ready(ready)
                    );
    
    InstructionMemory ins_mem(
                        .addr(outPC[4:0]), 
                        .clk(clk), 
                        .ins_out(ins)
                        );
    
    ControlLogic ctrlLogic(
        .ins(ins),
        .clk(clk),
        .rst(rst),
        .aluControl(ALUselect),
        .immSel(IMMselect),
        .regwen(regwen),
        .bsel(bsel)
    );
    
    RegisterFile registers(
                .clk(clk),
                .rst(rst),
                .rsi1(rsi1),
                .rsi2(rsi2),
                .rdi(rdi),
                .rd(rd),
                .write_enable(regwen),
                .rs1(rs1),
                .rs2(rs2)
                );
    
    ImmediateGenerator immGen(
                            .ins(ins),
                            .immSel(IMMselect),
                            .imm31_0(immediateValue)
                        ); 
    
    ALU alu(
            .clk(clk),
            .rst(rst),
            .dataA(rs1),
            .dataB(dataB),
            .sel(ALUselect),
            .dataD(ALUoutput),
            .ready(ready)
        );
    
    
    
endmodule

