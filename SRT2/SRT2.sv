`timescale 1ns / 1ps

module SRT2 #(parameter N=32)(
    input logic rst, clk,
    input logic signed [N-1:0] numerator, denominator,
    output logic signed [N-1:0] quotient, remainder,
    output logic [2:0] top3bits,
    output logic [7:0] [N:0] BR,
    output logic [N:0] R,
    output logic [N-1:0] Q,
    output logic [5:0] count,
    output logic done
);
    
    // State variables
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state;
    
    logic [N:0] B;      // denominator after shifting out leading zeroes
    // Intermediate variables for calculating the leading zeroes
    logic [15:0] val16;
    logic [7:0] val8;
    logic [3:0] val4;
    logic [4:0] result; // Holds the number of leading zeroes
    
    always_ff @(posedge clk or posedge rst) begin
        // Return to IDLE state if rst
        if(rst) begin
            state <= IDLE;
        end else begin
        // Begin the division process
            case(state)
                IDLE: begin
                    // Calculate the number of leading zeroes with a combinational circuit
                    result[4] = (denominator[31:16] == 16'b0);
                    val16     = result[4] ? denominator[15:0] : denominator[31:16];
                    result[3] = (val16[15:8] == 8'b0);
                    val8      = result[3] ? val16[7:0] : val16[15:8];
                    result[2] = (val8[7:4] == 4'b0);
                    val4      = result[2] ? val8[3:0] : val8[7:4];
                    result[1] = (val4[3:2] == 2'b0);
                    result[0] = result[1] ? ~val4[1] : ~val4[3];
                    
                    // Setup the Divider circuit
                    R = 0;  // Hold the remainder
                    Q = numerator;  // Hold the Quotient
                    {R, Q} = {R,Q} << result;   // Shift left by the number of leading zeros
                    
                    B = denominator << result;
                    // Table to hold the coefficients
                    BR[3'b000] <= 0;
                    BR[3'b001] <= -B;
                    BR[3'b010] <= -B;
                    BR[3'b011] <= -B;
                    BR[3'b100] <= B;
                    BR[3'b101] <= B;
                    BR[3'b110] <= B;
                    BR[3'b111] <= 0;
                    
                    // Move to the running state
                    state <= RUNNING;
                    done <= 0;
                    count <= 0;
                    quotient <= 0;
                    remainder <= 0;
                end
                
                RUNNING: begin
                  // the division process goes through 32 iterations, one for every clock cycle
                    if(count < N) begin
                    // The selection is based on the most significant 3 bits
                       top3bits = R[N:N-2];
                       {R,Q} = {R,Q} << 1;
                       if (top3bits == {3{1'b1}} || top3bits == {3{1'b0}}) begin
                            Q = Q + 0;
                       end else if (top3bits[2] == 1) begin
                            Q = Q - 1;
                       end else if (top3bits[2] == 0) begin
                            Q = Q + 1;
                       end
                       quotient = quotient << 1;
                       R = R + BR[top3bits];
                    end else begin
                        // If the number is negative, add B back to the remainder and -1 from the quotient
                        if (R[N] == 1) begin
                            R = R + B;
                            Q = Q - 1;
                        end
                        R = R >> result;
                        state <= DONE;
                        done <= 1;
                        remainder <= R[N-1:0];
                        quotient <= Q;
                    end
                    // increment the count for every iteration
                    count = count + 1;
                end
                
                DONE: begin    
                    state <= IDLE;
                    done <= 0;
                end 
            endcase
        end
    end



endmodule