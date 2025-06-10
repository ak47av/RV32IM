`timescale 1ns / 1ps

module ALU(
    input logic clk,
    input logic rst,
    input logic [31:0] dataA,
    input logic [31:0] dataB,
    input logic [4:0] sel,
    output logic [31:0] dataD,
    output logic ready
    );
    
    logic [63:0] muldivResult;
    logic muldivDone;
    logic is_muldiv, is_muldiv_d;
    logic boothRst;
    
    assign is_muldiv = sel[4];
    assign ready = (is_muldiv == 0) || muldivDone; // TO SIGNAL IF MULTIPLICATION/DIVISION IS DONE
    assign boothRst = is_muldiv & ~is_muldiv_d;    // SIGNAL TO RESET BOOTH MULTIPLIER
    
    Booth4 multiplier(
        .clk(clk),
        .rst(boothRst),
        .multiplicand(dataA),
        .multiplier(dataB),
        .out(muldivResult),
        .done(muldivDone)
    );
    
    always @(*) begin
        case(sel)
            'h0: dataD = dataA + dataB;         // ADD  - Addition
            'h1: dataD = dataA << dataB[4:0];   // SLL  - Shift left logical
            'h2: dataD = $signed(dataA) < $signed(dataB) ? 1:0; // SLT  - Set lesser than
            'h3: dataD = $unsigned(dataA) < $unsigned(dataB) ? 1:0;    // SLTU - Set lesser than unsigned
            'h4: dataD = dataA ^ dataB;         // XOR - logical XOR
            'h5: dataD = dataA >> dataB[4:0];   // SRL - Shift Right Logical
            'h6: dataD = dataA || dataB;        // OR - logical OR
            'h7: dataD = dataA && dataB;        // AND - logical AND 
            'h8: dataD = dataA - dataB;         // SUB - Subtraction
            'h9: dataD = dataA != dataB ? 1:0;  // NEQ - not equal to
            'hA: dataD = dataA == dataB ? 1:0;  // EQ - equal to
            'hB: dataD = $signed(dataA) >= $signed(dataB) ? 1:0;     // GE - Greater than signed
            'hC: dataD = $unsigned(dataA) >= $unsigned(dataB) ? 1:0; // GEU - Greater than unsgined
            'hD: dataD = dataA >>> dataB[4:0];   // SRA - Shift right arithmetic 
            'h1E: begin
                if(muldivDone)dataD = muldivResult[31:0];   // MUL - multiply and produce lower 32 bits
                else dataD = 32'h00000000; 
            end
            'hF: dataD = 0; // unused
            default: dataD = 32'hDEADBEEF;
        endcase
    end
    
    always_ff @(posedge clk or posedge rst) begin
        $display("[ALU DEBUG] sel = %b, ready = %b", sel, ready);
        if(rst) is_muldiv_d <= 0;
        else is_muldiv_d <= is_muldiv;
    end
    
endmodule
