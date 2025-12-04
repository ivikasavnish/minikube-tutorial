# 🚀 Minikube Interactive Tutorial

> **Deploy applications as an alternative to Docker/Docker Compose**

A comprehensive, beginner-friendly interactive tutorial for learning Minikube - local Kubernetes cluster for development and learning.

**Version:** 1.0.0

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [What is Minikube?](#what-is-minikube)
- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Interactive Tutorial](#interactive-tutorial)
- [Common Commands](#common-commands)
- [Logging & Tracing](#logging--tracing)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

---

## 🚀 Quick Start

### 1. Run the Interactive Tutorial

```bash
# Make the tutorial executable
chmod +x minikube_tutorial.py

# Run the tutorial
python3 minikube_tutorial.py
```

### 2. Automated Setup (Recommended for first-time users)

```bash
# Make the setup script executable
chmod +x scripts/quick-setup.sh

# Run automated setup
./scripts/quick-setup.sh

# Choose option "6. Full automated setup"
```

### 3. Verify Installation

```bash
# Make the check script executable
chmod +x scripts/check-system.sh

# Run system check
./scripts/check-system.sh
```

---

## ❓ What is Minikube?

**Minikube** is a lightweight, open-source local Kubernetes cluster that runs on your personal computer.

### Key Points:

- ✅ **Learning-Friendly**: Perfect for learning Kubernetes without cloud costs
- ✅ **Development**: Test containerized applications locally
- ✅ **Cross-Platform**: Works on macOS, Linux, and Windows
- ✅ **Multiple Drivers**: Docker, KVM, VirtualBox, Hyper-V support
- ✅ **Add-ons**: Built-in monitoring, dashboards, and ingress controllers

### Minikube vs Docker Compose

| Feature | Docker Compose | Minikube |
|---------|---------------|----------|
| **Complexity** | Simple | More complex |
| **Use Case** | Quick local dev | Kubernetes learning |
| **Orchestration** | Basic | Full Kubernetes |
| **Learning Curve** | Low | Medium |
| **Production-like** | No | Yes |
| **Scalability** | Limited | Full |

### When to Use Each:

**Use Docker Compose when:**
- Running simple multi-container apps
- Quick local development
- No need for orchestration
- Want minimal setup time

**Use Minikube when:**
- Learning Kubernetes
- Testing Kubernetes configurations
- Practicing microservices
- Need service discovery & load balancing
- Want production-like environment locally

---

## ✨ Features

The tutorial includes:

### 📖 Interactive Menu System
- Step-by-step guidance
- Beginner-friendly explanations
- Progress tracking
- Session management

### 🔧 Installation Guides
- Automatic system detection
- OS-specific instructions
- Docker installation
- Minikube setup
- kubectl installation
- KVM configuration for Linux

### 🎯 Deployment Walkthroughs
- Create sample applications
- Deploy to Minikube
- Manage replicas
- Access applications
- View logs and status

### 📊 Logging Setup
- Pod logging
- Log streaming
- Multi-container logs
- Event logging
- ELK stack integration examples

### 🔍 Distributed Tracing
- Jaeger integration
- OpenTelemetry setup
- Trace visualization
- Service tracking

### ✅ System Verification
- Dependency checking
- Cluster status
- Resource usage
- Troubleshooting help

---

## 📋 System Requirements

### Minimum Specifications:
- **CPU:** 2 cores
- **RAM:** 4 GB
- **Disk:** 20 GB free space
- **Virtualization:** Enabled in BIOS/UEFI

### Recommended Specifications:
- **CPU:** 4 cores
- **RAM:** 8 GB
- **Disk:** 30 GB free space

### Supported Operating Systems:
- macOS 10.12+
- Ubuntu 18.04+, Debian, Fedora
- Windows 10+ (with Hyper-V or WSL2)

### Virtualization Requirements:
- **macOS:** Native hypervisor support
- **Linux:** KVM, VirtualBox, or Docker
- **Windows:** Hyper-V or VirtualBox

---

## 🔧 Installation

### Method 1: Interactive Tutorial (Recommended)

```bash
python3 minikube_tutorial.py
# Select option 2 for Installation Guide
```

### Method 2: Automated Setup Script

```bash
./scripts/quick-setup.sh
# Choose "6. Full automated setup"
```

### Method 3: Manual Installation

#### Step 1: Install Docker

**macOS:**
```bash
brew install docker
# Or download Docker Desktop: https://www.docker.com/products/docker-desktop
```

**Linux:**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

#### Step 2: Install Minikube

**macOS:**
```bash
brew install minikube
```

**Linux:**
```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

#### Step 3: Install kubectl

**macOS:**
```bash
brew install kubectl
```

**Linux:**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

#### Step 4: Start Minikube

```bash
minikube start --driver=docker
```

---

## 🎯 Getting Started

### 1. Start Minikube

```bash
minikube start --driver=docker
# or with KVM (Linux)
minikube start --driver=kvm2 --cpus=4 --memory=8192
```

### 2. Verify Cluster is Running

```bash
minikube status
kubectl get nodes
```

### 3. Open Dashboard

```bash
minikube dashboard
```

### 4. Deploy Your First Application

```bash
# Create a deployment
kubectl create deployment hello-world --image=nginx

# Expose the service
kubectl expose deployment hello-world --type=LoadBalancer --port=80

# Access the application
minikube service hello-world
```

### 5. View Logs

```bash
# Get pod name
kubectl get pods

# View logs
kubectl logs <pod-name>

# Stream logs
kubectl logs -f <pod-name>
```

---

## 📖 Interactive Tutorial

### Running the Tutorial

```bash
python3 minikube_tutorial.py
```

### Menu Options

```
1. 📖 Introduction - What is Minikube?
2. 🔧 Installation Guide
3. ⚙️  Configure KVM (Linux)
4. 🎯 Deploy Sample Application
5. 📊 Setup Logging
6. 🔍 Setup Distributed Tracing
7. ✅ Verify Installation
8. 📝 View Logs
9. ℹ️  Version & System Info
0. 🚪 Exit
```

### What Each Section Covers

**Section 1: Introduction**
- What is Minikube and how it works
- Kubernetes concepts explained simply
- Minikube vs Docker Compose comparison
- System requirements

**Section 2: Installation**
- OS-specific installation steps
- Docker, Minikube, and kubectl setup
- Driver selection and configuration

**Section 3: KVM Setup**
- KVM installation on Linux
- Virtualization support checking
- KVM driver configuration

**Section 4: Deploy Sample Application**
- Interactive deployment wizard
- Generate YAML manifests
- Deploy to cluster
- Access application
- View deployment status

**Section 5: Logging**
- Basic pod logging
- Log streaming
- Multi-container logging
- Event logging
- ELK stack examples

**Section 6: Tracing**
- Distributed tracing concepts
- Jaeger installation
- OpenTelemetry integration
- Trace visualization

**Section 7: Verification**
- System dependency checking
- Cluster status verification
- Resource usage monitoring
- Troubleshooting help

---

## 📚 Common Commands

### Quick Reference

```bash
# Start/Stop Cluster
minikube start
minikube stop
minikube restart
minikube delete

# Cluster Info
minikube status
minikube logs
kubectl cluster-info
kubectl get nodes

# Deploy Applications
kubectl apply -f deployment.yaml
kubectl create deployment myapp --image=nginx
kubectl delete deployment myapp

# View Resources
kubectl get pods
kubectl get services
kubectl get deployments
kubectl get all

# Debugging
kubectl logs <pod-name>
kubectl logs -f <pod-name>
kubectl describe pod <pod-name>
kubectl exec -it <pod-name> -- /bin/bash

# Port Forwarding
kubectl port-forward svc/<service-name> 8080:80
minikube service <service-name>

# Scaling
kubectl scale deployment myapp --replicas=5

# Dashboard
minikube dashboard
```

### Detailed Command Reference

```bash
# View all available commands
./scripts/common-commands.sh

# Or view specific sections
./scripts/common-commands.sh all          # All commands
./scripts/common-commands.sh troubleshooting  # Troubleshooting
./scripts/common-commands.sh tips         # Best practices
./scripts/common-commands.sh examples     # Practical examples
```

---

## 📊 Logging & Tracing

### Pod Logging

```bash
# View pod logs
kubectl logs deployment/myapp

# Stream logs in real-time
kubectl logs -f deployment/myapp

# View logs with timestamps
kubectl logs deployment/myapp --timestamps=true

# View previous container logs (if crashed)
kubectl logs <pod-name> --previous
```

### Setup Logging with Structured JSON

```bash
cat > logging-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: logging-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: logging-app
  template:
    metadata:
      labels:
        app: logging-app
    spec:
      containers:
      - name: app
        image: python:3.9
        command: ["python", "-c"]
        args:
        - |
          import json
          import time
          from datetime import datetime

          while True:
            log_entry = {
              "timestamp": datetime.utcnow().isoformat(),
              "level": "INFO",
              "message": "Application running",
              "component": "app"
            }
            print(json.dumps(log_entry))
            time.sleep(2)
EOF

kubectl apply -f logging-deployment.yaml
```

### Distributed Tracing with Jaeger

```bash
# Install Jaeger
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-kubernetes/raw/master/jaeger-all-in-one-template.yml -n observability

# Access Jaeger UI
kubectl port-forward -n observability svc/jaeger-query 16686:16686
# Visit: http://localhost:16686
```

### Event Monitoring

```bash
# View cluster events
kubectl get events --sort-by=.metadata.creationTimestamp

# Watch events in real-time
kubectl get events -w

# Events for specific resource
kubectl describe pod <pod-name>
```

---

## 🐛 Troubleshooting

### Minikube Won't Start

```bash
# Check status
minikube status

# View logs
minikube logs | tail -20

# Try deleting and restarting
minikube delete
minikube start --driver=docker

# Try different driver
minikube start --driver=virtualbox
```

### kubectl Can't Connect

```bash
# Check context
kubectl config current-context

# Set correct context
kubectl config use-context minikube

# Reset kubeconfig
rm ~/.kube/config
minikube start
```

### Pod Stuck in Pending

```bash
# Check pod details
kubectl describe pod <pod-name>

# Check resource availability
kubectl top nodes
kubectl top pods

# Check resource limits in deployment
kubectl get deployment -o yaml | grep -A 5 "resources"
```

### Out of Disk Space

```bash
# Clean up unused images
docker image prune -a

# Remove volume data
minikube delete

# Start fresh
minikube start
```

### High CPU/Memory Usage

```bash
# Check resource usage
kubectl top nodes
kubectl top pods --all-namespaces

# Reduce replicas
kubectl scale deployment myapp --replicas=1

# Increase Minikube resources
minikube config set memory 8192
minikube config set cpus 4
minikube stop
minikube start
```

### Service Not Accessible

```bash
# Check service exists
kubectl get services

# Check endpoints
kubectl get endpoints

# Port forward
kubectl port-forward svc/myapp 8080:80

# Check logs
kubectl logs -l app=myapp
```

---

## 📝 Configuration

### Tutorial Configuration

Configuration is stored in:
```
~/.minikube_tutorial/config.json
```

### Logs Location

Tutorial logs are saved to:
```
~/.minikube_tutorial/logs/
```

### Minikube Configuration

View current Minikube configuration:
```bash
minikube config view
```

Set configuration:
```bash
minikube config set memory 8192
minikube config set cpus 4
minikube config set driver docker
```

---

## 📦 Directory Structure

```
minikube-demo/
├── minikube_tutorial.py          # Main interactive tutorial
├── README.md                      # This file
├── scripts/
│   ├── quick-setup.sh            # Automated installation script
│   ├── check-system.sh           # System verification script
│   └── common-commands.sh        # Command reference menu
└── examples/
    └── (Sample YAML files generated during tutorial)
```

---

## 🔧 System Check Script

Run system verification:

```bash
./scripts/check-system.sh
```

This checks:
- Docker installation and daemon status
- Minikube installation
- kubectl installation
- System memory
- CPU virtualization support
- Disk space
- Minikube cluster status
- Kubernetes resources

---

## 📈 Version Information

### Current Version: 1.0.0

### Included Versions:
- Minikube: Latest stable
- kubectl: Latest compatible
- Docker: Latest stable
- Kubernetes API: Latest compatible

### Version Check

```bash
# View tutorial version
python3 minikube_tutorial.py
# Select option 9

# Check installed tool versions
./scripts/check-system.sh
```

---

## 🌟 Features Breakdown

### ✨ Interactive Learning
- Menu-driven interface
- Color-coded output
- Progress tracking
- Session persistence

### 🔧 Installation Automation
- OS detection
- Automated setup
- Dependency checking
- Error handling

### 📊 Monitoring & Logging
- Pod log viewing
- Real-time streaming
- Multi-container support
- JSON parsing

### 🔍 Distributed Tracing
- Jaeger integration guides
- OpenTelemetry examples
- Trace visualization
- Service monitoring

### ✅ Verification Tools
- System checks
- Cluster validation
- Resource monitoring
- Troubleshooting hints

---

## 🎓 Learning Path

### Beginner (30 minutes)
1. Run interactive tutorial
2. Read Introduction section
3. Follow Installation Guide
4. Deploy sample application
5. View logs

### Intermediate (1-2 hours)
1. Learn Kubernetes concepts
2. Deploy custom application
3. Scale replicas
4. Set up logging
5. Practice port forwarding

### Advanced (2-4 hours)
1. Configure health probes
2. Set up persistent volumes
3. Implement distributed tracing
4. Create multi-service applications
5. Learn ingress configuration

---

## 🤝 Contributing

Found an issue or have suggestions? Please open an issue or submit a pull request.

---

## 📚 Additional Resources

### Official Documentation
- [Minikube Documentation](https://minikube.sigs.k8s.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Learning Resources
- [Kubernetes Official Tutorial](https://kubernetes.io/docs/tutorials/)
- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Kubernetes by Example](https://www.kubernetesbyexample.com/)

### Tools & Utilities
- [Minikube GitHub](https://github.com/kubernetes/minikube)
- [kubectl Download](https://kubernetes.io/docs/tasks/tools/)
- [Docker Documentation](https://docs.docker.com/)

### Community
- [Kubernetes Slack](https://kubernetes.slack.com/)
- [Stack Overflow - Kubernetes](https://stackoverflow.com/questions/tagged/kubernetes)
- [CNCF Community](https://www.cncf.io/community/)

---

## 📄 License

This tutorial is provided as-is for educational purposes.

---

## ✨ Quick Tips

1. **Always start with the Interactive Tutorial** - It guides you through everything
2. **Use namespace isolation** - Organize apps in different namespaces
3. **Set resource limits** - Prevents cluster overload
4. **Use health probes** - Ensures app availability
5. **Monitor with `top` commands** - Watch resource usage
6. **Read pod descriptions** - Rich debugging information
7. **Keep logs handy** - Essential for troubleshooting
8. **Use YAML for complex deployments** - Better than imperative commands

---

## 🚀 Next Steps

After completing the tutorial:

1. **Explore the Dashboard**
   ```bash
   minikube dashboard
   ```

2. **Try Multi-service Applications**
   - Create multiple deployments
   - Use Services for communication
   - Practice with ConfigMaps and Secrets

3. **Learn Ingress**
   - Route external traffic
   - Enable ingress add-on: `minikube addons enable ingress`
   - Create ingress resources

4. **Practice with Real Applications**
   - Deploy databases
   - Use persistent volumes
   - Implement health checks

5. **Dive Deeper**
   - StatefulSets for databases
   - DaemonSets for node agents
   - Jobs and CronJobs
   - Custom Resource Definitions (CRDs)

---

**Happy Learning! 🚀**

For help, run: `python3 minikube_tutorial.py` and select "Help"
