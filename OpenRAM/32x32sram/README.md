# 32x32 SRAM Module

## Overview

This directory contains a complete 32x32 SRAM (Static Random-Access Memory) design generated using **OpenRAM**, an open-source memory compiler. The SRAM is a 1KB memory module with 32 words of 32 bits each, fabricated using the **FreePDK45** technology node.

## Design Specifications

| Parameter | Value |
|-----------|-------|
| **Memory Type** | SRAM (Single Port, Read/Write) |
| **Word Size** | 32 bits |
| **Number of Words** | 32 |
| **Address Width** | 5 bits (log₂(32)) |
| **Total Capacity** | 1,024 bits (1 KB) |
| **Technology Node** | FreePDK45 |
| **Number of Banks** | 1 |
| **Column Multiplexer** | 1:1 |

## Files Description

### Configuration Files

- **[sram_32x32.py](sram_32x32.py)** - Main OpenRAM configuration file that defines SRAM parameters
  - Specifies technology: FreePDK45
  - Process corners: TT (Typical-Typical)
  - Supply voltage: 1.1V
  - Temperature: 25°C
  - Output path: sram_output

### Verilog Files

- **[sram_32x32.v](sram_32x32.v)** - Behavioral Verilog model
  - Synthesizable RTL representation of the SRAM
  - Single read/write port with clock (clk0)
  - Control signals: chip select (csb0), write enable (web0)
  - Address bus: addr0[4:0] for 32-word addressing
  - Data input: din0[31:0]
  - Data output: dout0[31:0]
  - Useful for simulation and functional verification

### SPICE Files

- **[sram_32x32.sp](sram_32x32.sp)** - Full transistor-level SPICE netlist
  - Complete schematic with all transistors and interconnects
  - Contains subcircuits for write drivers, read amplifiers, sense amplifiers, etc.
  - ~7,129 lines describing the entire SRAM structure
  - Used for detailed analog simulation and verification

- **[sram.sp](sram.sp)** - Trimmed/optimized SPICE netlist variant

- **[trimmed.sp](trimmed.sp)** - Additional trimmed SPICE version for specific analysis

- **[sram_32x32.lvs.sp](sram_32x32.lvs.sp)** - LVS (Layout vs. Schematic) verification netlist
  - Matches the physical layout for verification purposes

### Simulation and Characterization Files

- **[delay_meas.sp](delay_meas.sp)** - Delay measurement stimuli and measurement statements
  - Measures read/write delay
  - Measures slew rate (rise and fall times)
  - Measures power consumption during read/write
  - Probes internal signals like bitlines (bl, br)

- **[delay_stim.sp](delay_stim.sp)** - Stimulus file for delay characterization
  - Provides input vectors for timing analysis
  - Tests various slew rates and load capacitances

- **[functional_meas.sp](functional_meas.sp)** - Functional measurement commands
  - ~7,233 lines of measurement statements
  - Captures output values at specific time points
  - Verifies correct data retention and output

- **[functional_stim.sp](functional_stim.sp)** - Stimulus file for functional verification
  - Input patterns for comprehensive functional testing

### Layout and Physical Design Files

- **[sram_32x32.gds](sram_32x32.gds)** - GDS (GDSII) file
  - Physical layout of the SRAM in binary format
  - Contains all layers, polygons, and cells as drawn on silicon
  - Can be viewed in tools like KLayout

- **[sram_32x32.lef](sram_32x32.lef)** - LEF (Library Exchange Format) file
  - Abstract view of the SRAM for place-and-route tools
  - Defines pin locations, dimensions, and metal routing
  - Size: 118.685 µm × 76.22 µm
  - Includes all I/O pins with precise coordinates:
    - Data input pins: din0[0:31]
    - Data output pins: dout0[0:31]
    - Address pins: addr0[0:4]
    - Control pins: clk0, csb0, web0
    - Power pins: vdd, gnd

### Characterization Libraries

- **[sram_32x32_TT_1p0V_25C.lib](sram_32x32_TT_1p0V_25C.lib)** - Typical Corner Library at 1.0V
  - Cell delay and slew characterization
  - Read/write power consumption data
  - Timing models for synthesis tools

- **[sram_32x32_SS_1p0V_25C.lib](sram_32x32_SS_1p0V_25C.lib)** - Slow-Slow Corner Library at 1.0V
  - Worst-case timing for conservative design

- **[sram_32x32_TT_1p1V_25C.lib](sram_32x32_TT_1p1V_25C.lib)** - Typical Corner Library at 1.1V
  - Higher voltage operation characterization

- **[sram_32x32_FF_1p0V_25C.lib](sram_32x32_FF_1p0V_25C.lib)** - Fast-Fast Corner Library at 1.0V
  - Best-case timing for early design estimates

### Datasheet and Documentation

- **[datasheet.info](datasheet.info)** - Compiled datasheet information
  - Extracted from characterization results
  - Contains performance metrics across all corners:
    - Access times
    - Cycle times
    - Power consumption
    - Slew rates
    - Setup and hold times

- **[sram_32x32.html](sram_32x32.html)** - HTML report
  - Formatted summary of SRAM characteristics
  - Visual representation of performance data

- **[sram_32x32.log](sram_32x32.log)** - Generation and simulation log file
  - Records OpenRAM generation process
  - SPICE simulation messages and warnings

- **[klayout_printout.pdf](klayout_printout.pdf)** - Layout visualization
  - PDF export of the physical design as viewed in KLayout

### SRAM Source Configuration Directory

**[SRAM_src/](SRAM_src/)** - Alternative configuration examples

- **[myconfig.py](SRAM_src/myconfig.py)** - FreePDK45 configuration for 32x32 SRAM
  - Main configuration used for this implementation

- **[config_skywater130.py](SRAM_src/config_skywater130.py)** - Alternative SkyWater 130nm configuration
  - Example for 64-word SRAM in 130nm technology
  - Demonstrates design portability

- **[my_custom_cell.py](SRAM_src/my_custom_cell.py)** - Custom cell definition template

## Key Characteristics

### Performance Metrics (from datasheet.info)

**Typical Corner (TT) at 1.0V, 25°C:**
- Access Time (Read): ~0.236 ns
- Access Time (Write): ~0.151 ns
- Cycle Time: ~0.296 ns
- Power (Read Active): ~0.304 mW
- Power (Write Active): ~0.304 mW
- Leakage Power (Standby): ~0.001 mW

**Slow Corner (SS) at 1.0V, 25°C:**
- Slightly slower access times (~0.259 ns)
- Lower power consumption (~0.277 mW)

**Fast Corner (FF) at 1.0V, 25°C:**
- Faster access times (~0.212 ns)
- Higher power consumption (~0.338 mW)

### Port Architecture

The SRAM features a single **Read/Write port (Port 0)** with:

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| clk0 | Input | 1 | Clock signal |
| csb0 | Input | 1 | Chip Select (active low) |
| web0 | Input | 1 | Write Enable (active low) |
| addr0 | Input | 5 | Address bus |
| din0 | Input | 32 | Data input bus |
| dout0 | Output | 32 | Data output bus |
| vdd | Power | 1 | Supply voltage |
| gnd | Ground | 1 | Ground reference |

## OpenRAM Generator Overview

This SRAM was generated using **OpenRAM**, an open-source memory compiler that:

1. **Generates hierarchical designs** with bit cells, sense amplifiers, write drivers, and peripheral circuits
2. **Performs SPICE simulation** to characterize timing and power
3. **Creates multiple format outputs** (SPICE, Verilog, LEF, GDS)
4. **Supports multiple technology nodes** (FreePDK45, SkyWater 130, etc.)
5. **Enables customization** through configuration files

## Technology Details

**FreePDK45 Technology:**
- 45 nm process node
- Single track (1T) SRAM bit cell
- Low power design suitable for embedded systems
- Open-source PDK available from OSU

## Design Flow

```
Configuration (sram_32x32.py)
        ↓
   OpenRAM Generation
        ↓
   Verilog Model ──→ Simulation & Verification
        ↓
   SPICE Netlist ──→ HSPICE Characterization
        ↓
   GDS Layout & LEF ──→ Place & Route
        ↓
   Timing Libraries (.lib) ──→ Synthesis & STA
```

## Usage Instructions

### 1. Functional Simulation
```bash
# Use the Verilog model for RTL simulation
iverilog -o sram_test sram_32x32.v tb_sram_32x32.v
vvp sram_test
```

### 2. Detailed SPICE Simulation
```bash
# Run SPICE simulation for timing/power analysis
ngspice sram_32x32.sp
```

### 3. Physical Implementation
- Use `sram_32x32.lef` for place-and-route tools (Cadence Innovus, OpenROAD)
- Use `sram_32x32.gds` for physical verification and tape-out

### 4. Synthesis and Static Timing Analysis
- Import `.lib` files into synthesis tools (Synopsys DC, Yosys)
- Generate timing constraints for STA (static timing analysis)

## Regenerating the SRAM

To regenerate or modify this SRAM:

1. Edit `sram_32x32.py` with new specifications
2. Run OpenRAM:
   ```bash
   python -m openram.openram -c sram_32x32.py
   ```
3. All output files will be regenerated in the `sram_output/` directory

## Pin Layout (From LEF)

The SRAM uses metal layer 4 for all signal routing:

- **Size**: 118.685 µm (width) × 76.22 µm (height)
- **Data Input Pins**: din0[0] through din0[31], placed horizontally
- **Data Output Pins**: dout0[0] through dout0[31], placed horizontally
- **Address Pins**: addr0[0] through addr0[4]
- **Control Pins**: clk0, csb0, web0
- **Power Pins**: vdd, gnd (distributed for current delivery)
- **Symmetry**: X, Y, and R90 symmetry supported

## Related Files

- **Parent Directory**: [OpenRAM/](../README.md) - Overview of OpenRAM memory designs
- **Configuration Sources**: [SRAM_src/](SRAM_src/README.md) - Alternative configurations and custom cells

## Summary

This 32x32 SRAM module represents a complete, production-ready memory design in the FreePDK45 technology node. It includes:

✅ Behavioral simulation models (Verilog)
✅ Detailed analog models (SPICE)
✅ Characterized timing libraries (.lib)
✅ Physical layout (GDS, LEF)
✅ Comprehensive documentation (datasheet, HTML)
✅ Measurement and verification benches

This design can be integrated into larger SoCs (Systems-on-Chip) or used for standalone memory applications.

