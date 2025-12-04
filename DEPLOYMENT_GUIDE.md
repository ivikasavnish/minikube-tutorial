# 🚀 Complete Deployment Guide

Step-by-step guide for deploying Minikube on any system with automatic architecture detection.

**Version:** 1.0.0 | **Last Updated:** 2025-12-03

---

## 🎯 Three Ways to Deploy

### Method 1: Intelligent Automated Deployment (Recommended)

This is the easiest approach - the script auto-detects everything.

```bash
./scripts/deploy-minikube.sh
```

**What it does:**
- ✅ Detects your OS (macOS, Linux, Windows)
- ✅ Detects your CPU architecture (Intel/AMD, Apple Silicon, ARM64)
- ✅ Checks system requirements (RAM, CPU, disk)
- ✅ Recommends optimal driver for your setup
- ✅ Deploys with perfect settings

**Architecture Support:**
- ✅ Intel/AMD x86_64 (Linux, macOS, Windows)
- ✅ Apple Silicon ARM64 (M1, M2, M3, M4)
- ✅ Linux ARM64 (Graviton, Ampere)
- ✅ ARMv7 & ARMv6 (Raspberry Pi - with limitations)

### Method 2: Interactive Tutorial

Guided step-by-step with explanations.

```bash
python3 minikube_tutorial.py
# Select option 2 (Installation Guide)
# Then option 4 (Deploy Sample Application)
```

### Method 3: Manual Commands

```bash
# Check system first
./scripts/system-check-advanced.sh

# Deploy with specific settings
minikube start --driver=docker --cpus=4 --memory=8192
```

---

## 🔍 System Architecture Detection

### Supported Architectures

```bash
# Check your architecture
uname -m

# Results:
# x86_64  → Intel/AMD 64-bit
# amd64   → AMD64 (same as x86_64)
# arm64   → ARM64 (Apple Silicon, ARM64 Linux)
# aarch64 → ARM64 (alternative name)
# armv7l  → 32-bit ARM (Raspberry Pi 4)
# armv6l  → 32-bit ARM (Raspberry Pi Zero/1)
```

### Supported Operating Systems

```bash
# Check your OS
uname -s

# Results:
# Darwin  → macOS
# Linux   → Linux
# MINGW*  → Windows (WSL/Git Bash)

# Detailed info:
uname -a
```

---

## 📋 Quick Start by System

### macOS (Intel) - 5 minutes

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install tools
brew install minikube kubectl

# 3. Install Docker Desktop
# Download from: https://www.docker.com/products/docker-desktop

# 4. Deploy Minikube
./scripts/deploy-minikube.sh

# 5. Verify
./scripts/system-check-advanced.sh
```

### macOS (Apple Silicon M1/M2/M3) - 5 minutes

```bash
# 1. Install Homebrew ARM64 version
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install tools (auto ARM64)
brew install minikube kubectl

# 3. Install Docker Desktop for Mac (ARM64)
# Download: https://www.docker.com/products/docker-desktop

# 4. Deploy with optimized settings
./scripts/deploy-minikube.sh
# Select: Docker driver (it auto-optimizes for ARM64)

# 5. Verify
./scripts/system-check-advanced.sh
```

### Ubuntu/Debian (x86_64) - 10 minutes

```bash
# 1. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# 2. Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# 3. (Optional) Install KVM for better performance
sudo apt-get update
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients
sudo usermod -a -G libvirt $USER
newgrp libvirt

# 4. Deploy Minikube
./scripts/deploy-minikube.sh
# Select: KVM driver (recommended) or Docker

# 5. Verify
./scripts/system-check-advanced.sh
```

### Ubuntu/Debian (ARM64) - 10 minutes

```bash
# 1. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# 2. Install Minikube (ARM64 version)
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
rm minikube-linux-arm64

# 3. Deploy Minikube
./scripts/deploy-minikube.sh
# Select: Docker driver (optimal for ARM64)

# 4. Verify
./scripts/system-check-advanced.sh
```

### Windows (WSL2) - 15 minutes

```bash
# 1. Enable WSL2
wsl --install
# Restart required

# 2. Install Ubuntu in WSL2
wsl --install -d Ubuntu

# 3. In Ubuntu terminal, run:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 4. Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# 5. Deploy
./scripts/deploy-minikube.sh
```

---

## 🔧 Deploy Script Usage

### Interactive Mode (Recommended)

```bash
./scripts/deploy-minikube.sh

# Shows:
# 1. System information
# 2. Requirements check
# 3. Driver recommendation
# 4. Menu for actions
```

### Command-Line Arguments

```bash
# Show system information only
./scripts/deploy-minikube.sh info

# Check system requirements
./scripts/deploy-minikube.sh check

# Deploy immediately with detected settings
./scripts/deploy-minikube.sh deploy

# Advanced custom deployment
./scripts/deploy-minikube.sh advanced
```

---

## 🔍 Advanced System Check Script

### What It Checks

```bash
./scripts/system-check-advanced.sh
```

**Comprehensive analysis including:**

1. **Operating System**
   - OS type detection
   - Version information
   - Compatibility verification

2. **CPU Architecture**
   - Architecture type (x86_64, ARM64, ARMv7)
   - CPU brand and model
   - Core and thread count
   - Architecture-specific features

3. **CPU Features**
   - Intel VT-x (vmx)
   - AMD-V (svm)
   - Nested virtualization
   - Architecture support level

4. **System Resources**
   - Total memory
   - Available memory
   - Disk space
   - Swap space

5. **Installed Tools**
   - Docker (version + daemon status)
   - Minikube (version + cluster status)
   - kubectl (version + configuration)
   - Container runtimes (containerd, cri-o, podman)

6. **Kubernetes Cluster**
   - Cluster accessibility
   - Node status
   - Resource usage metrics

7. **Network**
   - Internet connectivity
   - DNS resolution

8. **Permissions**
   - User groups (docker, libvirt)
   - Directory permissions
   - Configuration access

---

## 🎯 Deployment Scenarios

### Scenario 1: Fresh Installation

```bash
# Step 1: Check requirements
./scripts/system-check-advanced.sh

# Step 2: Install missing tools if needed
./scripts/quick-setup.sh
# Choose option 6 (Full automated setup)

# Step 3: Deploy Minikube
./scripts/deploy-minikube.sh
```

### Scenario 2: Upgrade Existing Setup

```bash
# Step 1: Stop current cluster
minikube stop

# Step 2: Delete old cluster (if needed)
minikube delete

# Step 3: Re-deploy with latest settings
./scripts/deploy-minikube.sh
```

### Scenario 3: Development Environment

```bash
# Allocate more resources
./scripts/deploy-minikube.sh advanced
# Input: 8 CPUs, 16GB memory, 80GB disk

# Or via command
minikube start \
  --driver=docker \
  --cpus=8 \
  --memory=16384 \
  --disk-size=80gb
```

### Scenario 4: Production-like Testing

```bash
# For x86_64 Linux (use KVM)
./scripts/deploy-minikube.sh
# Select KVM driver with maximum resources

# For Apple Silicon
./scripts/deploy-minikube.sh
# Select Docker with 8 CPUs and 12GB memory

# For ARM64 Linux
./scripts/deploy-minikube.sh
# Select Docker with available resources
```

---

## 🚀 Auto-Configuration Details

### For Intel/AMD x86_64

**Detected driver recommendations:**
1. KVM (if Linux) - Fastest
2. Docker - Compatible, portable
3. VirtualBox - Universal fallback

**Resource calculation:**
```
CPUs: min(2, detected_cpus / 2), max 8
Memory: min(8GB, available_memory / 2)
Disk: 40GB (standard), 80GB (high-performance)
```

### For Apple Silicon (ARM64)

**Detected driver recommendations:**
1. Docker - Native ARM64 support
2. Hyperkit - Lightweight alternative

**Resource calculation:**
```
CPUs: min(4, available_cpus)
Memory: min(8GB, available_memory / 2)
Special: Native ARM64 image selection
```

**Auto-optimization:**
- ✅ Uses native ARM64 executables
- ✅ Automatic image platform selection
- ✅ Optimized for M1/M2/M3/M4 chips
- ✅ Maximum performance on Apple Silicon

### For Linux ARM64

**Detected driver recommendations:**
1. Docker - Compatible, portable
2. KVM - If supported on platform

**Resource calculation:**
```
CPUs: 2-4 (conservative for ARM)
Memory: 4-8GB (ARM-optimized)
Disk: 30-40GB
```

---

## 📊 Architecture-Specific Details

### Intel Mac
- **Driver:** Docker Desktop (Intel version)
- **Performance:** Excellent
- **Setup:** Simple, one-click Docker Desktop

### Apple Silicon Mac
- **Driver:** Docker Desktop (ARM64 native)
- **Performance:** Excellent (native execution)
- **Special:** Auto image selection for ARM64

### Linux x86_64
- **Driver:** KVM (recommended) or Docker
- **Performance:** Excellent (KVM is fastest)
- **Requirement:** Virtualization enabled in BIOS

### Linux ARM64
- **Driver:** Docker (Docker, KVM if available)
- **Performance:** Good (native ARM64)
- **Use Case:** Cloud deployments (AWS Graviton, etc.)

### Windows with WSL2
- **Driver:** Docker Desktop with WSL2
- **Performance:** Good (WSL2 is efficient)
- **Requirement:** WSL2 enabled

---

## ✅ Verification Checklist

After deployment, verify everything works:

```bash
# 1. System check
./scripts/system-check-advanced.sh
# All checks should pass ✓

# 2. Check Minikube status
minikube status
# Should show: Running

# 3. Check kubectl connectivity
kubectl get nodes
# Should list the minikube node

# 4. Check cluster info
kubectl cluster-info

# 5. Deploy test app
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=LoadBalancer --port=80
kubectl get all

# 6. Cleanup
kubectl delete deployment nginx
kubectl delete service nginx
```

---

## 🐛 Troubleshooting

### Deployment fails on check

**Problem:** Requirements check fails

**Solution:**
```bash
# See what's failing
./scripts/system-check-advanced.sh

# Common issues:
# - Virtualization not enabled → Enable in BIOS
# - Insufficient RAM → Close other applications
# - No disk space → Clean up disk
# - Docker not running → Start Docker
```

### Architecture mismatch

**Problem:** Wrong binary for your architecture

**Solution:**
```bash
# Check your actual architecture
uname -m

# Verify you downloaded the right version
file ./scripts/deploy-minikube.sh
minikube version
```

### Driver not available

**Problem:** Selected driver not installed

**Solution:**
```bash
# Check available drivers
minikube config view

# Try different driver
minikube start --driver=docker
# OR
minikube start --driver=virtualbox
```

### Performance issues

**Problem:** Minikube is slow

**Solution:**
```bash
# Check resource allocation
minikube config view

# Increase resources
minikube config set cpus 4
minikube config set memory 8192
minikube stop && minikube start
```

---

## 📚 File Structure

```
minikube-demo/
├── scripts/
│   ├── deploy-minikube.sh           ← MAIN: Intelligent deployment
│   ├── system-check-advanced.sh     ← Check all architectures
│   ├── quick-setup.sh               ← Install dependencies
│   └── common-commands.sh           ← Command reference
├── ARCHITECTURE_GUIDE.md             ← Detailed arch info
├── DEPLOYMENT_GUIDE.md               ← This file
├── GETTING_STARTED.md                ← Quick start
├── README.md                         ← Complete documentation
└── minikube_tutorial.py              ← Interactive tutorial
```

---

## 🎓 Learning Path

### Day 1: Setup
1. Run: `./scripts/system-check-advanced.sh`
2. Run: `./scripts/deploy-minikube.sh`
3. Verify: `minikube status`

### Day 2: Learning
1. Run: `python3 minikube_tutorial.py`
2. Select: Option 1 (Introduction)
3. Select: Option 4 (Deploy App)

### Day 3+: Experimenting
1. Deploy examples: `kubectl apply -f examples/`
2. Use commands: `./scripts/common-commands.sh`
3. Monitor: `./scripts/system-check-advanced.sh`

---

## 🎉 You're Ready!

```bash
# Start deployment
./scripts/deploy-minikube.sh

# Then:
minikube status
kubectl get nodes
```

---

**Next Steps:**
- Read [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) for detailed info
- See [README.md](README.md) for complete documentation
- Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for command reference

**Happy Deploying!** 🚀
