# 🏗️ Architecture & Deployment Guide

Complete guide for deploying Minikube on different architectures and operating systems.

**Version:** 1.0.0 | **Last Updated:** 2025-12-03

---

## 📊 Supported Architectures

### Intel/AMD (x86_64)
- **Full Support:** Complete Kubernetes and Minikube support
- **Systems:** Intel, AMD processors on Linux, macOS, Windows
- **Best For:** Production-like environments
- **Performance:** Excellent
- **Drivers:** Docker, KVM, VirtualBox, Hyper-V

### Apple Silicon (ARM64)
- **Full Support:** Native ARM64 Kubernetes
- **Systems:** M1, M2, M3, M4 chips
- **Best For:** Native performance on modern Macs
- **Performance:** Excellent - native execution
- **Drivers:** Docker Desktop (recommended), Hyperkit, UTM
- **Note:** Requires ARM64-compatible container images

### Linux ARM64
- **Full Support:** Full Kubernetes support
- **Systems:** ARM64 SoCs (Ampere, AWS Graviton, etc.)
- **Best For:** Cloud deployments, edge computing
- **Performance:** Excellent
- **Drivers:** Docker, KVM

### ARMv7 (32-bit ARM)
- **Limited Support:** Some limitations
- **Systems:** Older ARM processors, some Raspberry Pi models
- **Best For:** Learning/development
- **Performance:** Limited
- **Note:** Not all container images available
- **Alternative:** Consider k3s instead

---

## 🖥️ Operating System Support

### macOS

#### Intel Macs
```bash
# System info
system_profiler SPHardwareDataType

# Install Minikube
brew install minikube kubectl docker

# Start cluster
minikube start --driver=docker
```

**Requirements:**
- macOS 10.12+
- 4GB RAM (8GB recommended)
- Intel processor

#### Apple Silicon Macs (M1/M2/M3/M4)
```bash
# System info
uname -m  # Should show arm64

# Install with Homebrew ARM64 version
brew install minikube kubectl

# Install Docker Desktop for Mac
# Download from: https://www.docker.com/products/docker-desktop

# Start cluster (optimized for ARM64)
minikube start --driver=docker
```

**Special Considerations:**
- ✅ Native ARM64 support
- ✅ Excellent performance
- ✅ Automatic image selection for ARM64
- ⚠️ Some legacy images may not support ARM64

### Ubuntu/Debian (x86_64)

```bash
# Verify architecture
uname -m  # Should show x86_64

# Check for virtualization
grep -E "vmx|svm" /proc/cpuinfo

# Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Recommended: Install KVM
sudo apt-get install qemu-kvm libvirt-daemon-system
sudo usermod -a -G libvirt $USER

# Start with KVM (faster)
minikube start --driver=kvm2 --cpus=4 --memory=8192

# Or with Docker
minikube start --driver=docker
```

### Ubuntu/Debian (ARM64)

```bash
# Verify architecture
uname -m  # Should show aarch64

# Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube

# Install Docker (ARM64 version)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Start cluster
minikube start --driver=docker --cpus=2 --memory=4096

# For KVM support (if available)
sudo apt-get install qemu-kvm-arm64 libvirt-daemon-system
minikube start --driver=kvm2 --cpus=4 --memory=8192
```

### Fedora/RHEL (x86_64)

```bash
# Verify architecture
uname -m  # Should show x86_64

# Install Docker
sudo dnf install docker

# Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start cluster
minikube start --driver=docker
```

---

## 🚀 Deploy Minikube Script

### Quick Deployment

```bash
# Interactive deployment (recommended)
./scripts/deploy-minikube.sh

# Run with specific mode
./scripts/deploy-minikube.sh info      # Show system info
./scripts/deploy-minikube.sh check     # Check requirements
./scripts/deploy-minikube.sh deploy    # Deploy immediately
./scripts/deploy-minikube.sh advanced  # Advanced options
```

### What Deploy Script Does

1. **Auto-detects your system:**
   - Operating System (macOS, Linux, Windows)
   - Architecture (x86_64, ARM64, ARMv7)
   - CPU cores and memory

2. **Validates requirements:**
   - Minimum hardware specs
   - Virtualization support
   - Disk space

3. **Recommends optimal driver:**
   - macOS: Docker (native) or Hyperkit
   - Linux (x86): KVM or Docker
   - Linux (ARM): Docker
   - Windows: WSL2 or Hyper-V

4. **Configures resources:**
   - Calculates optimal CPU allocation
   - Sets memory appropriately
   - Configures disk size

5. **Deploys with best settings:**
   - ARM64-optimized settings for Apple Silicon
   - KVM-optimized settings for Linux
   - Docker-optimized for compatibility

---

## 🔍 System Check Script

### Advanced System Verification

```bash
# Run comprehensive system check
./scripts/system-check-advanced.sh
```

### Checks Performed

#### Operating System
- ✓ OS detection (macOS, Linux, Windows)
- ✓ OS version compatibility
- ✓ Distribution-specific requirements

#### CPU Architecture
- ✓ Architecture detection (x86_64, ARM64, ARMv7, ARMv6)
- ✓ CPU brand and model
- ✓ Core and thread count
- ✓ Architecture-specific features

#### CPU Features
- ✓ Intel VT-x (vmx) virtualization
- ✓ AMD-V (svm) virtualization
- ✓ Nested virtualization support
- ✓ Architecture-specific capabilities

#### Memory
- ✓ Total available RAM
- ✓ Available memory
- ✓ Recommendations based on size

#### Disk Space
- ✓ Free disk space
- ✓ Total disk capacity
- ✓ Usage percentage

#### Tools
- ✓ Docker installation and daemon status
- ✓ Minikube installation
- ✓ kubectl installation
- ✓ Container runtimes (containerd, cri-o, podman)

#### Kubernetes Cluster
- ✓ Cluster accessibility
- ✓ Node status
- ✓ Resource metrics

#### Permissions
- ✓ User in docker group
- ✓ User in libvirt group
- ✓ Home directory permissions
- ✓ ~/.kube directory access

#### Network
- ✓ Internet connectivity
- ✓ DNS resolution

---

## 🎯 Architecture-Specific Deployment

### Intel/AMD x86_64 - Linux

**Recommended Setup:**

```bash
# Full optimized setup
./scripts/deploy-minikube.sh

# Or manual
minikube start \
  --driver=kvm2 \
  --cpus=4 \
  --memory=8192 \
  --disk-size=40gb

# Verify
./scripts/system-check-advanced.sh
```

**Driver Options:**
1. **KVM2** (Recommended) - Fastest, native Linux hypervisor
2. **Docker** - Compatible, easier setup
3. **VirtualBox** - Universal but slower

### Apple Silicon (ARM64) - macOS

**Recommended Setup:**

```bash
# Install Docker Desktop for Mac (ARM64 version)
# Download from: https://www.docker.com/products/docker-desktop

# Deploy with optimized settings
./scripts/deploy-minikube.sh

# Or manual
minikube start \
  --driver=docker \
  --cpus=4 \
  --memory=8192 \
  --container-runtime=docker
```

**Special Features:**
- ✅ Native ARM64 execution
- ✅ Automatic image selection
- ✅ Excellent performance
- ✅ No emulation needed

### Linux ARM64

**Recommended Setup:**

```bash
# Deploy with ARM64 optimization
./scripts/deploy-minikube.sh

# Or manual with Docker
minikube start \
  --driver=docker \
  --cpus=2 \
  --memory=4096

# For KVM (if available)
minikube start \
  --driver=kvm2 \
  --cpus=4 \
  --memory=8192
```

**Container Image Considerations:**
- Use `--pull-policy=Always` for latest ARM64 images
- Check image availability: `docker pull image:latest`
- Multi-arch images support ARM64 automatically

---

## 📋 Driver Selection Guide

### Docker Driver
```bash
minikube start --driver=docker
```
- **Pros:** Universal, works everywhere, simple
- **Cons:** Slightly slower than KVM
- **Best For:** macOS, Windows, quick testing

### KVM2 Driver (Linux only)
```bash
minikube start --driver=kvm2 --cpus=4 --memory=8192
```
- **Pros:** Fastest, native hypervisor, good performance
- **Cons:** Linux-only, requires setup
- **Best For:** Linux development, production-like testing

### VirtualBox Driver
```bash
minikube start --driver=virtualbox
```
- **Pros:** Universal, portable
- **Cons:** Slower than Docker/KVM
- **Best For:** Legacy systems, compatibility

### Hyperkit Driver (macOS only)
```bash
minikube start --driver=hyperkit
```
- **Pros:** Lightweight, good for macOS
- **Cons:** macOS-only, less stable than Docker
- **Best For:** macOS with limited resources

### Hyper-V Driver (Windows only)
```bash
minikube start --driver=hyperv
```
- **Pros:** Native Windows hypervisor
- **Cons:** Windows-only
- **Best For:** Windows development

---

## 🔧 Performance Tuning

### Resource Allocation

#### Minimal (Learning/Testing)
```bash
minikube start \
  --cpus=2 \
  --memory=4096 \
  --disk-size=20gb
```

#### Standard (Development)
```bash
minikube start \
  --cpus=4 \
  --memory=8192 \
  --disk-size=40gb
```

#### High Performance (Production-like)
```bash
minikube start \
  --cpus=8 \
  --memory=16384 \
  --disk-size=80gb
```

### Architecture-Specific Optimizations

#### For Apple Silicon
```bash
minikube start \
  --driver=docker \
  --cpus=4 \
  --memory=8192 \
  --container-runtime=docker \
  --image-repository=docker.io  # Use official images with ARM64 support
```

#### For Linux x86_64 with KVM
```bash
minikube start \
  --driver=kvm2 \
  --cpus=4 \
  --memory=8192 \
  --disk-size=40gb \
  --kvm-gpu=on  # If GPU available
```

#### For ARM64 (Graviton, Ampere)
```bash
minikube start \
  --driver=docker \
  --cpus=2 \
  --memory=4096 \
  --disk-size=30gb
```

---

## 🐛 Troubleshooting by Architecture

### Apple Silicon Issues

**Problem:** Image not available
```bash
# Solution: Use multi-arch images or specify ARM64
docker pull --platform linux/arm64 image:latest
```

**Problem:** Slow performance
```bash
# Solution: Check resource allocation
minikube config set memory 8192
minikube stop && minikube start
```

### ARM64 Linux Issues

**Problem:** Docker not found
```bash
# Solution: Install ARM64 Docker
curl -fsSL https://get.docker.com | sh
```

**Problem:** Limited images available
```bash
# Solution: Use official images with ARM support
kubectl run test --image=alpine:latest
```

### x86_64 Linux Issues

**Problem:** Virtualization not enabled
```bash
# Check
grep -E "vmx|svm" /proc/cpuinfo

# Enable in BIOS/UEFI
# Or use Docker driver instead
minikube start --driver=docker
```

**Problem:** KVM won't start
```bash
# Check KVM
sudo kvm-ok

# Install
sudo apt-get install qemu-kvm libvirt-daemon-system

# Add to group
sudo usermod -a -G libvirt $USER
```

---

## 📊 Quick Architecture Reference

| Feature | x86_64 | ARM64 | ARMv7 | ARMv6 |
|---------|--------|-------|-------|-------|
| **K8s Support** | ✅ Full | ✅ Full | ⚠️ Limited | ❌ Very Limited |
| **Docker** | ✅ Full | ✅ Full | ⚠️ Partial | ⚠️ Partial |
| **KVM** | ✅ Yes | ✅ Yes | ❌ No | ❌ No |
| **Hypervisor** | ✅ Full | ✅ Full | ⚠️ Limited | ⚠️ Limited |
| **Performance** | ✅ Excellent | ✅ Excellent | ⚠️ Good | ⚠️ Fair |
| **Image Support** | ✅ Most | ✅ Most | ⚠️ Some | ⚠️ Few |

---

## 🚀 Quick Start by System

### Intel Mac
```bash
brew install minikube kubectl
# Install Docker Desktop
./scripts/deploy-minikube.sh
```

### Apple Silicon Mac
```bash
brew install minikube kubectl
# Install Docker Desktop for Mac ARM64
./scripts/deploy-minikube.sh
```

### Ubuntu x86_64
```bash
curl -fsSL https://get.docker.com | sh
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
./scripts/deploy-minikube.sh
```

### Ubuntu ARM64
```bash
curl -fsSL https://get.docker.com | sh
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
./scripts/deploy-minikube.sh
```

---

## 📚 References

### Architecture Information
- [CPU Architecture Info](https://www.arm.com/)
- [x86-64 Overview](https://en.wikipedia.org/wiki/X86-64)
- [ARM64 Support Matrix](https://www.docker.com/blog/docker-builds-open-source-project/)

### Minikube Documentation
- [Minikube Drivers](https://minikube.sigs.k8s.io/docs/drivers/)
- [Minikube Configuration](https://minikube.sigs.k8s.io/docs/handbook/config/)

### Container Images
- [Docker Hub ARM Images](https://hub.docker.com/search?q=&image_filter=linux%2Farm64)
- [Multi-arch Images Guide](https://www.docker.com/blog/fast-multi-platform-builds/)

---

## ✅ Verification

After deployment, verify your setup:

```bash
# Check system
./scripts/system-check-advanced.sh

# Check cluster
minikube status
kubectl get nodes

# Check architecture
kubectl get node -o jsonpath='{.items[0].status.nodeInfo.architecture}'
```

---

**Next Step:** Run the deployment script!

```bash
./scripts/deploy-minikube.sh
```

---

For more information, see [README.md](README.md) or [GETTING_STARTED.md](GETTING_STARTED.md)
