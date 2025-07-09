`timescale 1ns / 1ps

module Datapath(
    (* mark_debug = "true", keep = "true" *)
    input logic clk,
    (* mark_debug = "true", keep = "true" *)
    input logic rst
//    (* DONT_TOUCH = "true" *)  // Prevent optimization
//    (* MARK_DEBUG = "true" *)   // Optional: Signal can be probed with ILA
    //,output logic out
    );
    
    logic [31:0] ins;
    logic [4:0] rsi1, rsi2, rdi;
    
    logic [31:0] outPCPlus1, outPC, prev_outPC;
    logic [31:0] PC_changed_mask;
    logic PC_changed, ready;
    
    logic regwen, bsel;
    logic [4:0] ALUselect;
    logic [2:0] IMMselect;
    
    logic [31:0] immediateValue;
    
    logic [31:0] rs1, rs2, rd;    
    
    logic [31:0] dataB, ALUoutput;
    
    assign rdi = ins[11:7];
    assign rsi1 = ins[19:15];
    assign rsi2 = ins[24:20];
    
    assign dataB = (bsel) ? immediateValue : rs2;
    assign rd = ALUoutput;
    
   // assign out = ALUoutput;
    
    
    
    ila_0 cora_ila (
	.clk(clk), // input wire clk


	.probe0(outPC), // input wire [31:0]  probe0  
	.probe1(ALUoutput), // input wire [31:0]  probe1 
	.probe2(clk), // input wire [0:0]  probe2 
	.probe3(rst) // input wire [0:0]  probe3
);
        
    ProgramCounter PC(
                    .inPC(outPCPlus1), 
                    .clk(clk), 
                    .rst(rst), 
                    .outPCPlus1(outPCPlus1), 
                    .outPC(outPC),
                    .ready(ready)
                    );
                    
    assign PC_changed_mask = prev_outPC ^ outPC;
    assign PC_changed = |PC_changed_mask;
    
    (* keep = "true" *) InstructionMemory ins_mem(
                        .addr(outPC[4:0]),
                        .ins_out(ins)
                        );
    
    (* keep = "true" *) ControlLogic ctrlLogic(
        .ins(ins),
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
    
    (* keep = "true" *) ImmediateGenerator immGen(
                            .ins(ins),
                            .immSel(IMMselect),
                            .imm31_0(immediateValue)
                        ); 
    
    ALU alu(
            .clk(clk),
            .rst(PC_changed),
            .dataA(rs1),
            .dataB(dataB),
            .sel(ALUselect),
            .dataD(ALUoutput),
            .ready(ready)
        );
    
    always_ff @(posedge clk) begin
       prev_outPC <= outPC;
    end
    
endmodule

