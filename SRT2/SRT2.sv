`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2025 10:09:29
// Design Name: 
// Module Name: SRT2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SRT2 #(parameter N=32)(
    input logic rst, clk,
    input logic unsigned [N-1:0] numerator, denominator,
    output logic unsigned [N-1:0] quotient, remainder,
    output logic [2:0] top3bits,
    output logic [7:0] [N:0] BR,
    output logic [N:0] R,
    output logic [N-1:0] Q,
    output logic [5:0] count,
    output logic done
);
    
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state;
    
    logic [N:0] B;
    logic [4:0] shift;
    logic [15:0] val16;
    logic [7:0] val8;
    logic [3:0] val4;
    logic [4:0] result;
    //logic [2:0] top3bits;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    //BR <= multiplicand;
                    result[4] = (denominator[31:16] == 16'b0);
                    val16     = result[4] ? denominator[15:0] : denominator[31:16];
                    result[3] = (val16[15:8] == 8'b0);
                    val8      = result[3] ? val16[7:0] : val16[15:8];
                    result[2] = (val8[7:4] == 4'b0);
                    val4      = result[2] ? val8[3:0] : val8[7:4];
                    result[1] = (val4[3:2] == 2'b0);
                    result[0] = result[1] ? ~val4[1] : ~val4[3];
                    
                    R = 0;
                    Q = numerator;
                    {R, Q} = {R,Q} << result;
                    
                    B = denominator << result;
                    BR[3'b000] <= 0;
                    BR[3'b001] <= -B;
                    BR[3'b010] <= -B;
                    BR[3'b011] <= -B;
                    BR[3'b100] <= B;
                    BR[3'b101] <= B;
                    BR[3'b110] <= B;
                    BR[3'b111] <= 0;
                    
                    state <= RUNNING;
                    done <= 0;
                    count <= 0;
                    quotient <= 0;
                    remainder <= 0;
                end
                
                RUNNING: begin
                    if(count < N) begin
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