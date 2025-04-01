`timescale 1ns / 1ps

module Booth4 #(parameter N=32)(
    input logic rst, clk,
    input logic signed [N-1:0] multiplicand, multiplier,
    output logic signed [2*N-1:0] out,
    output logic [7:0] [N-1:0] BR,
    output logic [N-1:0] AC,
    output logic [N:0] Q,
    output logic [5:0] count,
    output logic done
);
    
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    //BR <= multiplicand;
                    BR[0] <= 0;
                    BR[1] <= multiplicand;
                    BR[2] <= multiplicand;
                    BR[3] <= multiplicand << 1;
                    BR[4] <= (-multiplicand) << 1;
                    BR[5] <= -multiplicand;
                    BR[6] <= -multiplicand;
                    BR[7] <= 0;
                    AC <= 0;
                    Q <= {multiplier, 1'b0};
                    state <= RUNNING;
                    done <= 0;
                    count <= 0;
                    out <= 0;
                end
                
                RUNNING: begin
                    if(count < (N >> 1)) begin
                        AC = AC + BR[Q[2:0]];
                        {AC, Q} = {AC[N-1], AC, Q[N:1]};
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
