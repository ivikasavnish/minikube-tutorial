# 🐳 Docker & Docker-Compose to Minikube Deployment Guide

Deploy Docker and Docker-Compose applications directly to Minikube Kubernetes cluster.

**Version:** 1.0.0 | **Last Updated:** 2025-12-03

---

## 🎯 Overview

This guide explains how to:
- ✅ Deploy Docker containers to Minikube
- ✅ Convert Docker Compose to Kubernetes manifests
- ✅ Automatically detect Docker files
- ✅ Use Kompose for conversion
- ✅ Deploy everything with one command

---

## 🚀 Quick Start

### 1. Navigate to Your Docker Project

```bash
cd /path/to/your/docker/project
```

### 2. Run Docker-to-Minikube Tool

```bash
/path/to/minikube-demo/scripts/docker-to-minikube.sh
```

### 3. Follow the Interactive Menu

```
1. 🔍 Find Docker Files
2. 🐳 Build Docker Image
3. 🔄 Convert Docker Compose to Kubernetes
4. 📦 Generate Kubernetes Manifests
5. ✅ Verify Minikube Status
6. 🚀 Deploy to Minikube
7. 📋 Show Access Instructions
8. 🧠 Full Deployment (all steps)
9. 🧹 Cleanup Deployment
0. 🚪 Exit
```

### 4. Select Option 8 for Automatic Deployment

```
# Select: 8
# Wait for automatic processing
# Access your app!
```

---

## 📋 What You Need

### Software Requirements

```bash
# Required:
docker --version           # Docker (for building images)
minikube status            # Minikube cluster
kubectl version            # Kubernetes CLI

# For Docker Compose conversion:
kompose version            # Kubernetes Compose converter
```

### File Requirements

Your project should have one of:

```
docker-compose.yml         # Docker Compose definition
# OR
Dockerfile                 # Docker image definition
```

---

## 🔄 How It Works

### 1. File Detection

The tool automatically scans your directory for:

```bash
# Searches for:
Dockerfile              # Docker image definition
docker-compose.yml      # Multi-container setup
docker-compose.yaml     # Alternative naming
```

**Detection scope:**
- Current directory (max 3 levels deep)
- Auto-finds in subdirectories

### 2. Docker Image Building

If `Dockerfile` is found:

```bash
# Interactive prompts for:
Image name:     (e.g., my-app)
Image tag:      (default: latest)

# Builds using Minikube's Docker daemon
eval $(minikube docker-env)
docker build -t my-app:latest .
```

**Benefits:**
- ✅ Image available to Minikube immediately
- ✅ No need to push to registry
- ✅ Faster deployment

### 3. Docker Compose Conversion

If `docker-compose.yml` is found:

```bash
# Uses Kompose to convert:
kompose convert -o kubernetes/

# Generates Kubernetes manifests:
- deployment.yaml
- service.yaml
- configmap.yaml
- pvc.yaml (for volumes)
```

**What Kompose does:**
- Converts services → Deployments
- Converts ports → Services
- Converts volumes → PersistentVolumeClaims
- Converts environment → ConfigMaps
- Converts depends_on → init containers

### 4. Kubernetes Deployment

Manifests are deployed to Minikube:

```bash
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
# ... and other generated files
```

---

## 💻 Installation Methods

### Method 1: Automatic Full Deployment

```bash
/path/to/minikube-demo/scripts/docker-to-minikube.sh

# Select: 8 (Full Deployment)
# Automatic steps:
# 1. Find Docker files
# 2. Build image
# 3. Convert docker-compose
# 4. Generate manifests
# 5. Deploy to Minikube
# 6. Show access info
```

**Time:** ~5-10 minutes (depending on image size)

### Method 2: Step-by-Step Interactive

```bash
/path/to/minikube-demo/scripts/docker-to-minikube.sh

# Select individual options:
1. Find Docker Files
2. Build Docker Image
3. Convert Docker Compose
4. Generate Manifests
5. Deploy to Minikube
7. Show Access Info
```

**Time:** ~10-15 minutes (more control)

### Method 3: Automatic Mode (CLI)

```bash
/path/to/minikube-demo/scripts/docker-to-minikube.sh auto
```

Non-interactive, automatic processing

---

## 📚 Example Use Cases

### Use Case 1: Simple Web Server

**Project Structure:**
```
my-web-app/
├── Dockerfile
├── app.py
└── requirements.txt
```

**Deployment:**
```bash
cd my-web-app
/path/to/scripts/docker-to-minikube.sh
# Select: 8
# Wait for deployment
# Access at: http://localhost:8080
```

### Use Case 2: Multi-Container Docker Compose

**Project Structure:**
```
full-stack-app/
├── docker-compose.yml
├── frontend/
│   └── Dockerfile
├── backend/
│   └── Dockerfile
└── db/
    └── init.sql
```

**Deployment:**
```bash
cd full-stack-app
/path/to/scripts/docker-to-minikube.sh
# Select: 8
# Automatically:
# - Converts docker-compose.yml
# - Creates Kubernetes manifests
# - Deploys to Minikube
# - Shows access instructions
```

### Use Case 3: Existing Kubernetes YAML

If you already have Kubernetes manifests:

```bash
cd your-k8s-project
kubectl apply -f .
```

(No need to use docker-to-minikube script)

---

## 🔍 Kompose Installation

Kompose is automatically installed by the script if not present.

### Manual Installation

#### macOS

```bash
# Using Homebrew
brew install kompose

# Or download
curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-darwin-amd64 -o kompose
chmod +x kompose
sudo mv kompose /usr/local/bin/
```

#### Linux

```bash
curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv kompose /usr/local/bin/
```

#### Windows

```powershell
# Download from GitHub
# https://github.com/kubernetes/kompose/releases/

# Or use Chocolatey
choco install kompose
```

### Verify Installation

```bash
kompose version
```

---

## 📖 Docker Compose to Kubernetes Mapping

How docker-compose.yml is converted:

| Docker Compose | Kubernetes | Notes |
|---|---|---|
| `services` | `Deployment` | Each service becomes a deployment |
| `image` | `containers[].image` | Container image reference |
| `ports` | `Service` | Exposed ports become services |
| `environment` | `ConfigMap` | Env vars converted to ConfigMap |
| `volumes` | `PersistentVolumeClaim` | Storage becomes PVC |
| `depends_on` | `initContainers` | Startup order becomes init containers |
| `healthcheck` | `livenessProbe` | Health checks become probes |
| `restart` | `restartPolicy` | Restart policies converted |
| `networks` | `NetworkPolicy` | Networks become network policies |

---

## 🎯 Step-by-Step Walkthrough

### Step 1: Find Docker Files

```bash
Select: 1

# Output:
# ✓ Found Dockerfile: ./Dockerfile
# ✓ Found Docker Compose: ./docker-compose.yml
```

The script scans your directory structure.

### Step 2: Build Docker Image

```bash
Select: 2

# Prompts:
# Enter Docker image name (default: my-app):
# Enter image tag (default: latest):

# Builds image and loads into Minikube
```

### Step 3: Convert Docker Compose

```bash
Select: 3

# Requires Kompose (auto-installed if needed)
# Output files in: ./kubernetes/
# - deployment.yaml
# - service.yaml
# - configmap.yaml
# - pvc.yaml (if volumes present)
```

### Step 4: Generate Kubernetes Manifests

```bash
Select: 4

# Creates manifests in: ./kubernetes-generated/
# Generated files ready for deployment
```

### Step 5: Verify Minikube

```bash
Select: 5

# Shows:
# Minikube status
# Cluster info
# Node information
```

### Step 6: Deploy to Minikube

```bash
Select: 6

# Applies all YAML files
# kubectl apply -f kubernetes/
# Starts your application
```

### Step 7: Access Your Application

```bash
Select: 7

# Shows three access methods:
# 1. kubectl port-forward
# 2. minikube service
# 3. kubectl get services
```

---

## 📊 Examples Included

### Example 1: Simple Compose

**File:** `examples/docker-compose-simple.yml`

Contains:
- Nginx web server
- Redis cache
- Health checks
- Volume management

**Deploy:**
```bash
cd examples
docker-compose-simple.yml
/path/to/scripts/docker-to-minikube.sh
# Select: 8
```

### Example 2: Full Stack

**File:** `examples/docker-compose-fullstack.yml`

Contains:
- Frontend (React/Next.js)
- Backend API
- PostgreSQL database
- Redis cache
- Nginx reverse proxy

**Deploy:**
```bash
cp examples/docker-compose-fullstack.yml docker-compose.yml
/path/to/scripts/docker-to-minikube.sh
# Select: 8
```

---

## 🔧 Troubleshooting

### Issue: Kompose Not Found

**Solution:**
```bash
# Script will auto-install, or manually:
brew install kompose    # macOS
# Or download from GitHub
```

### Issue: Minikube Not Running

**Solution:**
```bash
minikube start
# Then retry deployment
```

### Issue: Image Build Failed

**Solution:**
```bash
# Check Dockerfile syntax
docker build .

# Check Docker is running
docker ps

# Use Minikube's Docker daemon
eval $(minikube docker-env)
```

### Issue: Conversion Failed

**Solution:**
```bash
# Check docker-compose.yml syntax
docker-compose config

# Manual conversion:
kompose convert docker-compose.yml -o kubernetes/
```

### Issue: Deployment Stuck

**Solution:**
```bash
# Check pod status
kubectl get pods

# View pod logs
kubectl logs <pod-name>

# Describe pod
kubectl describe pod <pod-name>

# Check events
kubectl get events
```

---

## 🎓 Common Workflows

### Workflow 1: Quick Local Testing

```bash
# 1. Your code is in Docker
cd my-app

# 2. Deploy to local Minikube
/path/to/scripts/docker-to-minikube.sh
Select: 8

# 3. Test locally
minikube service my-app

# 4. Make changes
# Edit code, rebuild Dockerfile

# 5. Update deployment
docker build -t my-app:v2 .
kubectl set image deployment/my-app my-app=my-app:v2
```

### Workflow 2: Multi-Service Development

```bash
# 1. Have docker-compose.yml
cd full-stack-app

# 2. Convert and deploy
/path/to/scripts/docker-to-minikube.sh
Select: 8

# 3. Iterate on services
# Edit docker-compose.yml

# 4. Redeploy
docker-compose convert to kubernetes
kubectl apply -f kubernetes/

# 5. Check logs
kubectl logs -f deployment/my-service
```

### Workflow 3: Production-Like Testing

```bash
# 1. Start with docker-compose
# (same as development setup)

# 2. Convert to Kubernetes
kompose convert docker-compose.yml

# 3. Test on Minikube
kubectl apply -f *.yaml

# 4. Review for production
# Check resource limits, security, etc.

# 5. Deploy to production cluster
# (with appropriate modifications)
```

---

## 📋 Useful Commands

### View Deployments

```bash
kubectl get deployments
kubectl get services
kubectl get pods
```

### Access Services

```bash
# Port forward
kubectl port-forward svc/my-app 8080:80

# Minikube service
minikube service my-app

# Get external IP
kubectl get services
```

### View Logs

```bash
# Logs from deployment
kubectl logs -f deployment/my-app

# Logs from specific pod
kubectl logs -f pod/my-app-xyz123

# Logs from all pods in deployment
kubectl logs -f -l app=my-app
```

### Scale Application

```bash
# Scale to 3 replicas
kubectl scale deployment my-app --replicas=3

# Auto-scale based on CPU
kubectl autoscale deployment my-app --min=1 --max=5 --cpu-percent=70
```

### Update Configuration

```bash
# Update environment variables
kubectl set env deployment/my-app KEY=value

# Update image
kubectl set image deployment/my-app app=my-app:v2
```

### Cleanup

```bash
# Delete deployment
kubectl delete deployment my-app

# Delete service
kubectl delete service my-app

# Delete all
kubectl delete -f kubernetes/
```

---

## 🔐 Security Considerations

When deploying from Docker Compose to Kubernetes:

1. **Image Registry**
   - Local images work in Minikube
   - For production, use private registry
   - Update image pull policy: `imagePullPolicy: Always`

2. **Secrets Management**
   - Don't put secrets in docker-compose.yml
   - Use Kubernetes Secrets
   - Example: `kubectl create secret generic db-pass --from-literal=password=xyz`

3. **Network Policies**
   - Kompose generates basic NetworkPolicy
   - Review and strengthen as needed
   - Restrict traffic between services

4. **Resource Limits**
   - Always set CPU/Memory limits
   - Prevent resource exhaustion
   - Monitor usage with `kubectl top pods`

5. **Health Checks**
   - Convert health checks to probes
   - Use liveness and readiness probes
   - Ensure container is really healthy

---

## 📚 Learn More

### Official Resources
- [Kompose Documentation](https://kompose.io/)
- [Docker Compose Spec](https://github.com/compose-spec/compose-spec)
- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)

### Related Guides
- [README.md](README.md) - Complete tutorial
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Deployment guide
- [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) - Architecture info

---

## 🚀 Next Steps

1. **Prepare your Docker files**
   - Make sure Dockerfile and/or docker-compose.yml exist
   - Test locally with Docker first

2. **Run the deployment tool**
   ```bash
   /path/to/scripts/docker-to-minikube.sh
   ```

3. **Select option 8 for automatic deployment**

4. **Access your application**
   ```bash
   kubectl port-forward svc/my-app 8080:80
   ```

5. **Monitor and iterate**
   ```bash
   kubectl logs -f deployment/my-app
   kubectl describe pod <pod-name>
   ```

---

## 📞 Support

If you encounter issues:

1. **Check the script output** - detailed error messages
2. **Verify prerequisites** - Docker, Minikube, kubectl
3. **Check docker-compose.yml syntax** - `docker-compose config`
4. **Review Kubernetes logs** - `kubectl logs <pod-name>`
5. **Read troubleshooting section** - above in this guide

---

**Version:** 1.0.0
**Status:** Production Ready ✅
**Last Updated:** 2025-12-03

**🚀 Deploy your Docker apps to Minikube!**
