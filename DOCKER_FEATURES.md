# 🐳 Docker & Docker-Compose Features

Complete Docker support for deploying applications to Minikube.

**Version:** 1.0.0 | **New Feature** | **Release Date:** 2025-12-03

---

## ✨ What's New

### Docker-to-Minikube Deployment Tool

**File:** `scripts/docker-to-minikube.sh` (19 KB)

A complete tool for deploying Docker and Docker-Compose applications to Minikube.

---

## 🎯 Key Features

### 🔍 Automatic File Detection

```bash
# Automatically finds:
Dockerfile                  # Docker image definitions
docker-compose.yml         # Multi-container setups
docker-compose.yaml        # Alternative naming

# Searches:
- Current directory
- Subdirectories (max 3 levels)
- Auto-detects paths
```

### 🐳 Docker Image Building

```bash
# For Dockerfile projects:
1. Detects Dockerfile location
2. Prompts for image name and tag
3. Builds using Minikube's Docker daemon
4. Image immediately available to Kubernetes
```

**Benefits:**
- ✅ No need to push to registry
- ✅ Faster deployment
- ✅ Works offline

### 🔄 Docker Compose Conversion

```bash
# For docker-compose.yml projects:
1. Detects docker-compose.yml
2. Auto-installs Kompose (if needed)
3. Converts to Kubernetes manifests:
   - deployment.yaml
   - service.yaml
   - configmap.yaml
   - pvc.yaml (for volumes)
4. Ready to deploy
```

**Kompose Features:**
- Converts services → Deployments
- Converts ports → Services
- Converts volumes → PersistentVolumeClaims
- Converts environment → ConfigMaps
- Converts depends_on → init containers

### 📦 Kubernetes Manifest Generation

```bash
# For custom applications:
1. Interactive prompts for:
   - Application name
   - Docker image
   - Number of replicas
2. Generates deployment.yaml
3. Generates service.yaml
4. Ready to customize
```

### 🚀 One-Command Deployment

```bash
# Select option 8 for:
1. File detection
2. Image building
3. Manifest generation
4. Kubernetes deployment
5. Access instructions

# All in ~5-10 minutes
```

### 📊 Status Checking

```bash
# Integrated verification:
- Minikube status
- Cluster info
- Node information
- Deployment status
- Service status
- Pod status
```

### 📋 Access Instructions

```bash
# Automatic guidance for:
- kubectl port-forward
- minikube service
- kubectl get services
- Useful commands
```

### 🧹 Cleanup Management

```bash
# Interactive deletion of:
- Deployments
- Services
- All resources
```

---

## 🚀 Usage

### Simplest Way

```bash
# Navigate to Docker project
cd /path/to/your/docker/app

# Run the tool
/path/to/minikube-demo/scripts/docker-to-minikube.sh

# Select option 8
# Wait ~5 minutes
# Application deployed!
```

### Step-by-Step

```bash
/path/to/minikube-demo/scripts/docker-to-minikube.sh

# Choose individual options:
1. Find Docker Files
2. Build Docker Image
3. Convert Docker Compose
4. Generate Manifests
5. Deploy to Minikube
7. Show Access Info
```

### Automatic Mode

```bash
/path/to/minikube-demo/scripts/docker-to-minikube.sh auto

# Non-interactive, automatic processing
```

---

## 📚 Example Projects

### Example 1: Simple Docker App

**Structure:**
```
my-app/
├── Dockerfile
├── app.py
└── requirements.txt
```

**Deploy:**
```bash
cd my-app
/path/to/scripts/docker-to-minikube.sh
# Select: 2 (Build Docker Image)
# Select: 6 (Deploy)
```

### Example 2: Multi-Service Compose

**Structure:**
```
my-fullstack/
├── docker-compose.yml
├── frontend/
│   └── Dockerfile
├── backend/
│   └── Dockerfile
└── db/
    └── init.sql
```

**Deploy:**
```bash
cd my-fullstack
/path/to/scripts/docker-to-minikube.sh
# Select: 8 (Full Deployment)
```

### Example 3: Using Included Examples

**Simple Compose:**
```bash
cd /path/to/minikube-demo/examples
/path/to/scripts/docker-to-minikube.sh
# Uses: docker-compose-simple.yml
```

**Full Stack:**
```bash
cp examples/docker-compose-fullstack.yml docker-compose.yml
/path/to/scripts/docker-to-minikube.sh
# Select: 8
```

---

## 🔧 Installation

### Kompose Auto-Installation

The script automatically:
1. Checks if Kompose is installed
2. Downloads if missing
3. Installs to system path
4. Verifies installation

**Manual Installation:**

```bash
# macOS
brew install kompose

# Linux
curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-linux-amd64 -o kompose
sudo install kompose /usr/local/bin/
```

---

## 📊 Interactive Menu

```
┌─ MAIN MENU ───────────────────────────────────┐
│                                               │
│ 1. 🔍 Find Docker Files (scan directory)     │
│ 2. 🐳 Build Docker Image                      │
│ 3. 🔄 Convert Docker Compose to Kubernetes   │
│ 4. 📦 Generate Kubernetes Manifests          │
│ 5. ✅ Verify Minikube Status                  │
│ 6. 🚀 Deploy to Minikube                      │
│ 7. 📋 Show Access Instructions               │
│ 8. 🧠 Full Deployment (all steps)            │
│ 9. 🧹 Cleanup Deployment                     │
│ 0. 🚪 Exit                                    │
│                                               │
└───────────────────────────────────────────────┘
```

---

## 💡 Features at a Glance

### Detection
✅ Automatic Dockerfile detection
✅ Automatic docker-compose.yml detection
✅ Subdirectory scanning (3 levels)
✅ Context-aware path detection

### Building
✅ Docker image compilation
✅ Uses Minikube's Docker daemon
✅ Interactive image naming
✅ Tag management

### Conversion
✅ Kompose integration
✅ Auto-install Kompose
✅ YAML generation
✅ Multiple manifest types

### Deployment
✅ Kubernetes deployment
✅ Service creation
✅ ConfigMap handling
✅ Volume management

### Access
✅ Port forwarding setup
✅ Service exposure
✅ Minikube service integration
✅ Access instructions

### Management
✅ Status checking
✅ Log viewing
✅ Cleanup/deletion
✅ Health verification

---

## 🔄 Docker to Kubernetes Mapping

| Docker Concept | Kubernetes Equivalent | Notes |
|---|---|---|
| Service | Deployment | Each service becomes a deployment |
| Ports | Service | Exposed ports as Kubernetes Service |
| Environment | ConfigMap | Environment variables as ConfigMap |
| Volumes | PersistentVolumeClaim | Storage volumes as PVC |
| depends_on | Init Containers | Startup order as init containers |
| Healthcheck | Probes | Health checks as liveness/readiness probes |
| Network | NetworkPolicy | Docker networks as Kubernetes NetworkPolicy |
| Restart | RestartPolicy | Restart behavior preserved |

---

## 📈 Workflow Examples

### Workflow 1: Quick Test

```
1. Have Docker app ready
2. Run docker-to-minikube.sh
3. Select: 8
4. Wait 5 minutes
5. Test via port-forward
6. Done!
```

### Workflow 2: Development Iteration

```
1. Create docker-compose.yml
2. Deploy to Minikube
3. Make code changes
4. Rebuild image: docker build -t app:v2 .
5. Update deployment: kubectl set image deployment/app app=app:v2
6. Test changes
7. Repeat
```

### Workflow 3: Multi-Service Stack

```
1. Have full docker-compose setup
2. Run docker-to-minikube.sh
3. Select: 3 (Convert Docker Compose)
4. Select: 6 (Deploy)
5. All services deployed together
6. Access via minikube service
```

---

## 🎯 Use Cases

### Use Case 1: Migrate from Docker Compose

```
Current: Using docker-compose locally
Goal: Learn Kubernetes without rewriting
Solution: Use docker-to-minikube.sh
```

### Use Case 2: Local Testing Before Production

```
Current: Have Kubernetes YAML
Goal: Test on local Minikube first
Solution: Deploy with kubectl apply
```

### Use Case 3: Teach Kubernetes to Docker Users

```
Current: Team knows Docker Compose
Goal: Transition to Kubernetes
Solution: Use docker-to-minikube as bridge
```

### Use Case 4: CI/CD Local Testing

```
Current: Building Docker images in CI
Goal: Test in Kubernetes environment
Solution: Deploy to local Minikube
```

---

## 🔒 Security Features

### Image Building
- Uses Minikube's Docker daemon
- Images not exposed to network
- No registry credentials needed

### Manifest Generation
- Customizable resource limits
- Health checks included
- Network policies supported

### Deployment
- RBAC support
- Secret management
- Network isolation

---

## 📊 Included Examples

### Example 1: `docker-compose-simple.yml`

**Contains:**
- Nginx web server
- Redis cache
- Health checks
- Volume management
- Network configuration

**Use:**
```bash
cp examples/docker-compose-simple.yml docker-compose.yml
/path/to/scripts/docker-to-minikube.sh
```

### Example 2: `docker-compose-fullstack.yml`

**Contains:**
- Frontend service
- Backend API
- PostgreSQL database
- Redis cache
- Nginx reverse proxy

**Use:**
```bash
cp examples/docker-compose-fullstack.yml docker-compose.yml
/path/to/scripts/docker-to-minikube.sh
```

---

## 🚀 Quick Start

### 30 Seconds

```bash
# 1. Navigate to Docker project
cd /your/docker/project

# 2. Run script
/path/to/minikube-demo/scripts/docker-to-minikube.sh

# 3. Select option 8
# 4. Wait for completion
```

### 5 Minutes

```bash
# 1. Understand your Docker setup
ls -la Dockerfile docker-compose.yml

# 2. Run tool with options
/path/to/scripts/docker-to-minikube.sh
# Select options 1-7 step by step

# 3. Review generated YAML
cat kubernetes/*.yaml

# 4. Deploy manually if needed
kubectl apply -f kubernetes/
```

---

## 📝 Documentation

**Complete Guide:** [DOCKER_DEPLOYMENT_GUIDE.md](DOCKER_DEPLOYMENT_GUIDE.md)

**Topics Covered:**
- Installation
- Usage methods
- Step-by-step walkthroughs
- Troubleshooting
- Common workflows
- Useful commands
- Security considerations
- Learning resources

---

## 🔧 Troubleshooting

### Kompose Not Found
```bash
# Auto-installed by script, or:
brew install kompose
```

### Minikube Not Running
```bash
minikube start
```

### Image Build Failed
```bash
# Check syntax
docker build .

# Verify Docker running
docker ps
```

### Deployment Failed
```bash
# Check pod status
kubectl get pods

# View logs
kubectl logs <pod-name>

# Describe pod
kubectl describe pod <pod-name>
```

---

## 📞 Support & Help

### Getting Help
1. Run the tool: `/path/to/scripts/docker-to-minikube.sh`
2. Read prompts and messages
3. Check [DOCKER_DEPLOYMENT_GUIDE.md](DOCKER_DEPLOYMENT_GUIDE.md)
4. Review troubleshooting section

### Useful Commands
```bash
# Check status
kubectl get all

# View logs
kubectl logs -f deployment/<app>

# Scale app
kubectl scale deployment/<app> --replicas=3

# Delete deployment
kubectl delete deployment <app>
```

---

## 🎉 Summary

This feature enables:

✅ **Easy Docker-to-Kubernetes transition**
✅ **Automatic file detection**
✅ **Kompose integration**
✅ **One-command deployment**
✅ **Full management interface**
✅ **Real-world examples**
✅ **Comprehensive documentation**

---

## 🚀 Get Started

```bash
# Navigate to your Docker project
cd /path/to/your/docker/app

# Run the tool
/path/to/minikube-demo/scripts/docker-to-minikube.sh

# Select: 8 (Full Deployment)

# Wait for completion

# Access your app!
```

---

**Version:** 1.0.0
**Status:** Production Ready ✅
**Last Updated:** 2025-12-03

**🐳 Deploy Docker apps to Kubernetes!**
