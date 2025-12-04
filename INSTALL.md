# 📦 Installation Guide

Complete installation instructions for Minikube Tutorial.

## 🚀 Quick Start

### Fastest Way (Recommended)

```bash
# Run the interactive tutorial
python3 minikube_tutorial.py
```

Then select option 2 for installation guide and follow prompts.

---

## 💻 Installation by Operating System

### macOS

#### Option 1: Using Homebrew (Recommended)

```bash
# Install Minikube
brew install minikube

# Install Docker Desktop
brew install --cask docker

# Install kubectl
brew install kubectl

# Start Minikube
minikube start --driver=docker

# Verify installation
minikube status
```

#### Option 2: Manual Installation

```bash
# 1. Download Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
rm minikube-darwin-amd64

# 2. Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# 3. Download Docker Desktop
# Visit: https://www.docker.com/products/docker-desktop

# 4. Start cluster
minikube start --driver=docker
```

### Linux

#### Ubuntu/Debian

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

# 3. Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# 4. (Optional) Install KVM
# See KVM section below

# 5. Start cluster
minikube start --driver=docker
# Or with KVM:
minikube start --driver=kvm2 --cpus=4 --memory=8192
```

#### Fedora/RHEL

```bash
# 1. Install Docker
sudo dnf install docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker

# 2. Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# 3. Install kubectl
sudo dnf install kubectl

# 4. Start cluster
minikube start --driver=docker
```

### Windows

#### Option 1: Chocolatey

```powershell
# Install Chocolatey first if not installed
# https://chocolatey.org/install

# Install components
choco install minikube
choco install docker-desktop
choco install kubernetes-cli

# Start Minikube
minikube start --driver=docker
```

#### Option 2: Manual Installation

```powershell
# 1. Download Minikube
# https://github.com/kubernetes/minikube/releases/download/latest/minikube-windows-amd64.exe

# 2. Download Docker Desktop
# https://www.docker.com/products/docker-desktop

# 3. Download kubectl
# https://kubernetes.io/docs/tasks/tools/

# 4. Add to PATH and start cluster
minikube start --driver=docker
```

#### Using WSL2

```bash
# Install WSL2 first
wsl --install

# Then follow Ubuntu/Debian steps above
```

---

## ⚙️ KVM Setup (Linux Only)

### Check Virtualization Support

```bash
# Intel
grep -w vmx /proc/cpuinfo

# AMD
grep -w svm /proc/cpuinfo
```

Both should return matches. If not, enable virtualization in BIOS.

### Install KVM

#### Ubuntu/Debian

```bash
# Update package list
sudo apt-get update

# Install KVM and related tools
sudo apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    virt-manager \
    docker.io

# Add current user to groups
sudo usermod -a -G libvirt $USER
sudo usermod -a -G docker $USER

# Activate new group (or logout/login)
newgrp libvirt
newgrp docker

# Verify KVM installation
virsh list --all
```

#### Fedora/RHEL

```bash
# Install KVM
sudo dnf install -y \
    qemu-kvm \
    libvirt \
    virt-daemon-system \
    virt-manager \
    docker

# Configure user
sudo usermod -a -G libvirt $USER
sudo usermod -a -G docker $USER

# Start services
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# Verify
virsh list --all
```

### Start Minikube with KVM

```bash
# Basic start with KVM
minikube start --driver=kvm2

# With custom resources
minikube start --driver=kvm2 --cpus=4 --memory=8192 --disk-size=40gb

# Check if running
minikube status
minikube ssh "uname -a"
```

---

## ✅ Verification

### After Installation

Run the verification script:

```bash
./scripts/check-system.sh
```

You should see all checks pass with ✓ marks.

### Manual Verification

```bash
# Check Docker
docker --version
docker ps

# Check Minikube
minikube version
minikube status

# Check kubectl
kubectl version --client

# Check cluster
kubectl cluster-info
kubectl get nodes
```

---

## 🔧 Troubleshooting Installation

### Docker not found

**Problem:** `docker: command not found`

**Solution:**
```bash
# Install Docker using tutorial
python3 minikube_tutorial.py
# Select option 2

# Or manually:
# macOS: brew install docker
# Linux: curl -fsSL https://get.docker.com | sh
# Windows: Download Docker Desktop from docker.com
```

### Minikube won't start

**Problem:** `minikube start` fails

**Solutions:**
```bash
# 1. Check if Docker is running
docker ps

# 2. Check virtualization enabled
# macOS: Should work by default
# Linux: grep vmx|svm /proc/cpuinfo
# Windows: Enable Hyper-V or use VirtualBox

# 3. Try different driver
minikube start --driver=virtualbox

# 4. Clean and restart
minikube delete
minikube start --driver=docker

# 5. Check logs
minikube logs
```

### "Unable to load minikube cluster"

```bash
# Reset kubeconfig
rm ~/.kube/config
minikube start

# Or use specific context
kubectl config use-context minikube
```

### "No space left on device"

```bash
# Clean Docker resources
docker system prune -a

# Delete Minikube
minikube delete

# Check disk space
df -h

# Restart
minikube start
```

### KVM device not found

```bash
# Verify KVM installed
kvm-ok  # or grep vmx /proc/cpuinfo

# Reinstall if needed
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# Check permissions
id | grep libvirt  # Should show libvirt group
```

---

## 📋 System Requirements Verification

### Minimum (Will work, but slowly)
- CPU: 2 cores
- RAM: 4 GB
- Disk: 20 GB free

### Recommended (Smooth experience)
- CPU: 4 cores
- RAM: 8 GB
- Disk: 30 GB free

### Check Your System

```bash
# macOS
sysctl -n hw.ncpu           # CPU count
sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}'  # RAM in GB

# Linux
nproc                       # CPU count
free -g                     # RAM in GB
df -h | head -2             # Disk space

# Windows PowerShell
$env:PROCESSOR_COUNT        # CPU count
[math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)  # RAM
```

---

## 🎯 Next Steps After Installation

### 1. Verify Everything Works

```bash
python3 minikube_tutorial.py
# Select option 7 (Verify Installation)
```

### 2. Deploy Your First App

```bash
python3 minikube_tutorial.py
# Select option 4 (Deploy Sample Application)
```

### 3. Learn the Commands

```bash
./scripts/common-commands.sh all
```

### 4. Explore Examples

```bash
ls -la examples/
kubectl apply -f examples/simple-deployment.yaml
```

---

## 🐛 Getting Help

1. **View Tutorial Logs:**
   ```bash
   python3 minikube_tutorial.py
   # Select option 8 (View Logs)
   ```

2. **System Check:**
   ```bash
   ./scripts/check-system.sh
   ```

3. **Common Commands Reference:**
   ```bash
   ./scripts/common-commands.sh troubleshooting
   ```

4. **Check Documentation:**
   - [README.md](README.md) - Comprehensive guide
   - [GETTING_STARTED.md](GETTING_STARTED.md) - Quick start guide

5. **Online Resources:**
   - [Minikube Docs](https://minikube.sigs.k8s.io/)
   - [Kubernetes Docs](https://kubernetes.io/docs/)
   - [Docker Docs](https://docs.docker.com/)

---

## 🔄 Updating Components

### Update Minikube

```bash
# macOS
brew upgrade minikube

# Linux
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Update kubectl

```bash
# macOS
brew upgrade kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Update Docker

- **macOS:** Check Docker app → Check for updates
- **Linux:** `sudo apt-get upgrade docker.io` or `sudo dnf upgrade docker`
- **Windows:** Docker Desktop auto-updates

---

## 📝 Installation Record

Keep track of your installation:

```bash
# Save versions
cat > ~/.minikube_tutorial/installation.log << 'EOF'
Date: $(date)
OS: $(uname -s)
Docker: $(docker --version)
Minikube: $(minikube version)
kubectl: $(kubectl version --client --short)
Virtualization: $(cat /proc/cpuinfo | grep -c vmx || cat /proc/cpuinfo | grep -c svm)
EOF

cat ~/.minikube_tutorial/installation.log
```

---

## ✨ Installation Complete!

Once installation is verified with `./scripts/check-system.sh`, you're ready!

**Next:** Run the interactive tutorial
```bash
python3 minikube_tutorial.py
```

---

**Questions?** See [GETTING_STARTED.md](GETTING_STARTED.md) or [README.md](README.md)
