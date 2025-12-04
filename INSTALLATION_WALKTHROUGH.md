# 🔧 Complete Guided Installation Walkthrough

Step-by-step guided installation with automatic verification and troubleshooting.

**Version:** 1.0.0 | **Date:** 2025-12-03

---

## 🚀 Overview

The new guided installation provides:

- ✅ **Automatic OS Detection** - Detects your system (macOS, Linux, Windows)
- ✅ **Step-by-Step Guidance** - Clear instructions for each step
- ✅ **Automatic Verification** - Checks if tools are already installed
- ✅ **Architecture Support** - Instructions for Intel/AMD (x86_64) and ARM64
- ✅ **Interactive Prompts** - Asks for confirmation at each step
- ✅ **Error Handling** - Detects and handles installation issues
- ✅ **Driver Selection** - Choose Docker or KVM2 on Linux
- ✅ **Final Summary** - Next steps after installation

---

## 📋 Installation Steps

### Step 1️⃣: Docker Installation

**What it does:**
- Checks if Docker is already installed
- Shows OS-specific installation instructions if needed
- Verifies installation after you complete it

**For macOS:**
```
1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop
2. Double-click the .dmg file
3. Drag Docker.app to Applications folder
4. Launch Docker from Applications
5. Allow privileged helper installation when prompted
6. Verify: docker --version
```

**For Linux (Ubuntu/Debian):**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
# Verify: docker --version
```

**For Windows:**
```
1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop
2. Run the installer
3. Enable WSL 2 backend when prompted
4. Restart your computer
5. Verify: docker --version
```

### Step 2️⃣: Minikube Installation

**What it does:**
- Checks if Minikube is already installed
- Shows architecture-specific instructions (x86_64 or ARM64)
- Verifies installation

**For macOS:**
```bash
# Option 1: Using Homebrew (recommended)
brew install minikube

# Option 2: Direct download
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

**For Linux (x86_64):**
```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

**For Linux (ARM64):**
```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
```

**For Windows:**
```powershell
# Option 1: Using Chocolatey
choco install minikube

# Option 2: Download from: https://github.com/kubernetes/minikube/releases
# Add to PATH
```

### Step 3️⃣: kubectl Installation

**What it does:**
- Checks if kubectl is already installed
- Shows architecture-specific instructions
- Verifies installation

**For macOS:**
```bash
# Option 1: Using Homebrew (recommended)
brew install kubectl

# Option 2: Direct download
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

**For Linux (x86_64):**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

**For Linux (ARM64):**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

**For Windows:**
```powershell
# Option 1: Using Chocolatey
choco install kubernetes-cli

# Option 2: Download from: https://kubernetes.io/docs/tasks/tools/
# Add to PATH
```

### Step 4️⃣: Start Minikube

**What it does:**
- Checks if Minikube is already running
- Offers to start it if not
- For Linux: lets you choose between Docker and KVM2 driver
- Verifies successful startup

**Command:**
```bash
# On macOS/Windows
minikube start --driver=docker

# On Linux with Docker
minikube start --driver=docker

# On Linux with KVM2 (recommended)
minikube start --driver=kvm2 --cpus=4 --memory=8192
```

**Linux Driver Choice:**
When running on Linux, you'll be asked which driver to use:
- `1` = Docker driver (default, easiest)
- `2` = KVM2 driver (faster, requires KVM setup)

---

## 🎯 How to Use the Guided Installation

### Launch the Tutorial

```bash
python3 minikube_tutorial.py
```

### Select Option 2

When the menu appears:
```
1. 📖 Introduction - What is Minikube?
2. 🔧 Installation Guide          ← SELECT THIS
3. ⚙️  Configure KVM (Linux)
...
```

### Follow the Interactive Prompts

The tutorial will:
1. **Detect your OS** automatically (shown on screen)
2. **Check Docker** - Ask you to install if needed
3. **Verify installation** - Test if Docker is working
4. **Check Minikube** - Ask you to install if needed
5. **Verify installation** - Test if Minikube is working
6. **Check kubectl** - Ask you to install if needed
7. **Verify installation** - Test if kubectl is working
8. **Start Minikube** - Offer to start the cluster
9. **Show summary** - Display next steps

### Answer the Prompts

At each step, you'll see:
```
Have you installed Docker? (y/n): █
```

- Type `y` if you've installed it
- Type `n` if you haven't

The script will verify or provide installation instructions.

---

## ✅ System Requirements

**Minimum:**
- 2 CPU cores
- 4 GB RAM
- 20 GB free disk space
- Docker, KVM, or VirtualBox

**Recommended:**
- 4+ CPU cores
- 8+ GB RAM
- 30 GB free disk space
- For Linux: KVM driver installed

---

## 🔍 Verification

After installation, verify everything is working:

```bash
# Check Docker
docker --version
docker run hello-world

# Check Minikube
minikube status
minikube version

# Check kubectl
kubectl version --client
kubectl get nodes
```

---

## 🐛 Troubleshooting

### "Docker command not found"

**Cause:** Docker is not installed or not in PATH

**Solution:**
1. Install Docker (download from docker.com)
2. Restart your terminal
3. Run: `docker --version`

### "Minikube command not found"

**Cause:** Minikube is not installed or not in PATH

**Solution:**
1. Install Minikube (follow guided installation)
2. Restart your terminal
3. Run: `minikube version`

### "kubectl not found"

**Cause:** kubectl is not installed or not in PATH

**Solution:**
1. Install kubectl (follow guided installation)
2. Restart your terminal
3. Run: `kubectl version --client`

### "Minikube fails to start"

**Cause:** Could be Docker not running or resource constraints

**Solution:**
```bash
# Start Docker first
# Then try:
minikube start --driver=docker --memory=4096 --cpus=2
```

### "Permission denied" errors on Linux

**Cause:** Docker group permissions not set

**Solution:**
```bash
sudo usermod -aG docker $USER
newgrp docker
docker ps
```

### "Insufficient disk space"

**Cause:** Not enough disk space for Minikube

**Solution:**
```bash
# Clean up
minikube delete
docker system prune -a
# Free up at least 30GB
minikube start
```

---

## 📊 What Each Component Does

### Docker
- Container runtime for running applications
- Used by Minikube to create the Kubernetes environment
- Also used to build container images

### Minikube
- Local Kubernetes cluster simulator
- Runs a single-node cluster on your machine
- Perfect for development and learning

### kubectl
- Command-line tool for managing Kubernetes
- Used to deploy, manage, and monitor applications
- Communicates with Minikube cluster

---

## 🚀 After Installation

Once installation is complete, you can:

### 1. Open the Dashboard
```bash
minikube dashboard
```

### 2. Deploy Your First App
```bash
kubectl create deployment hello --image=nginx
kubectl expose deployment hello --type=LoadBalancer --port=80
```

### 3. Access the App
```bash
kubectl port-forward svc/hello 8080:80
# Visit: http://localhost:8080
```

### 4. Check Cluster Status
```bash
kubectl get nodes
kubectl get pods
kubectl get services
```

### 5. Continue with Tutorial
```bash
python3 minikube_tutorial.py
# Select other options to learn more
```

---

## 💾 Configuration & Logs

### Configuration Location
```
~/.minikube_tutorial/config.json
```

### Installation Logs
```
~/.minikube_tutorial/logs/tutorial_*.log
```

### Minikube Data
```
~/.minikube/
```

### kubectl Config
```
~/.kube/config
```

---

## 🔐 Security Notes

1. **Default Credentials**: Minikube uses default, insecure credentials for development
2. **Network Access**: Minikube services are only accessible locally
3. **Not for Production**: Do not use for production workloads
4. **Credentials Storage**: kubectl stores credentials in `~/.kube/config`

---

## 📚 Additional Resources

- **Kubernetes Docs**: https://kubernetes.io/docs/
- **Minikube Docs**: https://minikube.sigs.k8s.io/
- **Docker Docs**: https://docs.docker.com/
- **kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

---

## 🎓 Next Learning Steps

After successful installation:

1. **Run the Tutorial** - `python3 minikube_tutorial.py` → Option 1 (Introduction)
2. **Deploy Sample Apps** - Tutorial Option 4
3. **Setup Logging** - Tutorial Option 5
4. **Setup Tracing** - Tutorial Option 6
5. **Explore Add-ons** - Tutorial Option 10
6. **Install Helm Packages** - Tutorial Option 11

---

## 🆘 Getting Help

If you encounter issues:

1. **Check logs** - View `/Users/vikasavnish/.minikube_tutorial/logs/`
2. **Run system check** - `./scripts/system-check-advanced.sh`
3. **Verify each tool**:
   ```bash
   docker --version
   minikube version
   kubectl version --client
   ```
4. **Check Minikube status** - `minikube status`
5. **Read documentation** - Check the README.md and other guides

---

## ✨ Features of the Guided Installation

| Feature | Status |
|---------|--------|
| Automatic OS Detection | ✅ Yes |
| Step-by-step Guidance | ✅ Yes |
| Install Verification | ✅ Yes |
| Architecture Support (x86_64, ARM64) | ✅ Yes |
| Windows/macOS/Linux | ✅ Yes |
| Interactive Prompts | ✅ Yes |
| Error Handling | ✅ Yes |
| Final Summary | ✅ Yes |
| Activity Logging | ✅ Yes |

---

**Version:** 1.0.0
**Status:** Production Ready ✅
**Last Updated:** 2025-12-03

**🚀 Complete guided installation ready!**
