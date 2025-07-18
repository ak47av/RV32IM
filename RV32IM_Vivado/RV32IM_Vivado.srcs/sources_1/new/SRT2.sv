`timescale 1ns / 1ps

module SRT2 #(parameter N=32)(
    input logic rst, clk,
    input logic [N-1:0] numerator, denominator,
    input logic [1:0] op,
    output logic [N-1:0] out,
    output logic done
);
    
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    (* keep = "true" *) state_t state;
    
    logic [2:0] top3bits;
    logic [N:0] R;
    logic [N-1:0] Q;
    logic [5:0] count;
    logic [N:0] B;
    logic [N-1:0] quotient, remainder;
    
    logic signed_div, is_rem;
    
    assign signed_div = (op == 2'b00 || op == 2'b10); // DIV/REM
    assign is_rem = (op == 2'b10 || op == 2'b11);
    
    logic [N-1:0] abs_numerator, abs_denominator;
    logic is_neg_numerator, is_neg_denominator;
    logic [4:0] leading_zeros, shift_offset;
    
    assign is_neg_numerator = signed_div && numerator[N-1];
    assign is_neg_denominator = signed_div && denominator[N-1];
    assign abs_numerator = is_neg_numerator ? -numerator : numerator;
    assign abs_denominator = is_neg_denominator ? -denominator : denominator;
    
    LeadingZeroCounter lzc(.in(abs_denominator),
                           .out(leading_zeros) );
    
    always_ff @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            R <= 0;
            Q <= 0;
            B <= 0;
            count <= 0;
            out <= 0;
            
//            $display("[SRT IDLE] Reset complete.");
        end else begin
            case(state)
                IDLE: begin
                    if(denominator == 0) begin
                        remainder <= numerator;
                        quotient <= is_rem ? numerator : {N{1'b1}};
                        //$display("remainder: 0x%h, quotient: 0x%h", remainder, quotient);
                        state <= DONE;
                    end 
                    else begin
                        
                        // Initialize registers
                        R = 0;
                        Q = abs_numerator;
                        B = abs_denominator;
                        
                        {R, Q} = {R,Q} << leading_zeros;
                        B = B << leading_zeros;
                                                
                        state <= RUNNING;
                        done <= 0;
                        count <= 0;
                    end 
                end
                
                RUNNING: begin
                    if(count < N) begin
                        
                        top3bits = R[N:N-2];
                        {R,Q} = {R,Q} << 1;
                        
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
                        // Final correction step
                        if (R[N] == 1) begin
                            R = R + B;
                            Q = Q - 1;
                        end
                        // Shift back
                        R = R >> leading_zeros;
                        // Handle signed results
                        if (signed_div) begin
                            if(!is_rem) begin
                                quotient <= (is_neg_numerator ^ is_neg_denominator) ? -Q : Q;
                            end else begin
                                remainder <= is_neg_numerator ? -R[N-1:0] : R[N-1:0];
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