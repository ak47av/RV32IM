`timescale 1ns / 1ps

module SRT2 #(parameter N=32)(
    input logic rst, clk,
    input logic [N-1:0] dividend, divisor,
    input logic [1:0] op,
    output logic [N-1:0] out,
    output logic done
);
    
    // State enumeration
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    (* keep = "true" *) state_t state;
    
    logic [2:0] top3bits;       // Hold most significant 3 bits of R
    logic [N:0] R;              // Will hold intermediate remainders
    logic [N-1:0] Q;            // Wild hold intermeidate quotients
    logic [5:0] count;          // Count the iterations
    logic [N:0] B;              // Hold the modified divisor
    logic [N-1:0] quotient, remainder;  
    
    // Decode between DIV, DIVU, REM and REMU
    logic signed_div, is_rem;   
    
    assign signed_div = (op == 2'b00 || op == 2'b10); // DIV/REM
    assign is_rem = (op == 2'b10 || op == 2'b11);   // REM/REMU
    
    // Hold absolute values of dividend and divisor
    logic [N-1:0] abs_dividend, abs_divisor;
    // Check if dividend or divisor are negative
    logic is_neg_dividend, is_neg_divisor;
    // Count the number of leading zeros
    logic [4:0] leading_zeros;
    
    assign is_neg_dividend = signed_div && dividend[N-1];
    assign is_neg_divisor = signed_div && divisor[N-1];
    assign abs_dividend = is_neg_dividend ? -dividend : dividend;
    assign abs_divisor = is_neg_divisor ? -divisor : divisor;
    
    // Potential point of optimization using pipeline registers
    LeadingZeroCounter lzc(.in(abs_divisor),
                           .out(leading_zeros) );
    
    always_ff @(posedge clk) begin
        if(rst) begin
            // Reset to IDLE state and assign zero to all registers
            state <= IDLE;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            R <= 0;
            Q <= 0;
            B <= 0;
            count <= 0;
            out <= 0;
        end else begin
            case(state)
                IDLE: begin
                    // Check if Division by zero
                    if(divisor == 0) begin
                        // Refer to ISA for remainder and quotient output when divide by zero
                        remainder <= dividend;
                        quotient <= is_rem ? dividend : {N{1'b1}};
                        state <= DONE;
                    end 
                    else begin
                        // Initialize registers according to Radix-2 SRT
                        R = 0;
                        Q = abs_dividend;
                        B = abs_divisor;
                        
                        {R, Q} = {R,Q} << leading_zeros;
                        B = B << leading_zeros;
                                                
                        state <= RUNNING;
                        done <= 0;
                        count <= 0;
                    end 
                end
                
                RUNNING: begin
                    if(count < N) begin
                        // Perform for 32 iterations
                        
                        top3bits = R[N:N-2];
                        {R,Q} = {R,Q} << 1; // Shift RQ left every iteration
                        
                        // SRT selection logic
                        if (top3bits == {3{1'b1}} || top3bits == {3{1'b0}}) begin
                            Q = Q + 0;
                            R = R + 0;
                        end else if (top3bits[2] == 1) begin
                            Q = Q - 1;
                            R = R + B;
                        end else if (top3bits[2] == 0) begin
                            Q = Q + 1;
                            R = R + (~B + 1);
                        end
                        
//                         $display("[SRT] Iter %0d: R=0x%h, Q=0x%h, top3=3'b%b BR=0x%h", 
//                                    count, R, Q, top3bits, BR[top3bits]);
                    end else begin
                        // Final correction step if remainder is negative
                        if (R[N] == 1) begin
                            R = R + B;  // Add B to remainder
                            Q = Q - 1;  // Subtract 1 from quotient
                        end
                        
                        // Shift back to compensate for earlier left shift
                        R = R >> leading_zeros;
                        
                        // Handle signed results
                        if (signed_div) begin
                            if(!is_rem) begin
                                quotient <= (is_neg_dividend ^ is_neg_divisor) ? -Q : Q;
                            end else begin
                                remainder <= is_neg_dividend ? -R[N-1:0] : R[N-1:0];
                            end
                        end else begin
                            quotient <= Q;
                            remainder <= R[N-1:0]; 
                        end
                        
                        state <= DONE;
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    out <= is_rem ? remainder : quotient;
                    state <= IDLE;
                    done <= 1;
                end
                 
            endcase
        end
    end
endmodule