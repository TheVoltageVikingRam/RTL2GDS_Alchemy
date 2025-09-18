# 🚀 Week 00: VLSI System Design (VSD) Program Foundation & Tool Setup

Welcome to my **VLSI System Design (VSD) Program** repository! This week focused on setting up the development environment and installing the essential open-source tools that will be used throughout the program. The goal was to create a reliable and efficient workspace for synthesis, simulation, and design tasks.

---

## 🎯 **System and Virtual Machine Configuration**

To ensure optimal performance, I configured a **Virtual Machine (VM)** with the following specifications:

| **Specification**     | **Details**           |
|-----------------------|-----------------------|
| **Operating System**   | Ubuntu 20.04+         |
| **RAM**                | 6GB                   |
| **Storage**            | 50GB HDD              |
| **vCPUs**              | 4                     |

This setup guarantees sufficient resources for handling toolchain demands and running simulations smoothly.

---

⚙️ Tool Installation & Verification

The following tools were installed for RTL synthesis, simulation, circuit analysis, and layout design. Below are the installation steps and verification commands.

🧠 1. Yosys – RTL Synthesis Tool

Purpose: Converts RTL code into gate-level representations.

## ✅ Yosys Installation

# Day 0 - Tools Installation
## Yosys
```
$ git clone https://github.com/YosysHQ/yosys.git
$ cd yosys 
$ sudo apt install make (If make is not installed please install it) 
$ sudo apt-get install build-essential clang bison flex \
    libreadline-dev gawk tcl-dev libffi-dev git \
    graphviz xdot pkg-config python3 libboost-system-dev \
    libboost-python-dev libboost-filesystem-dev zlib1g-dev
$ make 
$ sudo make install
```
## 📷 Installation Verification

<p align="center">
  <img src="https://github.com/TheVoltageVikingRam/RTL2GDS_Alchemy/blob/main/Week0/assets/yosys_installed.png" 
       alt="Yosys Installed" width="600"/>
</p>


## Iverilog
```
$ sudo apt-get install iverilog
```
## 📷 Installation Verification

<p align="center">
  <img src="https://github.com/TheVoltageVikingRam/RTL2GDS_Alchemy/blob/main/Week0/assets/iverilog_installed.png" 
       alt="Iverilog Installed" width="600"/>
</p>


## GTKWave
```
$ sudo apt update
$ sudo apt install gtkwave
```
<img width="604" alt="gtkwave2" src="https://github.com/sukanyasmeher/sfal-vsd/assets/166566124/843a73bc-20ec-4417-bdc8-883caa6a299b">

<img width="1008" alt="gtkwave1" src="https://github.com/sukanyasmeher/sfal-vsd/assets/166566124/1e0c0704-f9a8-4ce4-b364-55a1fb0fc9ca">
</details>
