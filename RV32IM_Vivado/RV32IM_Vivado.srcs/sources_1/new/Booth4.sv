`timescale 1ns / 1ps

module Booth4 #(parameter N=32)(
    input logic rst, clk,
    input logic [N-1:0] multiplicand, multiplier,
    //input logic signed_multiplicand,
    output logic [2*N-1:0] out,
    output logic [7:0] [N:0] BR,
    output logic [N:0] AC,
    output logic [N:0] Q,
    output logic [5:0] count,
    output logic done
);
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    state_t state;
    
    logic [N:0] BR_reg;
    //logic BR_MSB;
    //assign BR_MSB = signed_multiplicand ? multiplicand[N-1]:0;
    assign BR_reg = {multiplicand[N-1], multiplicand};
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            $display("Resetting Booth multiplier.");
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
                    $display("[Booth IDLE] multiplicand=%0h, multiplier=%0h", multiplicand, multiplier);
                end
                
                RUNNING: begin
                    if(count < (N >> 1)) begin
                    $display("[Booth RUNNING] count=%0d, AC=%0h, Q=%0h, BR[%0d]=%0h", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                        AC = AC + BR[Q[2:0]];
                      //  $display("[Booth RUNNING] count=%0d, AC=%0h, Q=%0h, BR[%0d]=%0h", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                        {AC, Q} = {{2{AC[N]}}, AC, Q[N:2]};
                        count = count + 1;                    
                        
                    end else begin
                        out <= {AC[N-1:0], Q[N:1]};
                        //out <= {Q[N:1]};
                        done <= 1;
                        state <= IDLE;
                        $display("[Booth DONE]", out);
                    end
                end
                
//                DONE: begin
//                    state <= IDLE;
//                    done <= 0;
//                    $display("[Booth DONE] Transitioning to IDLE");
//                end 
            endcase
        end
    end



endmodule
