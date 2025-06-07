`timescale 1ns / 1ps

module ALU(
    input logic clk,
    input logic rst,
    input logic [31:0] dataA,
    input logic [31:0] dataB,
    input logic [3:0] sel,
    output logic [31:0] dataD
    );
    
    //logic [31:0] dataD;
    
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
            'hE: dataD = 0; // unused
            'hF: dataD = 0; // unused
            default: dataD = 32'hDEADBEEF;
        endcase
    end
    
    always_ff @(posedge clk or posedge rst) begin
        $display("dataA: %h, dataB: %h, dataD:%h", dataA, dataB, dataD);
//        if(rst) out <= 0;
//        else out <= dataD;
    end
    
endmodule
