🚀 Week 00: VSD Program Foundation & Tool Setup
Welcome to my VLSI System Design (VSD) Program repository! This first week was all about building a solid foundation by setting up my development environment and installing all the essential open-source tools. My goal was to create a robust and reliable workspace for the upcoming labs.

1. System and Virtual Machine Configuration
The first task was to ensure my development environment was properly configured. I opted to set up a dedicated virtual machine with the following hardware specifications to handle the demanding synthesis and simulation tasks of the program.

Operating System: Ubuntu 20.04+

RAM: 6GB

Storage: 50GB HDD

vCPUs: 4

2. Tool Installation & Verification
I proceeded with the installation of the core open-source toolchain. I've documented the exact commands I used for each tool.

Yosys
Purpose: Yosys is a powerful open-source framework for RTL synthesis.

Installation Commands:

$ sudo apt-get update
$ git clone https://github.com/YosysHQ/yosys.git
$ cd yosys
$ sudo apt install make
$ sudo apt-get install build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev
$ make config-gcc
$ make
$ sudo make install
Verification: After installation, I confirmed the tool was working correctly.

Icarus Verilog (Iverilog)
Purpose: Iverilog is a Verilog compiler that generates executable code for simulation.

Installation Commands:

$ sudo apt-get update
$ sudo apt-get install iverilog
Verification: I verified the installation by checking the version.

GTKWave
Purpose: GTKWave is an essential tool for viewing and analyzing digital waveforms.

Installation Commands:

$ sudo apt-get update
$ sudo apt install gtkwave
Verification: I confirmed the tool was correctly installed.

ngspice
Purpose: ngspice is a mixed-signal circuit simulator for SPICE analysis.

Installation Commands:

$ tar -zxvf ngspice-37.tar.gz
$ cd ngspice-37
$ mkdir release
$ cd release
$ ../configure --with-x --with-readline yes --disable-debug
$ make
$ sudo make install
Verification:

magic
Purpose: magic is a VLSI layout tool.

Installation Commands:

$ sudo apt-get install m4
$ sudo apt-get install tcsh csh
$ sudo apt-get install libx11-dev
$ sudo apt-get install tcl-dev tk-dev
$ sudo apt-get install libcairo2-dev
$ sudo apt-get install mesa-common-dev libglu1-mesa-dev
$ sudo apt-get install libncurses-dev
$ git clone https://github.com/RTimothyEdwards/magic
$ cd magic
$ ./configure
$ make
$ sudo make install
Verification:

OpenLANE
Purpose: OpenLANE is an open-source RTL-to-GDSII flow.

Installation Commands:

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt install -y build-essential python3 python3-venv python3-pip make git
$ sudo apt install apt-transport-https ca-certificates curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
$ echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt update
$ sudo apt install docker-ce docker-ce-cli containerd.io
$ sudo docker run hello-world
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ sudo reboot
$ docker run hello-world
$ git clone https://github.com/The-OpenROAD-Project/OpenLane
$ cd OpenLane
$ make
$ make test
Verification: I verified the installation by checking the versions of the key dependencies and running the OpenLANE tests.

3. Conclusion
This week has been incredibly productive. With my environment set up and all core tools installed and verified, I'm now fully prepared to begin my first lab assignments. I'm excited to start writing RTL code and applying these tools to real-world design challenges.
