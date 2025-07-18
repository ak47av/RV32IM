`timescale 1ns / 1ps

module Booth4 #(parameter N=34)(
    input logic rst, clk,
    input logic [N-1:0] multiplicand, multiplier,
    output logic [2*N-1:0] out,
    output logic done
);
    typedef enum logic {IDLE, RUNNING} state_t;
    (* keep = "true" *) state_t state;
    
    logic [7:0] [N:0] BR;
    logic [N:0] AC;
    logic [N:0] Q;
    logic [5:0] count;
    
    logic [N:0] BR_reg;
    assign BR_reg = {multiplicand[N-1], multiplicand};
    
    always_ff @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
            AC <= 0;
            Q <= 0;
            count <= 0;
            done <= 0;
            out <= 0;
            //$display("[Booth] Resetting Booth multiplier.");
        end else begin
            case(state)
                IDLE: begin
                    BR[0] <= 0;
                    BR[1] <= BR_reg;
                    BR[2] <= BR_reg;
                    BR[3] <= BR_reg << 1;
                    BR[4] <= (~(BR_reg << 1)) + 1;
                    BR[5] <= (~BR_reg) + 1;
                    BR[6] <= (~BR_reg) + 1;
                    BR[7] <= 0;
                    AC <= 0;
                    Q <= {multiplier, 1'b0};
                    state <= RUNNING;
                    done <= 0;
                    count <= 0;
                    out <= 0;
                    //$display("[Booth IDLE] multiplicand=%0h, multiplier=%0h", multiplicand, multiplier);
                end
                
                RUNNING: begin
                    if(count < (N >> 1)) begin
                        //$display("[Booth RUNNING] count=%0d, AC=%09h, Q=%09h, BR[%0d]=%09h", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                        AC = AC + BR[Q[2:0]];
                        //$display("[Booth RUNNING] count=%0d, AC=%09h, Q=%09h, BR[%0d]=%09h", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                        {AC, Q} = {{2{AC[N]}}, AC, Q[N:2]};
                        count = count + 1;                    
                        
                    end else begin
                        out <= {AC[N-1:0], Q[N:1]};
                        //out <= {Q[N:1]};
                        done <= 1;
                        state <= IDLE;
//                        $display("[Booth DONE]", out);
                    end
                end
                
            endcase
        end
    end



endmodule