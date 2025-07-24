`timescale 1ns / 1ps

// Radix-4 Booth multiplier performs multiplication in 16+4(setup) cycles
module Booth4 #(parameter N=34)(
    input logic rst, clk,
    input logic [N-1:0] multiplicand, multiplier,
    output logic [2*N-1:0] out,
    output logic done
);
    
    // State enumeration
    typedef enum logic {IDLE, RUNNING} state_t;
    (* keep = "true" *) state_t state;
    
    logic [7:0] [N:0] BR;   // lookup table
    logic [N:0] AC;         // Holds upper word of multiplication result
    logic [N:0] Q;          // Holds lower word of multiplication result
    logic [5:0] count;      // Counts the number of iterations
    
    logic [N:0] BR_reg;
    assign BR_reg = {multiplicand[N-1], multiplicand};
    
    always_ff @(posedge clk) begin
        if(rst) begin
            // Reset state to IDLE and reinitialize registers to 0
            state <= IDLE;
            AC <= 0;
            Q <= 0;
            count <= 0;
            done <= 0;
            out <= 0;
        end else begin
            case(state)
                IDLE: begin
                    // Setup the lookup table and functional registers
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
                end
                
                RUNNING: begin
                    if(count < (N >> 1)) begin
                        // Perform for 32/2 = 16 iterations since Radix-4
                            //$display("[Booth RUNNING] count=%0d, AC=%09h, Q=%09h, BR[%0d]=%09h", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                        AC = AC + BR[Q[2:0]]; // Add to AC based on Q bottom 3 bits
                            //$display("[Booth RUNNING] count=%0d, AC=%09h, Q=%09h, BR[%0d]=%09h", count, AC, Q, Q[2:0], BR[Q[2:0]]);
                        {AC, Q} = {{2{AC[N]}}, AC, Q[N:2]}; // Left shift {AC,Q} by 2 bits
                        count = count + 1;                    
                        
                    end else begin
                        out <= {AC[N-1:0], Q[N:1]}; // Ignore top and bottom bit
                        done <= 1;
                        state <= IDLE;
                    end
                end
                
            endcase
        end
    end



endmodule