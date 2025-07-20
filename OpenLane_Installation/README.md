# OpenLane Installation Guide

This guide provides step-by-step instructions to install Docker and OpenLane on an Ubuntu-based system.

---

## 🐳 Installing Docker

### Step 1: Set Up Docker Repository

```sh
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add Docker’s official repository:

```sh
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```

### Step 2: Install Docker Engine

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### Step 3: Verify Installation

Run the test image:

```sh
sudo docker run hello-world
```

---

## ⚠️ Fixing Docker Permissions

If you encounter a **"permission denied"** error related to Docker socket access:

### Add Your User to the Docker Group

```sh
# Create the docker group (if it doesn't exist)
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# Log out and back in for group changes to take effect
```

---

## 🧰 Installing OpenLane

### Step 1: Verify Prerequisites

Ensure the following tools are installed:

```sh
git --version
docker --version
python3 --version
python3 -m pip --version
make --version
python3 -m venv -h
```

### Step 2: Update & Install Required Packages

```sh
sudo apt-get update
sudo apt-get upgrade
sudo apt install -y build-essential python3 python3-venv python3-pip python3-tk curl make git
```

### Step 3: Clone and Build OpenLane

```sh
cd $HOME
git clone https://github.com/The-OpenROAD-Project/OpenLane
cd OpenLane
make
make test
```


