import csv

input_csv = "control_rom.csv"
output_sv = "control_rom.sv"

with open(input_csv, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    with open(output_sv, "w") as out:
        out.write("module ControlROM (\n")
        out.write("    input  logic [7:0] addr,\n")
        out.write("    output logic [8:0] control\n")
        out.write(");\n\n")
        out.write("    always_comb begin\n")
        out.write("        case (addr)\n")

        for row in reader:
            ibin = row['ibin']
            obin = row['obin']
            addr_hex = f"9'h{int(ibin, 2):02X}"
            out.write(f"            {addr_hex}: control = 9'b{obin};\n")

        out.write("            default: control = 9'b000000000;\n")
        out.write("        endcase\n")
        out.write("    end\n\n")
        out.write("endmodule\n")
