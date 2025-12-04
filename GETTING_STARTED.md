# 🚀 Getting Started with Minikube Tutorial

Welcome! This guide will help you get up and running with the Minikube Tutorial in 5 minutes.

## 📋 Prerequisites

You need:
- **macOS**, **Linux**, or **Windows** machine
- **Python 3.7+** (or Python 3 available via `python3` command)
- **Internet connection** for downloading components

That's it! The tutorial will guide you through installing everything else.

---

## 🎯 Quick Start (4 Options)

### Option 1: Interactive Installation (RECOMMENDED - Most Guided)

This is the **easiest and most interactive** way to get started:

```bash
./scripts/interactive-install.sh
```

Then select: **Option 8 - Full Guided Installation**

**What it does:**
- ✅ Detects your system automatically
- ✅ Guides you through each step with prompts
- ✅ Helps install Docker (interactive help on macOS)
- ✅ Installs Minikube
- ✅ Installs kubectl
- ✅ Optional: Sets up KVM (Linux)
- ✅ Deploys your Kubernetes cluster
- ✅ Saves detailed installation log

**Time:** ~15 minutes | **Skill Level:** Beginner

### Option 2: Interactive Tutorial (For Learning)

Use the interactive tutorial for learning along with installation:

```bash
python3 minikube_tutorial.py
```

The tutorial menu appears with options:

1. **Choose option 1** - Introduction (learn concepts)
2. **Choose option 2** - Installation Guide
3. **Choose option 4** - Deploy your first app
4. **Explore other sections** - Logging and tracing

**Time:** 30 min - 2 hours | **Skill Level:** Beginner to Intermediate

### Option 3: Automated Setup Script (For Linux)

Linux users can use the automated setup script:

```bash
./scripts/quick-setup.sh
```

Then:
- **Choose option 6** for "Full automated setup"

This will automatically:
- Install Docker
- Install Minikube
- Install kubectl
- Optionally install and configure KVM
- Start Minikube

**Time:** ~10-15 minutes | **Skill Level:** Beginner

### Option 4: Step-by-Step Documentation

If you prefer reading documentation first:

1. Read: [INTERACTIVE_INSTALLATION.md](INTERACTIVE_INSTALLATION.md) - Complete step-by-step guide
2. Then run: `./scripts/interactive-install.sh` - Use interactive menu as you read
3. Or follow manual commands in: [INSTALL.md](INSTALL.md)

---

## 🎛️ Advanced Features (Optional)

After installing Minikube, you can optionally enhance your cluster with:

### Minikube Add-ons (Dashboard, Tunnel, Registry, Metrics)

```bash
./scripts/minikube-addons.sh
```

**What it includes:**
- 🖥️ **Dashboard** - Web UI for cluster management
- 🔗 **Tunnel** - LoadBalancer service support
- 📦 **Registry** - Local Docker image registry
- 📈 **Metrics** - Resource monitoring and HPA support
- 🔌 **Ingress** - HTTP/HTTPS routing

**Time:** ~5 minutes | [Full Guide](ADDONS_GUIDE.md)

### Helm Packages (20 Production-Ready Packages)

```bash
./scripts/helm-packages.sh
```

**What you can install:**
- 📊 **Monitoring Stack:** Prometheus, Grafana, Thanos
- 📋 **Logging Stack:** Loki, Elasticsearch, Kibana
- 🔗 **Tracing Stack:** Jaeger, OpenTelemetry Collector
- 💾 **Databases:** PostgreSQL, MongoDB, Redis, RabbitMQ, Kafka, MinIO
- 🔧 **Infrastructure:** Nginx Ingress, Cert-Manager, Sealed Secrets, ArgoCD, Vault

**Time:** 5 minutes (single package) to 30 minutes (all 20) | [Full Guide](HELM_PACKAGES_GUIDE.md)

### Minikube Recipes (12 Ready-to-Deploy Applications)

```bash
./scripts/minikube-recipes.sh
```

**What you can deploy:**
- 🌐 **Web:** Nginx, Kong Gateway
- 🗄️ **Databases:** PostgreSQL, MongoDB, Redis, Redis Cluster
- 📬 **Messaging:** RabbitMQ
- 🏗️ **Full-Stack:** Multi-tier applications
- 📊 **Observability:** Logging, Tracing
- 🧪 **Testing:** Load testing, CI/CD pipelines

**Key Features:**
- One-click deployment
- Production-ready configurations
- Access instructions and credentials
- Browser-based documentation links
- Easy cleanup

**Time:** 2-5 minutes per recipe | [Full Guide](RECIPES.md)

---

## 📖 First Steps

### 1. Start the Tutorial

```bash
python3 minikube_tutorial.py
```

### 2. Main Menu Appears

You'll see a menu with options:

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

### 3. Follow the Flow

**For complete beginners:**

```
1. Start → Option 1 (Introduction)
   ↓
2. Next → Option 2 (Installation)
   ↓
3. Install Docker when prompted
   ↓
4. Install Minikube when prompted
   ↓
5. Return → Option 7 (Verify Installation)
   ↓
6. Next → Option 4 (Deploy Sample App)
   ↓
7. Deploy nginx sample
   ↓
8. Access the app: kubectl port-forward svc/myapp 8080:80
```

---

## ✅ Verification Checklist

### After Installation

Run this command to verify everything is installed:

```bash
./scripts/check-system.sh
```

You should see:
- ✓ Docker installed
- ✓ Minikube installed
- ✓ kubectl installed
- ✓ Sufficient memory
- ✓ Virtualization enabled (Linux)

### If Any Check Fails

1. Run the **Installation Guide** (Option 2 in tutorial)
2. Follow the prompts to install missing components
3. Run verification again

---

## 🎓 Learning Path

### Session 1 (30 minutes)
```
1. Run tutorial → Option 1 (Introduction)
2. Read the concepts
3. Run tutorial → Option 2 (Installation)
4. Install Docker and Minikube
```

### Session 2 (45 minutes)
```
1. Run tutorial → Option 7 (Verify Installation)
2. Check everything is working
3. Run tutorial → Option 4 (Deploy Sample App)
4. Create your first deployment
5. Access the app in your browser
```

### Session 3 (1 hour)
```
1. Run tutorial → Option 5 (Logging)
2. Learn about log collection
3. Run tutorial → Option 6 (Tracing)
4. Setup distributed tracing
5. View traces in Jaeger UI
```

---

## 🔧 Common Tasks

### Start/Stop Minikube

```bash
# Start cluster
minikube start --driver=docker

# Stop cluster
minikube stop

# Check status
minikube status
```

### Deploy an Application

```bash
# Simple deployment
kubectl create deployment myapp --image=nginx

# Expose it
kubectl expose deployment myapp --type=LoadBalancer --port=80

# Access it
kubectl port-forward svc/myapp 8080:80
# Visit: http://localhost:8080
```

### View Logs

```bash
# Stream logs from deployment
kubectl logs -f deployment/myapp
```

### Open Dashboard

```bash
# Opens Kubernetes dashboard in browser
minikube dashboard
```

### Quick Reference

```bash
# View all commands
./scripts/common-commands.sh

# Or specific sections
./scripts/common-commands.sh all          # All commands
./scripts/common-commands.sh troubleshooting  # Help with problems
./scripts/common-commands.sh tips         # Best practices
./scripts/common-commands.sh examples     # Example commands
```

---

## 🐛 Troubleshooting

### "Minikube not found" error

**Solution:** Minikube is not installed. Run:
```bash
python3 minikube_tutorial.py
# Select option 2 (Installation Guide)
```

### "Docker daemon is not running"

**Solution:** Start Docker:
- **macOS:** Click Docker icon in Applications
- **Linux:** Run `sudo systemctl start docker`
- **Windows:** Click Docker Desktop in Start menu

### "kubectl can't connect to cluster"

**Solution:** Start Minikube:
```bash
minikube start --driver=docker
```

### "No space left on device"

**Solution:** Clean up:
```bash
minikube delete
docker system prune
minikube start
```

### Other Issues?

See [Troubleshooting](README.md#-troubleshooting) section in README.md

---

## 📚 Next Steps

After completing the tutorial:

1. **Explore the Dashboard**
   ```bash
   minikube dashboard
   ```

2. **Try Sample Deployments**
   ```bash
   kubectl apply -f examples/simple-deployment.yaml
   kubectl apply -f examples/multi-service-app.yaml
   kubectl apply -f examples/logging-example.yaml
   ```

3. **Read More Resources**
   - [README.md](README.md) - Complete guide
   - [examples/](examples/) - Sample YAML files
   - [Kubernetes Docs](https://kubernetes.io/docs/)

4. **Continue Learning**
   - ConfigMaps and Secrets
   - Persistent Volumes
   - Ingress Controllers
   - Stateful Applications
   - Custom Resource Definitions

---

## ⚡ Quick Commands

```bash
# Cluster management
minikube start                      # Start cluster
minikube stop                       # Stop cluster
minikube delete                     # Delete cluster
minikube dashboard                  # Open dashboard

# Viewing resources
kubectl get pods                    # List pods
kubectl get services                # List services
kubectl get deployments             # List deployments
kubectl get all                     # List all resources

# Debugging
kubectl logs <pod-name>             # View pod logs
kubectl describe pod <pod-name>     # Show pod details
kubectl exec -it <pod-name> -- sh  # Shell into pod
kubectl port-forward svc/<name> 8080:80  # Port forward

# Management
kubectl apply -f file.yaml          # Deploy from YAML
kubectl delete -f file.yaml         # Delete from YAML
kubectl scale deployment <name> --replicas=3  # Scale replicas
```

---

## 💡 Tips

1. **Bookmark the Commands Reference**
   ```bash
   ./scripts/common-commands.sh
   ```

2. **Use Tab Completion**
   ```bash
   kubectl [TAB]
   ```

3. **Watch Resources in Real-time**
   ```bash
   kubectl get pods -w
   ```

4. **Get Help Anytime**
   - Run `python3 minikube_tutorial.py` again
   - View logs: Run tutorial → Option 8
   - Check system: `./scripts/check-system.sh`

5. **Save Your Work**
   - Tutorial creates configs in: `~/.minikube_tutorial/`
   - Logs saved in: `~/.minikube_tutorial/logs/`

---

## ❓ FAQ

**Q: Does this require cloud account?**
A: No! Everything runs locally on your machine.

**Q: Can I use this on Windows?**
A: Yes! Install Docker Desktop (includes Hyper-V) or VirtualBox.

**Q: Do I need previous Kubernetes experience?**
A: No! The tutorial teaches you from scratch.

**Q: Can I delete everything and start over?**
A: Yes! Run `minikube delete` then `minikube start`

**Q: Where are my logs?**
A: In `~/.minikube_tutorial/logs/` - view with Option 8 in tutorial.

**Q: How much disk space do I need?**
A: At least 20GB, 30GB recommended for comfortable use.

---

## 🆘 Need Help?

1. **During Tutorial:** Press the key for your question (usually shows help)
2. **Check Logs:** Run tutorial → Option 8 → View Logs
3. **System Check:** Run `./scripts/check-system.sh`
4. **Read Documentation:** See [README.md](README.md)
5. **Common Commands:** Run `./scripts/common-commands.sh troubleshooting`

---

## 🎉 You're All Set!

You're ready to start learning Minikube!

```bash
# Start the journey
python3 minikube_tutorial.py
```

**Happy learning! 🚀**

---

**Next:** Run the tutorial and start with Option 1 (Introduction)
