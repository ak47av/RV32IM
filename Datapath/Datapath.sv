`timescale 1ns / 1ps

module Datapath(
    (* mark_debug = "true", keep = "true" *)
    input logic clk,
    (* mark_debug = "true", keep = "true" *)
    input logic rst
    );
    
    logic [31:0] ins;               // 32-bit instruction
    logic [4:0] rsi1, rsi2, rdi;    // address of rs1, rs2, rd within instructions
    
    logic [31:0] outPCPlus4, outPC, prev_outPC; // track Program counter values
    logic [31:0] PC_changed_mask;               // Check if Program counter has changed
    logic PC_changed, ready;                    
    
    logic regwen;               // Register Write enable
    logic bsel;                 // Switch between register and immediate inputs to ALU
    logic [4:0] ALUselect;      // Select ALU operation
    logic [2:0] IMMselect;      // Select immediate decoding scheme
    logic [3:0] branchSelect;
    logic [2:0] loadSelect;
    logic [1:0] storeSelect;
    
    logic [31:0] immediateValue;    // Hold the extended (signed or otherwise) immediate value
    
    logic [31:0] rs1, rs2, rd;      // Contents of regsiters rs1, rs2, rd
    
    logic [31:0] dataB, ALUoutput;  // Second input to ALU and ALU output
    
    logic [31:0] branchPC, returnAddress;
    logic hasBranched, hasJumped;
    
    // Refer to instruction decoding in the ISA
    assign rdi = ins[11:7];        
    assign rsi1 = ins[19:15];
    assign rsi2 = ins[24:20];
   
    assign dataB = (bsel) ? immediateValue : rs2;   // Switch using bsel
    //assign rd = branchSelect[3] ? returnAddress : ALUoutput;
    
    parameter DATA_ADDR_WIDTH = 8;
    logic [DATA_ADDR_WIDTH-1:0] memory_addr;
    logic [3:0] byte_write_enable;
    logic [31:0] write_data;
    logic [31:0] read_data;
    logic [DATA_ADDR_WIDTH-1:0] debug_addr;
    logic [31:0] debug_data;
    logic [31:0] loadOut;
    
    // Enable only if you need debugging on FPGA
    ila_0 cora_ila (
        .clk(clk), // input wire clk
        .probe0(outPC), // input wire [31:0]  probe0  
        .probe1(ALUoutput), // input wire [31:0]  probe1 
        .probe2(clk), // input wire [0:0]  probe2 
        .probe3(rst), // input wire [0:0]  probe3
        .probe4(ready)
    );
    
    // Logic to load destination register
    always_comb begin
        // if JAL/JALR then store return address in rd
        if(branchSelect[3]) rd = returnAddress;
        // if load ins but not AUIPC, store output of loadcontrol in rd
        else if(|loadSelect) rd = loadOut;
        // else store ALUoutput in rd
        else rd = ALUoutput;
    end
        
    logic [31:0] inPC;
    //assign inPC = (|branchSelect) ? branchPC : outPCPlus4;
    
    // Logic to load Program Counter
    always_comb begin
        if(|branchSelect) inPC = branchPC; // if instruction is a branch one, modify PC
        else inPC = outPCPlus4; // else increment PC
    end
    
    ProgramCounter PC(
                    .inPC(inPC), 
                    .clk(clk), 
                    .rst(rst), 
                    .outPCPlus4(outPCPlus4), 
                    .outPC(outPC),
                    .ready(ready)
                    );
    
    BranchControl branch_control(
        .clk(clk),
        .brsel(branchSelect),
        .immediate(immediateValue),
        .PC(outPC),
        .ALUoutput(ALUoutput),
        .rs1(rs1),
        .PCnext(branchPC),
        .hasJumped(hasJumped),
        .hasBranched(hasBranched),
        .returnAddress(returnAddress)
    );
                    
    assign PC_changed_mask = prev_outPC ^ outPC;    // difference in PC
    assign PC_changed = |PC_changed_mask;           // if there is a difference in PC
    
    (* keep = "true" *) InstructionMemory ins_mem(
                        .addr(outPC[7:0]), // 8 bit address width - 256 instructions
                        .ins_out(ins)
                        );
    
    (* keep = "true" *) ControlLogic ctrlLogic(
        .ins(ins),
        .storeSel(storeSelect),
        .loadSel(loadSelect),
        .branchControl(branchSelect),
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
    
    DataMemory #(.ADDRESS_WIDTH(DATA_ADDR_WIDTH)) dataMemory (        
        .clk(clk),
        .rst(rst),
        .addr(ALUoutput[DATA_ADDR_WIDTH-1:0]), // from ALU
        .byte_write_enable(byte_write_enable),
        .write_data(write_data),
        .read_data(read_data),
        .debug_addr(debug_addr),
        .debug_data(debug_data)
    );
    
    LoadControl loadControl(
        .clk(clk),
        .load_word(read_data),
        .lsel(loadSelect), // edit control logic
        .PC(outPC), // for AUIPC
        .immediate(immediateValue),
        .out(loadOut) // will latch to PC if AUIPC
    );
    
    StoreControl storeControl(
        .clk(clk),
        .storeWord(rs2),
        .byte_enable_mask(byte_write_enable),
        .ssel(storeSelect),
        .storeOut(write_data)
    );
    
    always_ff @(posedge clk) begin
       prev_outPC <= outPC;
    end
    
endmodule