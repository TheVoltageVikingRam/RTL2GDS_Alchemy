# Day 1: Introduction to Verilog RTL Design & Synthesis

Welcome to my **Day 1** RTL Workshop report!  
Today, I embarked on my journey into digital design by learning Verilog, open-source simulation with **Icarus Verilog (iverilog)**, and the basics of logic synthesis using **Yosys**. This report documents my practical labs, key learnings, and hands-on experiences as I built a strong foundation in RTL design.

---

## 📚 Table of Contents
1. [What I Learned: Simulator, Design, and Testbench](#1-what-i-learned-simulator-design-and-testbench)
2. [Getting Started with iverilog](#2-getting-started-with-iverilog)
3. [My Lab Experience: Simulating a 2-to-1 Multiplexer](#3-my-lab-experience-simulating-a-2-to-1-multiplexer)
4. [My Verilog Code Analysis](#4-my-verilog-code-analysis)
5. [Introduction to Yosys & Gate Libraries](#5-introduction-to-yosys--gate-libraries)
6. [Understanding .lib Files and Gate Flavors](#6-understanding-lib-files-and-gate-flavors)
7. [My Synthesis Lab with Yosys](#7-my-synthesis-lab-with-yosys)
8. [Verification of My Synthesis](#8-verification-of-my-synthesis)
9. [Summary of My Learning](#9-summary-of-my-learning)

---

## 1. What I Learned: Simulator, Design, and Testbench

### 🔧 Simulator
Through my studies, I learned that a **simulator** is a software tool that checks digital circuit functionality by applying test inputs and viewing outputs. This helps me verify my design before hardware implementation.

### 🎯 Design
I discovered that the **design** is my Verilog code describing the intended logic functionality - the **behavioral representation** of the required specification.

### 🧪 Testbench
I understood that a **testbench** is a simulation environment that applies various inputs to my design and checks if the outputs are correct.

---

## 2. Getting Started with iverilog

**iverilog** is an open-source simulator for Verilog that I used throughout my lab. Here's the simulation flow I followed:

```
My Design (RTL) + My Testbench → iverilog → Executable → VCD file → GTKWave
```

I learned that both my design and testbench are provided as input to iverilog, and the simulator produces a `.vcd` file for waveform viewing in GTKWave.

---

## 3. My Lab Experience: Simulating a 2-to-1 Multiplexer

I successfully simulated a **2-to-1 multiplexer** using iverilog! Here's how I did it:

### Step 1: Setting Up My Environment
```shell
# I installed the required tools
sudo apt install iverilog
sudo apt install gtkwave
```

### Step 2: Running My Simulation
```shell
# I compiled my design and testbench
iverilog good_mux.v tb_good_mux.v

# I ran the simulation
./a.out

# I viewed the waveform in GTKWave
gtkwave tb_good_mux.vcd
```

### My Simulation Results
I captured my simulation waveform and saved it as `gtkwave_good_mux_simulation.png`. The waveform clearly showed:
- The select signal `sel` toggling every 75 time units
- Input `i0` toggling every 10 time units  
- Input `i1` toggling every 55 time units
- Output `y` correctly following the multiplexer logic

![My GTKWave Simulation Results](gtkwave_good_mux_simulation.png)

---

## 4. My Verilog Code Analysis

### The Multiplexer Design I Analyzed (`good_mux.v`)
I studied this elegant multiplexer implementation:
```verilog
module good_mux (input i0, input i1, input sel, output reg y);
always @(*)
begin
    if(sel)
        y <= i1;
    else
        y <= i0;
end
endmodule
```

**My Understanding of How It Works:**
- **Inputs:** `i0`, `i1` (data inputs), `sel` (select line)
- **Output:** `y` (registered output)
- **Logic:** When `sel` is 1, `y` gets `i1`; when `sel` is 0, `y` gets `i0`

### The Testbench I Used (`tb_good_mux.v`)
I analyzed how the testbench instantiates the multiplexer and applies test vectors:
- `sel` toggles every 75 time units
- `i0` toggles every 10 time units  
- `i1` toggles every 55 time units
- My simulation ran for 300 time units

---

## 5. Introduction to Yosys & Gate Libraries

### What I Learned About Synthesis
**Synthesis** is the process I used to convert my RTL design to gate-level representation. It translates my behavioral Verilog code into a netlist of interconnected gates.

### My Experience with Yosys
**Yosys** proved to be a powerful open-source synthesis tool that helped me:
- Convert my HDL (Verilog) to gate-level netlist
- Perform logic optimization on my design
- Map logic to technology-specific cells
- Provide verification capabilities for my work

### The Synthesis Flow I Followed
```
My RTL Design + .lib file → Yosys → My Netlist → write_verilog
```

Where I learned:
- **RTL Design:** My Verilog behavioral code
- **.lib file:** Technology library containing gate definitions
- **Netlist:** Gate-level representation of my design

---

## 6. Understanding .lib Files and Gate Flavors

### What is a .lib File?
A `.lib` file is a **collection of logical modules** that includes:
- Basic logic gates (AND, OR, NOT, etc.)
- Sequential elements (flip-flops, latches)
- **Different flavors** of the same gate

### Why Different Gate Flavors?

#### Performance Considerations
The **combinational delay** in logic paths determines the maximum operating speed:
```
Tclk > Tcq + Tcombi + Tsetup
```

#### Fast Cells vs Slow Cells

**Fast Cells:**
- **Advantages:** Small combinational delay, meet timing requirements
- **Disadvantages:** More area, higher power consumption
- **Implementation:** Wider transistors for faster charging/discharging

**Slow Cells:**
- **Advantages:** Less area, lower power consumption  
- **Disadvantages:** Higher delay
- **Purpose:** Prevent hold time violations

#### The Trade-off
- **Wider transistors → Low delay → More area and power**
- **Narrow transistors → More delay → Less area and power**
- **Faster cells don't come free - they have area and power penalties**

### Gate Library Examples
For each gate type, you'll find multiple flavors:

**2-input AND gate:**
- Slow variant
- Medium variant  
- Fast variant

**3-input AND gate:**
- Slow variant
- Medium variant
- Fast variant

### Selection Strategy
The synthesizer needs guidance to select optimal cell flavors:
- **Too many fast cells:** Bad circuit (power/area issues, hold violations)
- **Too many slow cells:** Sluggish circuit (performance issues)
- **Solution:** Use **constraints** to guide the synthesizer

---

## 7. My Synthesis Lab with Yosys

I successfully synthesized my `good_mux` design using Yosys! Here's my step-by-step process:

### My Yosys Commands

1. **I started Yosys**
   ```shell
   yosys
   ```

2. **I read the liberty library**
   ```shell
   read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

3. **I read my Verilog design**
   ```shell
   read_verilog good_mux.v
   ```

4. **I synthesized my design**
   ```shell
   synth -top good_mux
   ```

5. **I performed technology mapping**
   ```shell
   abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
   ```

6. **I visualized my netlist**
   ```shell
   show
   ```

7. **I wrote my netlist to a file**
   ```shell
   write_verilog -noattr good_mux_netlist.v
   ```

---

## 8. Verification of My Synthesis

To verify that my synthesis was correct, I used the same testbench with my synthesized netlist:

```
My Netlist + My Testbench → iverilog → VCD file → GTKWave
```

**Key Discovery:** The set of primary inputs/outputs remained the same between my RTL design and synthesized netlist, so I could use the **same testbench** for verification.

The output I observed during netlist simulation matched perfectly with my RTL simulation output, confirming my synthesis was successful!

---

## 9. Summary of My Learning

### Key Concepts I Mastered
- **Simulator:** Tool for functional verification (iverilog) - I can now simulate designs effectively
- **Design:** Behavioral Verilog representation - I understand how to write clean RTL code
- **Testbench:** Verification environment - I can create comprehensive test scenarios
- **Synthesis:** RTL to gate-level conversion (Yosys) - I successfully converted my design
- **.lib files:** Technology libraries with multiple gate flavors - I understand the importance of different gate variants
- **Constraints:** Guidance for optimal cell selection - I learned why synthesis needs guidance

