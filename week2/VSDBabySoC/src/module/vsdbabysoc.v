#!/bin/bash

# Fix vsdbabysoc.v - remove the 'cat' command wrapper
cat > src/module/vsdbabysoc.v << 'EOF'
module vsdbabysoc (
    output wire OUT,
    input wire reset,
    input wire VCO_IN,
    input wire ENb_CP,
    input wire ENb_VCO,
    input wire REF,
    input wire VREFL,
    input wire VREFH
);

wire CLK;
wire [9:0] RV_TO_DAC;

rvmyth core (
    .OUT(RV_TO_DAC),
    .CLK(CLK),
    .reset(reset)
);

avsdpll pll (
    .CLK(CLK),
    .VCO_IN(VCO_IN),
    .ENb_CP(ENb_CP),
    .ENb_VCO(ENb_VCO),
    .REF(REF)
);

avsddac dac (
    .OUT(OUT),
    .D(RV_TO_DAC),
    .VREFL(VREFL),
    .VREFH(VREFH)
);

endmodule
EOF

# Create output directory
mkdir -p output/pre_synth_sim

# Run iverilog compilation
echo "Compiling design..."
iverilog -o output/pre_synth_sim/pre_synth_sim.out \
    -DPRE_SYNTH_SIM \
    -I src/include \
    -I src/module \
    src/module/testbench.v \
    src/module/vsdbabysoc.v \
    src/module/rvmyth.v \
    src/module/avsdpll.v \
    src/module/avsddac.v \
    src/module/clk_gate.v

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo "Running simulation..."
    cd output/pre_synth_sim
    ./pre_synth_sim.out
    echo "Simulation complete! VCD file: pre_synth_sim.vcd"
else
    echo "Compilation failed!"
    exit 1
fi
