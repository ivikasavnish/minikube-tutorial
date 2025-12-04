# 🎛️ Minikube Add-ons Management Guide

Enable and manage essential Minikube add-ons for enhanced cluster functionality.

**Version:** 1.0.0 | **New Feature** | **Release Date:** 2025-12-03

---

## 🎯 Overview

Minikube includes built-in add-ons that provide critical functionality:

- **Dashboard**: Web-based UI for cluster management and visualization
- **Tunnel (MetalLB)**: LoadBalancer service support and external access
- **Registry**: Local Docker image registry (no Docker Hub push needed)
- **Metrics Server**: Resource monitoring and `kubectl top` commands
- **Ingress**: Kubernetes Ingress controller for routing

---

## ✨ What's Included

### Dashboard
```
- Web-based Kubernetes cluster UI
- Pod, deployment, and service visualization
- Log viewing and pod management
- Real-time cluster insights
```

### Tunnel (MetalLB)
```
- LoadBalancer service type support
- Assign external IPs to services
- Port forwarding for local access
- Service discovery
```

### Registry
```
- Local Docker image registry
- No Docker Hub push required
- Fast image distribution
- Offline-capable
```

### Metrics Server
```
- CPU and memory usage metrics
- Resource monitoring
- Horizontal Pod Autoscaler (HPA) support
- kubectl top commands
```

---

## 🚀 Quick Start

### Simplest Way (Auto Setup)

```bash
./scripts/minikube-addons.sh auto
```

All add-ons enabled in ~5 minutes.

### Interactive Menu

```bash
./scripts/minikube-addons.sh

# Then select options:
# 10 - Full Setup (all add-ons)
# 3 - Open Dashboard
# 5 - Start Tunnel
```

---

## 📚 Detailed Usage

### 1. Dashboard

**Enable Dashboard:**
```bash
./scripts/minikube-addons.sh
# Select: 2 (Enable Dashboard)
```

**Access Dashboard:**
```bash
minikube dashboard
# Or via script: select option 3
```

**Features:**
- Cluster overview
- Node status
- Pod management
- Service visualization
- Deployment details
- Log viewing
- Resource usage

---

### 2. Tunnel (MetalLB)

**Enable Tunnel:**
```bash
./scripts/minikube-addons.sh
# Select: 4 (Enable Tunnel)
```

**Start Tunnel:**
```bash
minikube tunnel
# Or via script: select option 5
```

**Why Use Tunnel?**
- Assign external IPs to LoadBalancer services
- Access services from your machine without port-forward
- Mimic production load balancer behavior
- Essential for testing service routing

**Example Usage:**
```bash
# Create a LoadBalancer service
kubectl expose deployment myapp --type=LoadBalancer --port=80

# Check service
kubectl get svc

# Access directly (requires tunnel)
curl http://<EXTERNAL-IP>
```

---

### 3. Registry

**Enable Registry:**
```bash
./scripts/minikube-addons.sh
# Select: 6 (Enable Registry)
```

**Available at:** `localhost:5000`

**How to Use:**

**Option A: Build and Push Locally**
```bash
# Build image
docker build -t myapp:v1 .

# Tag for registry
docker tag myapp:v1 localhost:5000/myapp:v1

# Push to Minikube registry
docker push localhost:5000/myapp:v1

# Use in deployment
kubectl set image deployment/myapp myapp=localhost:5000/myapp:v1
```

**Option B: Create Deployment**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: localhost:5000/myapp:v1
        imagePullPolicy: Always  # Always pull from registry
        ports:
        - containerPort: 8080
```

**Benefits:**
- No Docker Hub authentication needed
- Faster image pulling (local network)
- Works offline
- Perfect for private images
- Immediate image availability in cluster

---

### 4. Metrics Server

**Enable Metrics:**
```bash
./scripts/minikube-addons.sh
# Select: 7 (Enable Metrics Server)
```

**Wait ~1 minute for metrics to be collected.**

**View Metrics:**
```bash
# Node metrics
kubectl top nodes

# Pod metrics (all namespaces)
kubectl top pods --all-namespaces

# Pod metrics (specific namespace)
kubectl top pods -n default
```

**Uses:**
- Monitor resource usage
- Set up Horizontal Pod Autoscaling (HPA)
- Identify resource bottlenecks
- Capacity planning

**Example HPA:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

### 5. Ingress Controller

**Enable Ingress:**
```bash
./scripts/minikube-addons.sh
# Select: 9 (Enable Ingress Controller)
```

**Create Ingress Route:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - host: example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp
            port:
              number: 80
```

**Access Ingress:**
```bash
# Get Ingress IP
kubectl get ingress

# Add to hosts file (on macOS/Linux)
echo "127.0.0.1 example.local" | sudo tee -a /etc/hosts

# Access via browser or curl
curl http://example.local
```

---

## 📊 Add-ons Menu Structure

```
┌─ MINIKUBE ADD-ONS MENU ────────────────────┐
│                                            │
│ 1. 📊 List All Add-ons Status              │
│ 2. 🖥️  Enable Dashboard                    │
│ 3. 🌐 Open Dashboard in Browser            │
│ 4. 🔗 Enable Tunnel (MetalLB)              │
│ 5. 🚦 Start Tunnel (foreground)            │
│ 6. 📦 Enable Registry                      │
│ 7. 📈 Enable Metrics Server                │
│ 8. 📊 View Metrics                         │
│ 9. 🔌 Enable Ingress Controller            │
│ 10. 🧠 Full Setup (all add-ons)            │
│ 11. ℹ️  Show Access Information            │
│ 12. 📋 View Activity Log                   │
│ 0. 🚪 Exit                                 │
│                                            │
└────────────────────────────────────────────┘
```

---

## 🔧 Troubleshooting

### Dashboard Not Opening

**Issue:** Dashboard doesn't appear in browser

**Solution:**
```bash
# Check if enabled
minikube addons list | grep dashboard

# If disabled, enable it
minikube addons enable dashboard

# Try opening again
minikube dashboard
```

### Tunnel Not Working

**Issue:** Services can't access LoadBalancer

**Solution:**
```bash
# Check if MetalLB is enabled
minikube addons list | grep metallb

# Enable MetalLB
minikube addons enable metallb

# Start tunnel in separate terminal
minikube tunnel

# Check service status
kubectl get svc -w
```

### Registry Push Fails

**Issue:** Docker push to localhost:5000 fails

**Solution:**
```bash
# 1. Verify registry is enabled
minikube addons list | grep registry

# 2. Check if registry pod is running
kubectl get pods -n kube-system | grep registry

# 3. Verify Docker daemon is using Minikube
eval $(minikube docker-env)

# 4. Check registry is accessible
curl http://localhost:5000/v2/_catalog
```

### Metrics Not Available

**Issue:** `kubectl top pods` shows no data

**Solution:**
```bash
# Wait 1-2 minutes after enabling

# Check metrics server is running
kubectl get pods -n kube-system | grep metrics-server

# View metrics server logs
kubectl logs -n kube-system deployment/metrics-server

# Verify metrics are collected
kubectl get hpa  # HPA uses metrics
```

---

## 💡 Common Workflows

### Workflow 1: Complete Setup

```bash
# 1. Run script
./scripts/minikube-addons.sh

# 2. Select option 10 (Full Setup)
# Waits for:
#   ✓ Dashboard enabled
#   ✓ Tunnel enabled
#   ✓ Registry enabled
#   ✓ Metrics enabled
#   ✓ Ingress enabled

# 3. Access services
minikube dashboard &          # Dashboard
minikube tunnel &             # Tunnel (separate terminal)
kubectl port-forward svc/myapp 8080:80
```

### Workflow 2: Local Development

```bash
# 1. Enable registry
./scripts/minikube-addons.sh
# Select: 6

# 2. Build and push image
docker build -t myapp:v1 .
docker tag myapp:v1 localhost:5000/myapp:v1
docker push localhost:5000/myapp:v1

# 3. Deploy using local image
kubectl set image deployment/myapp myapp=localhost:5000/myapp:v1

# 4. Monitor with metrics
kubectl top pods
kubectl top nodes
```

### Workflow 3: Production-Like Testing

```bash
# 1. Enable all add-ons
./scripts/minikube-addons.sh
# Select: 10

# 2. Create LoadBalancer service
kubectl expose deployment myapp --type=LoadBalancer --port=80

# 3. Start tunnel (separate terminal)
minikube tunnel

# 4. Access service with external IP
kubectl get svc
# Use EXTERNAL-IP

# 5. Monitor performance
kubectl top pods
kubectl top nodes
```

---

## 📈 Monitoring Setup

**Complete Observability Stack:**

```bash
# 1. Enable metrics
./scripts/minikube-addons.sh
# Select: 7

# 2. Install Prometheus & Grafana
./scripts/helm-packages.sh
# Select: M (Monitoring Stack)

# 3. Open Dashboard
minikube dashboard

# 4. Check metrics
kubectl top nodes
kubectl top pods

# 5. View Grafana
kubectl port-forward -n monitoring svc/grafana 3000:80
# Visit: http://localhost:3000
```

---

## 🔐 Security Considerations

### Registry Security
- Local registry is not TLS-enabled
- Only for development/testing
- Add TLS for production

### Tunnel Security
- MetalLB assignment is not encrypted
- Use on trusted networks only
- Configure network policies as needed

### Dashboard Security
- No authentication by default
- Use port-forward or tunnel with caution
- Consider RBAC for multi-user clusters

---

## 📊 Add-ons Comparison

| Feature | Dashboard | Tunnel | Registry | Metrics | Ingress |
|---------|-----------|--------|----------|---------|---------|
| Purpose | Management UI | Service access | Image registry | Monitoring | Routing |
| Essential | No | Yes (for LB) | Yes (local dev) | Yes | No |
| Resource Usage | Low | Medium | Medium | Low | Low |
| Setup Time | ~10s | ~10s | ~10s | ~1min | ~10s |
| Disk Required | No | No | Yes (5GB) | No | No |

---

## 🚀 Quick Commands

```bash
# Enable all at once
./scripts/minikube-addons.sh auto

# List all add-ons
./scripts/minikube-addons.sh
# Select: 1

# Open dashboard
./scripts/minikube-addons.sh
# Select: 3

# Start tunnel
./scripts/minikube-addons.sh
# Select: 5

# View metrics
./scripts/minikube-addons.sh
# Select: 8

# View logs
tail -20 ~/.minikube_tutorial/logs/addons_*.log
```

---

## 📞 Support

If you encounter issues:

1. Check add-ons status: `minikube addons list`
2. Check pods: `kubectl get pods -n kube-system`
3. View logs: `kubectl logs -n kube-system <pod-name>`
4. Review troubleshooting section above

---

**Version:** 1.0.0
**Status:** Production Ready ✅
**Last Updated:** 2025-12-03

**🎛️ Enhance your Minikube cluster!**
