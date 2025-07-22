`timescale 1ns / 1ps

// Unverified implementation of Nonrestoring division
// Implemented to compare LUT utilization against SRT division
module NonRestoringDivider #(parameter N=32)(
    input logic clk,
    input logic rst,
    input logic [1:0] op,
    input logic [N-1:0] dividend,
    input logic [N-1:0] divisor,
    output logic [N-1:0] out,
    output logic done
    );
    
    typedef enum logic [1:0] {IDLE, RUNNING, DONE} state_t;
    (* keep = "true" *) state_t state;
    
    logic [N-1:0] A, quotient, remainder;
    logic [N:0] B, P;
    logic [5:0] count;
    
    logic signed_div, is_rem;
    
    assign signed_div = (op == 2'b00 || op == 2'b10); // DIV/REM
    assign is_rem = (op == 2'b10 || op == 2'b11);
    
    logic [N-1:0] abs_dividend, abs_divisor;
    logic is_neg_dividend, is_neg_divisor;
    
    assign is_neg_dividend = signed_div && dividend[N-1];
    assign is_neg_divisor = signed_div && divisor[N-1];
    assign abs_dividend = is_neg_dividend ? -dividend : dividend;
    assign abs_divisor = is_neg_divisor ? -divisor : divisor;
    
    always_ff @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            A <= 0;
            B <= 0;
            P <= 0;
            count <= 0;
        end else begin
            case(state)
                IDLE: begin
                    if(divisor == 0) begin
                        remainder <= dividend;
                        quotient <= {N{1'b1}};
                        //$display("remainder: 0x%h, quotient: 0x%h", remainder, quotient);
                        state <= DONE;
                    end
                    else begin
                        // Initialize registers                        
                        A <= abs_dividend;
                        B <= (signed_div && is_neg_divisor) ? {1'b1, abs_divisor} : abs_divisor; 
                        P <= 0;                        
                        state <= RUNNING;
                        done <= 0;
                        count <= 0;
                    end
                end
                
                RUNNING: begin
//                    $display("[NRD] Iter %0d: P=0x%h, A=0x%h, B=0x%h", 
//                                    count, P, A, B);
                    if(count < N) begin
                        {P, A} = {P, A} << 1;
                        if (P[N]) begin
                            P = P + B;
                        end else begin
                            P = P - B;
                        end
                        A[0] = P[N] ? 0 : 1; 
                    end 
                    else begin
                        P <= (P[N] == 0) ? P:(P+B);
                        if (signed_div) begin
                            if(!is_rem) begin
                                quotient <= (is_neg_dividend ^ is_neg_divisor) ? -A : A;
                            end else begin
                                remainder <= is_neg_dividend ? -P : P;
                            end
                        end else begin
                            quotient <= A;
                            remainder <= P;
                        end
                        state <= DONE;
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    out <= is_rem ? remainder : quotient;
                    done <= 1;
                    state <= IDLE;
                end
            
            endcase
        end
    end
    
endmodule
