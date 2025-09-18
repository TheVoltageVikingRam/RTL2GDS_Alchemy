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
## 📷 Installation Verification

<p align="center">
  <img src="https://github.com/TheVoltageVikingRam/RTL2GDS_Alchemy/blob/main/Week0/assets/gtkwave_installed.png" 
       alt="GTKWave Installed" width="600"/>
</p>


## Ngspice
```
$ sudo apt update
$ sudo apt install gtkwave
```
## 📷 Installation Verification

<p align="center">
  <img src="https://github.com/TheVoltageVikingRam/RTL2GDS_Alchemy/blob/main/Week0/assets/ngspice_installed.png" 
       alt="ngspice Installed" width="600"/>
</p>


## ✅ Magic VLSI Installation

[Magic VLSI](http://opencircuitdesign.com/magic/) is an open-source VLSI layout tool widely used for IC design, DRC, and visualization.  
Follow the steps below to install Magic on an Ubuntu/Debian system:

```bash
# Install required dependencies
sudo apt-get install m4
sudo apt-get install tcsh
sudo apt-get install csh
sudo apt-get install libx11-dev
sudo apt-get install tcl-dev tk-dev
sudo apt-get install libcairo2-dev
sudo apt-get install mesa-common-dev libglu1-mesa-dev
sudo apt-get install libncurses-dev

# Clone Magic repository
git clone https://github.com/RTimothyEdwards/magic
cd magic

# Configure build
./configure

# Build Magic
make

# Install system-wide
sudo make install
```
## 📷 Installation Verification

<p align="center">
  <img src="https://github.com/TheVoltageVikingRam/RTL2GDS_Alchemy/blob/main/Week0/assets/magic_vlsi_installed.png" 
       alt="magic vlsi Installed" width="600"/>
</p>
