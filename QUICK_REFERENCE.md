# ⚡ Quick Reference Card

## 🚀 Essential Commands

### Cluster Management
```bash
minikube start                  # Start cluster
minikube stop                   # Stop cluster
minikube restart                # Restart cluster
minikube delete                 # Delete cluster
minikube status                 # Show status
minikube dashboard              # Open dashboard
```

### Pod Operations
```bash
kubectl get pods                # List pods
kubectl get pods -w             # Watch pods
kubectl describe pod <name>     # Show pod details
kubectl logs <pod-name>         # Show logs
kubectl logs -f <pod-name>      # Stream logs
kubectl exec -it <pod> -- sh   # Shell into pod
kubectl delete pod <name>       # Delete pod
```

### Deployment Management
```bash
kubectl create deployment <name> --image=<image>  # Create deployment
kubectl get deployments         # List deployments
kubectl delete deployment <name> # Delete deployment
kubectl scale deployment <name> --replicas=3  # Scale replicas
kubectl set image deployment/<name> <container>=<image>  # Update image
kubectl rollout status deployment/<name>  # Check rollout
kubectl rollout undo deployment/<name>    # Rollback
```

### Services
```bash
kubectl get services            # List services
kubectl expose deployment <name> --port=80  # Expose service
kubectl port-forward svc/<name> 8080:80  # Port forward
kubectl delete service <name>   # Delete service
minikube service <name>         # Open service in browser
```

### Debugging
```bash
kubectl get events              # Show events
kubectl top nodes               # Node resource usage
kubectl top pods                # Pod resource usage
kubectl describe node minikube  # Node details
kubectl get all                 # All resources
```

---

## 📁 File Structure

```
minikube-demo/
├── minikube_tutorial.py         ← Main interactive tutorial
├── README.md                    ← Complete documentation
├── GETTING_STARTED.md           ← Quick start guide
├── INSTALL.md                   ← Installation instructions
├── QUICK_REFERENCE.md           ← This file
├── scripts/
│   ├── quick-setup.sh          ← Automated setup
│   ├── check-system.sh         ← System verification
│   └── common-commands.sh      ← Command reference
└── examples/
    ├── simple-deployment.yaml
    ├── multi-service-app.yaml
    ├── logging-example.yaml
    └── tracing-example.yaml
```

---

## 🎯 Usage Paths

### Path 1: Interactive (Easiest)
```
Run: python3 minikube_tutorial.py
→ Option 2 (Installation)
→ Option 4 (Deploy App)
→ Option 5 (Logging)
→ Option 6 (Tracing)
```

### Path 2: Automated Script
```
Run: ./scripts/quick-setup.sh
→ Option 6 (Full setup)
→ Follow prompts
```

### Path 3: Manual
```
1. Read INSTALL.md
2. Run commands manually
3. Verify with: ./scripts/check-system.sh
```

---

## 🔧 Configuration Locations

```bash
~/.minikube/                    # Minikube data
~/.kube/config                  # Kubernetes config
~/.minikube_tutorial/config.json # Tutorial progress
~/.minikube_tutorial/logs/      # Tutorial logs
```

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| `docker: not found` | Run tutorial → Option 2 (Install) |
| `minikube: not found` | Run tutorial → Option 2 (Install) |
| Minikube won't start | `minikube delete && minikube start` |
| `kubectl: can't connect` | `kubectl config use-context minikube` |
| Out of disk space | `minikube delete && docker system prune` |
| High CPU/Memory | `kubectl top nodes` → scale down replicas |
| Service not accessible | `kubectl port-forward svc/<name> 8080:80` |

---

## 📊 Example Commands

### Deploy Nginx
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=LoadBalancer --port=80
kubectl port-forward svc/nginx 8080:80
# Visit: http://localhost:8080
```

### Deploy from YAML
```bash
kubectl apply -f examples/simple-deployment.yaml
kubectl get all
kubectl delete -f examples/simple-deployment.yaml
```

### View Logs
```bash
kubectl logs deployment/nginx
kubectl logs -f deployment/nginx --timestamps=true
```

### Scale Application
```bash
kubectl scale deployment nginx --replicas=5
kubectl get pods -l app=nginx
```

---

## 🌐 Access Applications

```bash
# Port forward
kubectl port-forward svc/<service-name> 8080:80

# Then visit: http://localhost:8080

# Or use Minikube service command
minikube service <service-name>

# Get service info
kubectl get services
kubectl describe service <service-name>
```

---

## 📝 Useful Aliases

Add to `~/.bashrc` or `~/.zshrc`:

```bash
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias mm='minikube'
alias mms='minikube start'
alias mmc='minikube config view'
```

---

## 🔑 Key Concepts

**Pod** - Smallest unit (container wrapper)
**Service** - Exposes pods to network
**Deployment** - Manages pod replicas
**ConfigMap** - Store configuration
**Secret** - Store sensitive data
**Volume** - Persistent storage
**Namespace** - Logical cluster division

---

## 📚 Help & Information

```bash
# Interactive tutorial
python3 minikube_tutorial.py

# System verification
./scripts/check-system.sh

# Commands reference
./scripts/common-commands.sh

# View tutorial logs
python3 minikube_tutorial.py → Option 8

# Get version info
python3 minikube_tutorial.py → Option 9
```

---

## ✅ Quick Health Check

```bash
# One-liner to verify everything
minikube status && docker ps && kubectl get nodes
```

If all return ✓, you're good to go!

---

## 🎓 Learning Resources

- [GETTING_STARTED.md](GETTING_STARTED.md) - Start here
- [README.md](README.md) - Full documentation
- [INSTALL.md](INSTALL.md) - Installation details
- [examples/](examples/) - Sample YAML files

---

## 🚀 Quick Start

```bash
# 1. Run tutorial
python3 minikube_tutorial.py

# 2. Select Installation (Option 2)

# 3. Deploy app (Option 4)

# 4. Access application
kubectl port-forward svc/myapp 8080:80

# 5. View logs
kubectl logs -f deployment/myapp
```

---

**🎉 You're ready to go!**

For more details, see [README.md](README.md)
