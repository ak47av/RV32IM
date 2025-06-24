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
    logic [7:0] [N:0] BR;
    logic [N:0] R;
    logic [N-1:0] Q;
    logic [5:0] count;
    logic [N:0] B;
    logic [N-1:0] quotient, remainder;
    
    logic [15:0] val16;
    logic [7:0] val8;
    logic [3:0] val4;
    logic [4:0] shift_result;
    logic signed_div, is_rem;
    
    assign signed_div = (op == 2'b00 || op == 2'b10); // DIV/REM
    assign is_rem = (op == 2'b10 || op == 2'b11);
    
    logic [N-1:0] abs_numerator, abs_denominator;
    logic is_neg_numerator, is_neg_denominator;
    
    assign is_neg_numerator = signed_div && numerator[N-1];
    assign is_neg_denominator = signed_div && denominator[N-1];
    assign abs_numerator = is_neg_numerator ? -numerator : numerator;
    assign abs_denominator = is_neg_denominator ? -denominator : denominator;
    
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
            BR <= '{default:0};
            shift_result <= 0;
            $display("[SRT IDLE] Reset complete.");
        end else begin
            case(state)
                IDLE: begin
                    if(denominator == 0) begin
                        remainder <= numerator;
                        quotient <= is_rem ? numerator : {N{1'b1}};
                        done <= 1;
                        state <= IDLE;
                    end else begin
                         //$display("[SRT] Starting %s operation: 0x%h / 0x%h", 
                                //op[1] ? (op[0] ? "REMU" : "REM") : (op[0] ? "DIVU" : "DIV"),
                                //numerator, denominator);
                                
                        // Calculate normalization shift amount
                        shift_result[4] = (denominator[31:16] == 16'b0);
                        val16 = shift_result[4] ? denominator[15:0] : denominator[31:16];
                        shift_result[3] = (val16[15:8] == 8'b0);
                        val8 = shift_result[3] ? val16[7:0] : val16[15:8];
                        shift_result[2] = (val8[7:4] == 4'b0);
                        val4 = shift_result[2] ? val8[3:0] : val8[7:4];
                        shift_result[1] = (val4[3:2] == 2'b0);
                        shift_result[0] = shift_result[1] ? ~val4[1] : ~val4[3];
                        
                        
                        // Initialize registers
                        R = 0;
                        Q = signed_div ? abs_numerator : numerator;
                        B = signed_div ? abs_denominator : denominator;
                        {R, Q} = {R,Q} << shift_result;
                        B = B << shift_result;
                        
                        // Initialize BR table
                        BR[3'b000] <= 0;
                        BR[3'b001] <= ~B + 1;
                        BR[3'b010] <= ~B + 1;
                        BR[3'b011] <= ~B + 1;
                        BR[3'b100] <= B;
                        BR[3'b101] <= B;
                        BR[3'b110] <= B;
                        BR[3'b111] <= 0;
                        
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
                        end else if (top3bits[2] == 1) begin
                            Q = Q - 1;
                        end else if (top3bits[2] == 0) begin
                            Q = Q + 1;
                        end
                        
                        quotient = quotient << 1;
                        R = R + BR[top3bits];
                         //$display("[SRT] Iter %0d: R=0x%h, Q=0x%h, top3=3'b%b", 
                                    //count, R, Q, top3bits);
                    end else begin
                        // Final correction step
                        if (R[N] == 1) begin
                            R = R + B;
                            Q = Q - 1;
                        end
                        
                        // Shift back
                        R = R >> shift_result;
                        
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
//                        $display("[SRT] Final results:");
//                        $display("      Quotient: 0x%h", quotient);
//                        $display("      Remainder: 0x%h", remainder);
                        //out <= op[1] ? remainder : quotient;
                        state <= DONE;
                        //done <= 1;
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    out <= op[1] ? remainder : quotient;
                    state <= IDLE;
                    done <= 1;
                end
                 
            endcase
        end
    end
endmodule