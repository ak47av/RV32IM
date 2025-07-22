#### Outdated ROM Generator, requires modifications to work seamlessly
#### Copy and paste just the combinational block from the output control_rom.sv file into the ControlLogic.sv file
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
            addr_bin = f"10'b{ibin}"
            out.write(f"            {addr_bin}: control = 10'b{obin};\n")

        out.write("            default: control = 10'b0000010001;\n")
        out.write("        endcase\n")
        out.write("    end\n\n")
        out.write("endmodule\n")
