`timescale 1ns / 1ps

module Booth2 #(parameter N=32)(
    input logic rst, clk,
    input logic signed [N-1:0] multiplicand, multiplier,
    output logic signed [2*N-1:0] out,
    output logic done
);

    logic [N-1:0] BR;
    logic [N-1:0] negBR;
    logic [N-1:0] AC;
    logic [N:0] Q;
    logic [5:0] count;
    
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    BR <= multiplicand;
                    negBR <= -multiplicand;
                    AC <= 0;
                    Q = {multiplier, 1'b0};
                    state = RUNNING;
                    done <= 0;
                    count <= 0;
                    out <= 0;
                end
                
                RUNNING: begin
                    if(count < N) begin
                        case(Q[1:0])
                            2'b10: AC = AC + negBR;
                            2'b01: AC = AC + BR;
                            default: AC = AC;
                        endcase
                        {AC, Q} = {AC[N-1], AC, Q[N:1]};
                        count = count + 1;
                    end else begin
                        out <= {AC, Q[N:1]};
                        done <= 1;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                    done <= 0;
                end 
            endcase
        end
    end



endmodule

