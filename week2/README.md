# VSDBabySoC - Open-Source RISC-V System on Chip

![VSDBabySoC Architecture](vsd_baby_Soc.png)

A fully integrated, compact System on Chip (SoC) implementation featuring a RISC-V processor (RVMYTH), analog clock generation via Phase-Locked Loop (PLL), and digital-to-analog conversion capabilities. Built on Sky130 technology as an educational and experimental platform for digital design, mixed-signal interfacing, and RISC-V architecture exploration.

---

## Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Core Components](#core-components)
- [Understanding SoC Technology](#understanding-soc-technology)
- [Applications](#applications)

---

## Overview

VSDBabySoC represents a complete, functional SoC designed to bridge the gap between theoretical digital design knowledge and practical mixed-signal system implementation. This project integrates three distinct open-source IP cores into a cohesive system capable of processing digital instructions and generating analog outputs suitable for real-world interfacing.

### Project Goals

**Primary Objectives:**
- Demonstrate end-to-end SoC design methodology from RTL to analog output
- Provide hands-on experience with RISC-V processor integration
- Showcase mixed-signal design techniques combining digital and analog domains
- Create a reproducible, well-documented reference design for learning

**Technical Achievements:**
- Complete RISC-V instruction execution pipeline
- Stable clock generation with 8x frequency multiplication
- 10-bit resolution analog output generation
- Fully synthesizable using open-source tools and Sky130 PDK

### Why VSDBabySoC?

Modern electronic systems increasingly rely on SoC architectures that combine processing, timing, and interface capabilities on a single chip. VSDBabySoC serves as a miniaturized model of these complex systems, making advanced concepts accessible through:

- **Open-source ecosystem**: Every component uses freely available tools and IP
- **Educational focus**: Extensive documentation explaining design decisions
- **Practical application**: Real analog outputs demonstrating system functionality
- **Scalable foundation**: Architecture extensible for additional features

---

## System Architecture

VSDBabySoC employs a streamlined three-component architecture where each block performs a specialized function while maintaining tight integration with other subsystems.

### Architectural Overview

```
                    ┌─────────────────────────────────┐
                    │      VSDBabySoC System          │
                    │                                 │
   Reference   ──▶  │  ┌───────────────────┐         │
     Clock          │  │   Phase-Locked    │         │
                    │  │   Loop (PLL)      │         │
                    │  │   8x Multiplier   │         │
                    │  └─────────┬─────────┘         │
                    │            │ System Clock      │
                    │            ▼                   │
                    │  ┌───────────────────┐         │
                    │  │   RVMYTH Core     │         │
                    │  │   RISC-V CPU      │         │
                    │  │   (32-bit)        │         │
                    │  └─────────┬─────────┘         │
                    │            │ r17[9:0]          │
                    │            ▼                   │
                    │  ┌───────────────────┐         │
                    │  │   10-bit DAC      │         │  Analog
                    │  │   R-2R Ladder     │  ─────▶ │  Output
                    │  └───────────────────┘         │  Signal
                    │                                 │
                    └─────────────────────────────────┘
```

### Data Flow

1. **Clock Domain**: PLL receives reference clock, generates stable system clock at 8x frequency
2. **Processing Domain**: RVMYTH executes instructions, outputs digital data via register r17
3. **Analog Domain**: DAC converts 10-bit digital values to proportional analog voltage
4. **Output Interface**: Analog signal available for external device connection

---

## Core Components

### RVMYTH - RISC-V Processor Core

RVMYTH implements a subset of the RISC-V RV32I instruction set, providing a functional 32-bit processor capable of executing standard RISC-V programs. The core is specifically configured for VSDBabySoC to generate data patterns for DAC conversion.

**Architecture Features:**
- **ISA**: RISC-V RV32I base integer instruction set
- **Pipeline**: Multi-stage pipeline with hazard detection
- **Register File**: 32 general-purpose registers (x0-x31)
- **Data Path**: 32-bit data width throughout
- **Output Interface**: Register r17 dedicated to DAC data

**Key Capabilities:**
- Executes arithmetic, logical, and control flow instructions
- Supports immediate and register-register operations
- Generates sequential or computed data patterns
- Fully synthesizable Verilog implementation

**Design Advantages:**
- Small footprint suitable for educational purposes
- Modular design enabling easy modification
- Clear signal interfaces for integration
- Comprehensive testbench support

---

### Phase-Locked Loop (PLL)

The PLL subsystem generates a stable, phase-coherent clock signal synchronized to an external reference. This component is critical for maintaining timing consistency across all digital logic while providing frequency multiplication.

![PLL Block Diagram](PLL_Diagram.avif)

**Architecture Components:**

1. **Phase Frequency Detector (PFD)**
   - Compares reference clock phase with feedback signal
   - Generates error pulses indicating phase difference
   - Operates on both rising and falling edges for faster lock

2. **Charge Pump**
   - Converts PFD output pulses to analog control voltage
   - Determines loop dynamics and lock time
   - Filters high-frequency noise components

3. **Voltage-Controlled Oscillator (VCO)**
   - Generates output clock at frequency proportional to control voltage
   - Ring oscillator or LC tank implementation
   - Provides 8x frequency multiplication

4. **Frequency Divider**
   - Divides VCO output for feedback to PFD
   - Sets frequency multiplication ratio
   - Ensures stable lock condition

**Operating Principle:**

The PLL continuously adjusts VCO frequency until the feedback signal matches the reference in both frequency and phase. At lock, the system maintains a stable 8x multiplied clock with minimal jitter and phase noise.

**Why On-Chip PLL is Essential:**

Traditional approaches using external clocks face several limitations:

- **Propagation Delay**: Clock signals experience delay traversing long traces and multiple loads
- **Skew**: Different arrival times at various circuit blocks cause timing violations
- **Jitter**: Noise coupling introduces phase uncertainty in distributed networks
- **Multi-Frequency Requirements**: Different blocks often require different clock rates
- **Crystal Limitations**: External crystals have frequency tolerance (±50ppm typical) and temperature drift

An integrated PLL solves these issues by:
- Generating clean clocks locally near consumption points
- Multiplying a stable reference to required frequencies
- Compensating for process and temperature variations
- Reducing external component count and cost

---

### 10-Bit Digital-to-Analog Converter (DAC)

The DAC converts digital values from the RVMYTH processor into continuous analog voltages, enabling the SoC to interface with analog systems such as audio amplifiers, displays, or sensors.

**Specifications:**
- **Resolution**: 10 bits (1024 distinct output levels)
- **Architecture**: R-2R resistor ladder network
- **Input**: Parallel 10-bit digital word from r17 register
- **Output**: Analog voltage proportional to digital input
- **Reference**: External voltage reference for full-scale output

**DAC Architecture Options:**

#### Binary Weighted Resistor DAC

![Binary Weighted DAC](binary_weighted_resistors.jpg)

This approach uses resistors with values in binary ratios (R, 2R, 4R, 8R...). Each bit controls a switch connecting its resistor to the reference voltage. The summed currents produce the analog output.

**Advantages:**
- Simple concept, direct bit-to-current mapping
- Fast switching speed

**Disadvantages:**
- Wide resistor value range difficult to match accurately
- Sensitive to component variations
- Poor scalability to higher resolutions

#### R-2R Ladder DAC (Used in VSDBabySoC)

![R-2R Ladder DAC](R-2R_Ladder_DAC.webp)

The R-2R ladder uses only two resistor values (R and 2R) in a repeating network structure. Current division at each node creates binary-weighted contributions.

**Advantages:**
- Only two resistor values needed - easier matching
- Excellent scalability to any resolution
- Lower sensitivity to component variations
- Compact layout in IC implementation

**Disadvantages:**
- Slightly more complex analysis
- Requires accurate R and 2R ratio

**Operation:**

Each bit in the 10-bit input controls a switch that either connects its ladder node to the reference voltage (bit=1) or ground (bit=0). The ladder network performs binary-weighted current division, producing an output voltage:

```
V_out = V_ref × (Digital_Input / 1024)
```

For example:
- Digital input = 0000000000 (0) → V_out = 0V
- Digital input = 1111111111 (1023) → V_out ≈ V_ref
- Digital input = 1000000000 (512) → V_out ≈ V_ref/2

---

## Understanding SoC Technology

### What is a System on Chip?

A System on Chip integrates all necessary electronic components and subsystems of a computer or electronic system onto a single integrated circuit. Rather than assembling discrete chips on a circuit board, an SoC combines processing, memory, peripherals, and interfaces in one package.

![Modern SoC Example](intel_i7_13620.jpg)
*Example: Modern processors integrate CPU cores, GPU, memory controllers, and I/O in a single package*

**Fundamental SoC Elements:**

1. **Processing Units**
   - CPU cores: Execute program instructions
   - GPU: Handle graphics and parallel computations
   - DSP: Process signals (audio, video, communications)
   - Accelerators: Specialized units for specific tasks (AI, encryption)

2. **Memory Subsystem**
   - On-chip cache: Fast memory close to CPU
   - RAM controllers: Interface to external memory
   - ROM: Store boot code and firmware
   - Flash: Non-volatile program and data storage

3. **Interconnect Fabric**
   - Bus systems: Connect components (AHB, AXI, Wishbone)
   - Network-on-Chip: Scalable communication for many cores
   - Arbitration: Manage shared resource access
   - Clock distribution: Deliver synchronized timing

4. **Peripheral Interfaces**
   - GPIO: General purpose digital I/O pins
   - Serial interfaces: UART, SPI, I2C for communication
   - USB: Universal serial bus controllers
   - Ethernet: Network connectivity
   - ADC/DAC: Analog interfacing (like in VSDBabySoC)

5. **Power Management**
   - Voltage regulators: Generate required supply voltages
   - Clock gating: Disable unused blocks to save power
   - Power domains: Independently controllable regions
   - Dynamic voltage/frequency scaling: Adjust performance vs power

### SoC Categories

**By Application Complexity:**

1. **Microcontroller-based SoCs**
   - Integrate simple processor with peripherals
   - Target: Embedded control applications
   - Power: Ultra-low (microamps to milliamps)
   - Examples: IoT sensors, industrial controllers, automotive ECUs
   - Cost: Very low ($0.10 - $5)

2. **Microprocessor-based SoCs**
   - Powerful processors running operating systems
   - Target: Mobile computing, consumer electronics
   - Power: Moderate (hundreds of milliwatts to watts)
   - Examples: Smartphone processors, tablet chips
   - Cost: Moderate to high ($10 - $100+)

3. **Application-Specific SoCs**
   - Optimized for specific high-performance tasks
   - Target: Specialized workloads (AI, networking, graphics)
   - Power: Variable (optimized for task)
   - Examples: Network processors, AI accelerators, baseband chips
   - Cost: High ($50 - $500+)

**By Design Approach:**

- **ASIC (Application-Specific Integrated Circuit)**: Custom-designed for single purpose
- **ASSP (Application-Specific Standard Product)**: Standard design for common application
- **FPGA-based SoC**: Reconfigurable hardware + embedded processor

### SoC Design Advantages

**Integration Benefits:**
- **Reduced Size**: All components on one die vs multiple chips
- **Lower Power**: Shorter interconnects reduce capacitance and switching power
- **Higher Performance**: Tighter coupling enables faster communication
- **Lower Cost**: Fewer components, simpler board, lower assembly cost
- **Higher Reliability**: Fewer solder joints and connectors reduce failure points

**Design Flexibility:**
- **Customization**: Tailor components to application requirements
- **IP Reuse**: Leverage pre-designed blocks for faster development
- **Scalability**: Add or remove features by changing IP configuration
- **Integration Testing**: Verify complete system functionality early

### SoC Design Challenges

**Technical Complexity:**
- **Verification**: Testing all component interactions is time-consuming
- **Timing Closure**: Meeting timing across diverse clock domains is difficult
- **Power Distribution**: Ensuring stable power delivery across large die
- **Thermal Management**: Removing heat from densely packed logic
- **Mixed-Signal Design**: Isolating sensitive analog circuits from digital noise

**Business Considerations:**
- **Development Cost**: Multi-million dollar NRE (non-recurring engineering)
- **Time to Market**: 18-24 month typical development cycle
- **Risk**: Silicon bugs require expensive re-spins
- **IP Licensing**: Significant costs for commercial IP blocks
- **Foundry Access**: Limited vendors for advanced process nodes

**VSDBabySoC addresses learning aspects by:**
- Using open-source IP to eliminate licensing complexity
- Focusing on core concepts in a manageable design
- Providing complete source code for understanding
- Demonstrating real mixed-signal integration challenges

---

## Applications

VSDBabySoC's mixed-signal capabilities enable diverse practical applications:

**Educational Applications:**
- Teaching digital design and RISC-V architecture
- Demonstrating clock generation techniques
- Illustrating digital-to-analog conversion principles
- Providing hands-on SoC integration experience

**Prototyping Applications:**
- Signal generation for testing analog circuits
- Waveform synthesis for audio applications
- Control voltage generation for analog systems
- Reference design for custom SoC development

**Research Applications:**
- Exploring low-power design techniques
- Investigating clock distribution strategies
- Evaluating DAC architectures
- Studying mixed-signal integration challenges

---

## Project Status

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Version](https://img.shields.io/badge/version-1.0.0-orange)
![Contributors](https://img.shields.io/github/contributors/yourusername/vsdbabysoc)

**Current Version**: 1.0.0  
**Last Updated**: October 2025  
**Status**: Active Development

---

**⭐ If you find this project useful, please consider giving it a star on GitHub!**

---
