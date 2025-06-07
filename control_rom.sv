module ControlROM (
    input  logic [7:0] addr,
    output logic [8:0] control
);

    always_comb begin
        case (addr)
            9'h0C: control = 9'b000010000;
            9'h10C: control = 9'b100010000;
            9'hCC: control = 9'b011010000;
            9'hEC: control = 9'b011110000;
            9'h2C: control = 9'b000110000;
            9'hAC: control = 9'b010110000;
            9'h1AC: control = 9'b110110000;
            9'h4C: control = 9'b001010000;
            9'h6C: control = 9'b001110000;
            9'h8C: control = 9'b010010000;
            9'h04: control = 9'b000010001;
            9'h104: control = 9'b000010001;
            9'h84: control = 9'b010010001;
            9'h184: control = 9'b010010001;
            9'hC4: control = 9'b011010001;
            9'h1C4: control = 9'b011010001;
            9'hE4: control = 9'b011110001;
            9'h1E4: control = 9'b011110001;
            9'h24: control = 9'b000110001;
            9'hA4: control = 9'b010110001;
            9'h1A4: control = 9'b110110001;
            9'h44: control = 9'b001010001;
            9'h144: control = 9'b001010001;
            9'h64: control = 9'b001110001;
            9'h164: control = 9'b001110001;
            default: control = 9'b000000000;
        endcase
    end

endmodule
