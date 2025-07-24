`timescale 1ns / 1ps

module Datapath(
    (* mark_debug = "true", keep = "true" *)
    input logic clk,
    (* mark_debug = "true", keep = "true" *)
    input logic rst
//    ,
//    (* DONT_TOUCH = "true" *)  // Prevent optimization
//    (* MARK_DEBUG = "true" *)   // Optional: Signal can be probed with ILA
//    output logic out
    );
    
    logic [31:0] ins;               // 32-bit instruction
    logic [4:0] rsi1, rsi2, rdi;    // address of rs1, rs2, rd within instructions
    
    logic [31:0] outPCPlus1, outPC, prev_outPC; // track Program counter values
    logic [31:0] PC_changed_mask;               // Check if Program counter has changed
    logic PC_changed, ready;                    
    
    logic regwen;               // Register Write enable
    logic bsel;                 // Switch between register and immediate inputs to ALU
    logic [4:0] ALUselect;      // Select ALU operation
    logic [2:0] IMMselect;      // Select immediate decoding scheme
    
    logic [31:0] immediateValue;    // Hold the extended (signed or otherwise) immediate value
    
    logic [31:0] rs1, rs2, rd;      // Contents of regsiters rs1, rs2, rd
    
    logic [31:0] dataB, ALUoutput;  // Second input to ALU and ALU output
    
    // Refer to instruction decoding in the ISA
    assign rdi = ins[11:7];        
    assign rsi1 = ins[19:15];
    assign rsi2 = ins[24:20];
   
    assign dataB = (bsel) ? immediateValue : rs2;   // Switch using bsel
    assign rd = ALUoutput;                          // Store output of ALU in rd
    
    //assign out = ALUoutput;                         // Store output of the ALU for debugging
    
    
    // Enable only if you need debugging on FPGA
    ila_0 cora_ila (
        .clk(clk), // input wire clk
        .probe0(outPC), // input wire [31:0]  probe0  
        .probe1(ALUoutput), // input wire [31:0]  probe1 
        .probe2(clk), // input wire [0:0]  probe2 
        .probe3(rst), // input wire [0:0]  probe3
        .probe4(ready)
    );
        
    ProgramCounter PC(
                    .inPC(outPCPlus1), 
                    .clk(clk), 
                    .rst(rst), 
                    .outPCPlus1(outPCPlus1), 
                    .outPC(outPC),
                    .ready(ready)
                    );
                    
    assign PC_changed_mask = prev_outPC ^ outPC;    // difference in PC
    assign PC_changed = |PC_changed_mask;           // if there is a difference in PC
    
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
            .rst(PC_changed), // ALU is reset every time PC changes
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

