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
    
    // We use 34-bit multiplication to support unsigned multiplication on Radix-4 Booth
    logic [33:0] multiplicand, multiplier;  // hold 34-bit values of multiplicand and multiplier
    logic [67:0] mul_result;                // hold the 68-bit value of the result of multiplication
    
    logic [31:0] div_rem_result;            // Hold the 32-bit result of the Division/remainder operation
    logic [1:0] div_rem_op;                 // Select between DIV, REM, DIVU and REMU
    
    logic mul_done, div_done;               // Signals for multiplication and division done  
    
    assign is_muldiv = sel[4];              // sel 
    assign is_mul = is_muldiv && sel[3];    // if high then multiplication, else division/remainder
    assign ready = (is_muldiv == 0) ? 1'b1 : (is_mul ? mul_done : div_done); // TO SIGNAL IF MULTIPLICATION/DIVISION IS DONE
    
    Booth4 booth_multiplier(
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .out(mul_result),
        .done(mul_done)
    );
    
    SRT2 divider(
        .rst(rst),
        .clk(clk),
        .dividend(dataA),
        .divisor(dataB),
        .op(div_rem_op),
        .out(div_rem_result),
        .done(div_done)
    );
    
    always_comb begin
        multiplicand = 0;
        multiplier = 0;
        div_rem_op = 2'b00;
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
                //MUL
                multiplicand = {2'b00, dataA};
                multiplier = {2'b00, dataB};
                if(mul_done) begin 
                    dataD = mul_result[31:0];
                end
                else dataD = '0; 
            end
            'h1F: begin
                //MULH - sign extend both operands
                multiplicand = {{2{dataA[31]}}, dataA};
                multiplier = {{2{dataB[31]}}, dataB};
                if(mul_done) begin
                    dataD = mul_result[63:32];
                end
                else dataD = '0; 
            end
            'h18: begin
                //MULHU - zero extend both operands
                multiplicand = {2'b00, dataA};
                multiplier = {2'b00, dataB};
                if(mul_done)dataD = mul_result[63:32];
                else dataD = '0; 
            end
            'h19: begin
                //MULHSU - sign extend dataA and zero extend dataB
                multiplicand = {{2{dataA[31]}}, dataA};
                multiplier = {2'b00, dataB};
                if(mul_done)dataD = mul_result[63:32];
                else dataD = '0; 
            end
            'h12: begin
                // DIV
                div_rem_op = 2'b00;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = '0;
            end
            'h13: begin
                // DIVU
                div_rem_op = 2'b01;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = '0;
            end
            'h14: begin
                // REM
                div_rem_op = 2'b10;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = '0;
            end
            'h15: begin
                // REMU
                div_rem_op = 2'b11;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = '0;
            end
            default: dataD = 32'hDEADBEEF;  // Debug if error in ALU control signals
        endcase
    end
    
    
endmodule