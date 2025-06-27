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
    
    logic [33:0] multiplicand, multiplier;
    
    logic [67:0] mul_result;
    logic [31:0] div_rem_result;
    logic [1:0] div_rem_op;
    logic mul_done, div_done;
    
    assign is_muldiv = sel[4];
    assign is_mul = is_muldiv && sel[3];
    assign ready = (is_muldiv == 0) ? 1'b1 : (is_mul ? mul_done : div_done); // TO SIGNAL IF MULTIPLICATION/DIVISION IS DONE
    
    Booth4 booth_multiplier(
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .out(mul_result),
        .done(mul_done)
    );
    
    SRT2 SRT_divider(
        .rst(rst),
        .clk(clk),
        .numerator(dataA),
        .denominator(dataB),
        .op(div_rem_op),
        .out(div_rem_result),
        .done(div_done)
    );
    
    always_comb begin
        div_rem_op = 2'b00; // to prevent an inferred latch
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
                else dataD = 32'h00000000; 
            end
            'h1F: begin
                //MULH
                multiplicand = {{2{dataA[31]}}, dataA};
                multiplier = {{2{dataB[31]}}, dataB};
                if(mul_done) begin
                    dataD = mul_result[63:32];
                end
                else dataD = 32'h00000000; 
            end
            'h18: begin
                //MULHU
                multiplicand = {2'b00, dataA};
                multiplier = {2'b00, dataB};
                if(mul_done)dataD = mul_result[63:32];   // MULHU - multiply and produce upper 32 bits
                else dataD = 32'h00000000; 
            end
            'h19: begin
                //MULHSU
                multiplicand = {{2{dataA[31]}}, dataA};
                multiplier = {2'b00, dataB};
                if(mul_done)dataD = mul_result[63:32];   // MULHSU - multiply and produce upper 32 bits
                else dataD = 32'h00000000; 
            end
            'h12: begin
                div_rem_op = 2'b00;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = 32'h00000000;
            end
            'h13: begin
                div_rem_op = 2'b01;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = 32'h00000000;
            end
            'h14: begin
                div_rem_op = 2'b10;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = 32'h00000000;
            end
            'h15: begin
                div_rem_op = 2'b11;
                if(div_done) begin 
                    dataD = div_rem_result;
                end
                else dataD = 32'h00000000;
            end
            default: dataD = 32'hDEADBEEF;
        endcase
    end
    
    
endmodule
