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

✅ Installation:
sudo apt-get update
git clone https://github.com/YosysHQ/yosys.git
cd yosys
sudo apt install make
sudo apt-get install build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev
make config-gcc
make
sudo make install

🔍 Verification:
yosys -v
