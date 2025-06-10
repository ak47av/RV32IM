`timescale 1ns / 1ps

module Booth4 #(parameter N=32)(
    input logic rst, clk,
    input logic [N-1:0] multiplicand, multiplier,
    output logic [2*N-1:0] out,
    output logic [7:0] [N:0] BR,
    output logic [N:0] AC,
    output logic [N:0] Q,
    output logic [5:0] count,
    output logic done
);
    
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            $display("Resetting Booth multiplier.");
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
                    $display("[Booth IDLE] multiplicand=%0d, multiplier=%0d", multiplicand, multiplier);
                end
                
                RUNNING: begin
                    if(count < (N >> 1)) begin
                        AC = AC + BR[Q[2:0]];
                        {AC, Q} = {AC[N], AC, Q[N:1]};
                        {AC, Q} = {AC[N], AC, Q[N:1]};
                        count = count + 1;                    
                        $display("[Booth RUNNING] count=%0d, AC=%0d, Q=%0d, BR[%0b]=%0d", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                    end else begin
                        //out <= {AC[N-1:0], Q[N:1]};
                        out <= {Q[N:1]};
                        done <= 1;
                        state <= DONE;
                        $display("[Booth DONE]", out);
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                    done <= 1;
                    $display("[Booth DONE] Transitioning to IDLE");
                end 
            endcase
        end
    end



endmodule
