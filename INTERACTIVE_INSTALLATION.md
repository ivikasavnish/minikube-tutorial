# 🎯 Interactive Installation Guide

Complete interactive installation with step-by-step guidance for all systems.

**Version:** 1.0.0 | **Last Updated:** 2025-12-03

---

## 🚀 Quick Start

### The Easiest Way (Recommended)

```bash
./scripts/interactive-install.sh
```

This launches an interactive menu that guides you through:
1. ✅ System detection
2. ✅ Docker installation
3. ✅ Minikube installation
4. ✅ kubectl installation
5. ✅ Optional KVM setup
6. ✅ Verification
7. ✅ Cluster deployment

---

## 📋 Three Installation Methods

### Method 1: Full Interactive Installation (Recommended)

```bash
./scripts/interactive-install.sh
```

Then select: **Option 8 - Full Guided Installation**

**What it does:**
- ✅ Automatically detects your system
- ✅ Walks you through each step
- ✅ Gives you choices at critical points
- ✅ Verifies everything works
- ✅ Deploys Minikube cluster
- ✅ Saves installation log

**Time:** ~10-15 minutes

### Method 2: Interactive Menu (Choose Your Steps)

```bash
./scripts/interactive-install.sh
```

Then select individual options:
- Option 1: Detect System
- Option 2: Install Docker
- Option 3: Install Minikube
- Option 4: Install kubectl
- Option 5: Setup KVM
- Option 6: Verify
- Option 7: Deploy
- Option 9: View Log

**Time:** Variable based on your choices

### Method 3: Traditional Scripts

```bash
# Step 1: Check system
./scripts/system-check-advanced.sh

# Step 2: Setup
./scripts/quick-setup.sh

# Step 3: Deploy
./scripts/deploy-minikube.sh

# Step 4: Verify
./scripts/system-check-advanced.sh
```

**Time:** ~15-20 minutes

---

## 🎯 How to Use Interactive Installation

### Starting the Interactive Guide

```bash
./scripts/interactive-install.sh
```

### Main Menu Options

```
1. 🔍 Detect System (automatic)
   ↓ Analyzes your OS and architecture

2. 🐋 Install Docker
   ↓ Installs Docker (macOS manual, Linux automatic)

3. 🚀 Install Minikube
   ↓ Downloads and installs Minikube

4. 📦 Install kubectl
   ↓ Installs Kubernetes CLI tool

5. ⚙️  Setup KVM (Linux)
   ↓ Optional: Install KVM for better performance

6. ✅ Verify Installation
   ↓ Checks all tools are installed

7. 🎯 Deploy Minikube Cluster
   ↓ Creates and starts Kubernetes cluster

8. 🧠 Full Guided Installation
   ↓ Runs all steps automatically

9. 📋 View Installation Log
   ↓ Shows what was installed and when

0. 🚪 Exit
```

---

## 📖 Step-by-Step Walkthrough

### Option 1: System Detection

```bash
Select: 1
```

**The script will show:**
- Operating System (macOS, Linux, Windows)
- Architecture (x86_64, ARM64, ARMv7)
- CPU cores and memory
- Distribution (Linux specific)

**Confirmation:**
You can verify the detected information is correct

**What it logs:**
- System type
- Architecture details
- Hardware specs

---

### Option 2: Docker Installation

```bash
Select: 2
```

#### macOS
- **Shows instructions** to download Docker Desktop
- **Verifies** when Docker is installed
- **Confirms** Docker is running

**Manual steps:**
1. Visit: https://www.docker.com/products/docker-desktop
2. Download Docker Desktop
3. Install and start it
4. Confirm in the script

#### Linux
- **Automatic installation** available
- **Asks permission** before installing
- **Adds you to docker group** for access
- **Provides fallback** if auto-install fails

**What happens:**
1. Downloads Docker installation script
2. Runs automated installer
3. Adds your user to docker group
4. Shows Docker version

**Logging group changes:**
```bash
# You may need to run:
newgrp docker

# Or logout and login again
```

---

### Option 3: Minikube Installation

```bash
Select: 3
```

#### macOS with Homebrew
- Checks if Homebrew is installed
- Uses Homebrew if available
- Falls back to direct download

#### macOS without Homebrew
- Downloads Minikube directly
- Installs to /usr/local/bin
- Shows version confirmation

#### Linux
- Downloads for Linux architecture
- Installs to /usr/local/bin
- Shows version confirmation

**What it logs:**
- Installation method used
- Version installed
- Installation time

---

### Option 4: kubectl Installation

```bash
Select: 4
```

#### macOS with Homebrew
- Installs via Homebrew
- Simple one-command installation

#### macOS without Homebrew
- Downloads from official source
- Latest stable version
- Installs to system path

#### Linux
- Downloads latest stable
- Installs to system path
- Compatible with any Linux dist

**Verification shows:**
- kubectl version
- Client version info

---

### Option 5: KVM Setup (Linux Only)

```bash
Select: 5
```

**Purpose:**
KVM provides better performance than Docker on Linux

**What it checks:**
- Whether KVM is supported (Intel VT-x or AMD-V)
- If virtualization is enabled
- Current user permissions

**Installation includes:**
- qemu-kvm - Virtualization tools
- libvirt - Virtualization library
- virt-manager - Management tools

**User permissions:**
- Adds you to libvirt group
- Requires logout/login to take effect

**What it logs:**
- Virtualization detection
- KVM installation success
- Permission changes

---

### Option 6: Verify Installation

```bash
Select: 6
```

**Checks for:**
- Docker installation and status
- Minikube installation
- kubectl installation
- Tool versions

**Output shows:**
```
✓ Docker: Docker version 24.0.0
✓ Minikube: minikube version: v1.31.0
✓ kubectl: Client Version: v1.28.0
```

**Result:**
- ✅ All tools installed
- ❌ Missing tools (if any)

---

### Option 7: Deploy Minikube Cluster

```bash
Select: 7
```

**Configuration choices:**
1. **Minimal** (2 CPUs, 4GB RAM) - Learning
2. **Standard** (4 CPUs, 8GB RAM) - Recommended
3. **High Performance** (8 CPUs, 16GB RAM) - Production testing
4. **Custom** - Your own settings

**What happens:**
1. Stops existing cluster (if running)
2. Starts new cluster with your settings
3. Configures Docker driver
4. Shows cluster status

**Output includes:**
- Cluster status
- Node information
- Ready for use

**Typical time:** 2-5 minutes

---

### Option 8: Full Guided Installation

```bash
Select: 8
```

**Complete workflow:**
1. ✅ Detects system
2. ✅ Installs Docker
3. ✅ Installs Minikube
4. ✅ Installs kubectl
5. ✅ Sets up KVM (optional)
6. ✅ Verifies all tools
7. ✅ Deploys cluster
8. ✅ Shows summary

**Duration:** ~15 minutes

**When to use:**
- First-time installation
- Fresh system setup
- Complete from scratch

**What gets saved:**
- Installation log
- Timestamps
- Success/failure of each step

---

### Option 9: View Installation Log

```bash
Select: 9
```

**Shows:**
- Timestamps of each action
- What was installed
- Where it was installed
- Any errors or warnings

**Log location:**
```
~/.minikube_tutorial/logs/installation_YYYYMMDD_HHMMSS.log
```

**Example output:**
```
[2025-12-03 10:15:23] System detected: macOS (arm64)
[2025-12-03 10:15:45] Docker already installed
[2025-12-03 10:16:12] Minikube installed via Homebrew
[2025-12-03 10:17:03] kubectl installed via Homebrew
[2025-12-03 10:17:45] Verification passed
[2025-12-03 10:22:15] Minikube cluster started successfully
```

---

## 🎓 Installation Scenarios

### Scenario 1: Fresh macOS (Intel)

```bash
# Run interactive installation
./scripts/interactive-install.sh

# Select: 8 (Full Guided Installation)

# It will:
1. Detect Intel Mac
2. Prompt for Docker Desktop download
3. Install Minikube via Homebrew
4. Install kubectl via Homebrew
5. Verify everything
6. Deploy cluster
```

**Time:** ~15 minutes

---

### Scenario 2: Apple Silicon Mac (M1/M2/M3)

```bash
# Run interactive installation
./scripts/interactive-install.sh

# Select: 8 (Full Guided Installation)

# It will:
1. Detect Apple Silicon ARM64
2. Recommend Docker Desktop ARM64 version
3. Install Minikube (auto-detects ARM64)
4. Install kubectl (ARM64 optimized)
5. Skip KVM (not available on macOS)
6. Deploy cluster with ARM64 optimization
```

**Time:** ~15 minutes

---

### Scenario 3: Ubuntu Linux x86_64

```bash
# Run interactive installation
./scripts/interactive-install.sh

# Select: 8 (Full Guided Installation)

# It will:
1. Detect Linux x86_64
2. Auto-install Docker
3. Install Minikube
4. Install kubectl
5. Offer KVM setup (optional)
6. Deploy cluster
```

**Time:** ~20 minutes (includes package updates)

---

### Scenario 4: Linux with Custom Options

```bash
# Run interactive installation
./scripts/interactive-install.sh

# Select individual options:
1. Detect System
2. Install Docker
3. Install Minikube
# Skip kubectl (already installed)
5. Setup KVM
7. Deploy Minikube Cluster with custom settings
```

**Time:** Variable

---

## 🔧 Troubleshooting Installation

### Docker Installation Issues

**Problem:** Docker not found after installation

```bash
# Try restarting
newgrp docker

# Or logout and login again
# Then verify:
docker --version
```

**Problem:** Permission denied for docker

```bash
# Add yourself to docker group:
sudo usermod -aG docker $USER
newgrp docker

# Verify:
docker ps
```

### Minikube Issues

**Problem:** Minikube command not found

```bash
# Verify installation:
which minikube

# Try reinstalling:
./scripts/interactive-install.sh
# Select: 3 (Install Minikube)
```

### kubectl Issues

**Problem:** kubectl can't connect to cluster

```bash
# Start the cluster first:
minikube start

# Then verify:
kubectl cluster-info
```

---

## 📊 Installation Log Locations

### Main Log Directory
```
~/.minikube_tutorial/logs/
```

### Individual Installation Logs
```
~/.minikube_tutorial/logs/installation_20251203_101523.log
~/.minikube_tutorial/logs/installation_20251203_143045.log
...
```

### Configuration
```
~/.minikube_tutorial/config.json
~/.minikube_tutorial/installed.txt
```

### Kubernetes Configuration
```
~/.kube/config
```

### Minikube Data
```
~/.minikube/
```

---

## ✅ Verification After Installation

### Quick Check

```bash
# Check all tools
minikube status
docker version
kubectl version --client
```

### Full Check

```bash
# Run the advanced check
./scripts/system-check-advanced.sh
```

### Deploy Test App

```bash
# Create a test deployment
kubectl create deployment test --image=nginx

# Check if running
kubectl get pods

# Clean up
kubectl delete deployment test
```

---

## 🎯 What to Do After Installation

### 1. Explore the Dashboard

```bash
minikube dashboard
```

### 2. Deploy Your First App

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=LoadBalancer --port=80
minikube service nginx
```

### 3. Learn with the Tutorial

```bash
python3 minikube_tutorial.py
```

### 4. Check Documentation

- README.md - Complete reference
- ARCHITECTURE_GUIDE.md - Your architecture specifics
- QUICK_REFERENCE.md - Commands to use daily

---

## 📝 Installation Summary

### Components Installed

| Tool | Purpose | Source |
|------|---------|--------|
| Docker | Container runtime | Docker.com |
| Minikube | Kubernetes cluster | Kubernetes Project |
| kubectl | Kubernetes CLI | Kubernetes Project |
| KVM (optional) | Hypervisor (Linux) | QEMU Project |

### Configuration Files Created

| File | Purpose | Location |
|------|---------|----------|
| kubeconfig | Cluster credentials | ~/.kube/config |
| Minikube VM | Cluster image | ~/.minikube/ |
| Installation log | What was installed | ~/.minikube_tutorial/logs/ |

### Permissions Granted

| Group | Purpose | Linux only |
|-------|---------|-----------|
| docker | Run Docker | ✅ Yes |
| libvirt | Use KVM | ✅ Yes |

---

## 🎉 Success Criteria

### Installation Successful When:
- ✅ All tools installed
- ✅ All checks pass
- ✅ Cluster accessible
- ✅ Can deploy applications

### System Ready When:
- ✅ Docker running
- ✅ Minikube cluster active
- ✅ kubectl connected
- ✅ Sample app deploys

---

## 🚀 Next Steps

After successful installation:

1. **Verify Everything**
   ```bash
   ./scripts/system-check-advanced.sh
   ```

2. **Open Dashboard**
   ```bash
   minikube dashboard
   ```

3. **Learn with Tutorial**
   ```bash
   python3 minikube_tutorial.py
   ```

4. **Deploy Examples**
   ```bash
   kubectl apply -f examples/simple-deployment.yaml
   ```

5. **Read Documentation**
   - ARCHITECTURE_GUIDE.md
   - DEPLOYMENT_GUIDE.md
   - README.md

---

## 📞 Help & Support

### If Installation Fails

1. **Check the log:**
   ```bash
   ./scripts/interactive-install.sh
   # Select: 9 (View Installation Log)
   ```

2. **Run system check:**
   ```bash
   ./scripts/system-check-advanced.sh
   ```

3. **Try manual installation:**
   ```bash
   ./scripts/quick-setup.sh
   ```

4. **Get help:**
   ```bash
   python3 minikube_tutorial.py
   # Select: Option 8 (Help)
   ```

---

## 🔄 Reinstallation

To reinstall everything from scratch:

```bash
# Delete old cluster
minikube delete

# Run installation again
./scripts/interactive-install.sh
# Select: 8 (Full Guided Installation)
```

---

**Version:** 1.0.0
**Last Updated:** 2025-12-03
**Status:** Ready to Use ✅

**Start Installation Now:**
```bash
./scripts/interactive-install.sh
```

🚀 Happy Installation!
