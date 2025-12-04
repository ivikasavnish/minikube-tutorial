#!/bin/bash

###############################################################################
# Common Minikube Commands Quick Reference
# A handy reference for frequently used Minikube and Kubernetes commands
# Version: 1.0.0
###############################################################################

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  📖 Minikube Common Commands Reference                        ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${BLUE}━━━ $1 ━━━${NC}"
}

show_all_commands() {
    print_header

    print_section "Minikube Cluster Management"
    cat << 'EOF'
minikube start                    # Start the cluster
minikube start --driver=kvm2      # Start with KVM driver (Linux)
minikube stop                     # Stop the cluster
minikube delete                   # Delete the cluster
minikube restart                  # Restart the cluster
minikube status                   # Show cluster status
minikube version                  # Show Minikube version
EOF

    print_section "Minikube Configuration"
    cat << 'EOF'
minikube config view              # View current configuration
minikube config set memory 8192   # Set memory allocation
minikube config set cpus 4        # Set CPU allocation
minikube logs                     # View Minikube logs
minikube ssh                      # SSH into Minikube VM
EOF

    print_section "Minikube Dashboard & UI"
    cat << 'EOF'
minikube dashboard                # Open Kubernetes dashboard
minikube service <service-name>   # Open service in browser
minikube service list             # List all services
minikube tunnel                   # Create tunnel for LoadBalancer
EOF

    print_section "Cluster Information"
    cat << 'EOF'
kubectl cluster-info              # Show cluster information
kubectl get nodes                 # List all nodes
kubectl describe node minikube    # Describe node details
kubectl get componentstatuses     # Show component status
EOF

    print_section "Deployments"
    cat << 'EOF'
kubectl apply -f deployment.yaml  # Deploy application
kubectl create deployment <name> --image=<image>  # Create deployment
kubectl get deployments           # List all deployments
kubectl get deployments -A        # List in all namespaces
kubectl describe deployment <name> # Show deployment details
kubectl edit deployment <name>    # Edit deployment
kubectl rollout status deployment/<name>  # Check rollout status
kubectl set image deployment/<name> <container>=<image>  # Update image
EOF

    print_section "Pods"
    cat << 'EOF'
kubectl get pods                  # List pods in default namespace
kubectl get pods -A               # List all pods
kubectl get pods -o wide          # Show pods with more details
kubectl describe pod <pod-name>   # Show pod details
kubectl logs <pod-name>           # Show pod logs
kubectl logs -f <pod-name>        # Stream pod logs
kubectl logs --previous <pod-name> # Show previous container logs
kubectl exec -it <pod-name> -- /bin/bash  # Execute command in pod
EOF

    print_section "Services"
    cat << 'EOF'
kubectl get services              # List services
kubectl get services -A           # List services in all namespaces
kubectl expose deployment <name> --type=LoadBalancer --port=80:8080
                                  # Expose deployment as service
kubectl port-forward service/<name> 8080:80  # Port forward
kubectl describe service <name>   # Show service details
kubectl delete service <name>     # Delete service
EOF

    print_section "ConfigMaps & Secrets"
    cat << 'EOF'
kubectl create configmap <name> --from-literal=key=value
                                  # Create ConfigMap
kubectl get configmaps            # List ConfigMaps
kubectl create secret generic <name> --from-literal=key=value
                                  # Create Secret
kubectl get secrets               # List Secrets
EOF

    print_section "Namespaces"
    cat << 'EOF'
kubectl get namespaces            # List namespaces
kubectl create namespace <name>   # Create namespace
kubectl config set-context --current --namespace=<namespace>
                                  # Set default namespace
kubectl delete namespace <name>   # Delete namespace
EOF

    print_section "Persistence"
    cat << 'EOF'
kubectl get pvc                   # List persistent volume claims
kubectl get pv                    # List persistent volumes
kubectl describe pvc <name>       # Show PVC details
kubectl delete pvc <name>         # Delete PVC
EOF

    print_section "Resource Management"
    cat << 'EOF'
kubectl top nodes                 # Show node resource usage
kubectl top pods                  # Show pod resource usage
kubectl describe node minikube    # Show node capacity
kubectl get resourcequotas -A     # List resource quotas
EOF

    print_section "Debugging & Troubleshooting"
    cat << 'EOF'
kubectl get events -A             # Show cluster events
kubectl get events -w             # Watch cluster events
kubectl describe node minikube    # Describe node
kubectl debug pod <pod-name>      # Debug a pod
kubectl logs -p <pod-name>        # Show logs from crashed container
kubectl explain <resource>        # Get resource documentation
EOF

    print_section "YAML & Manifests"
    cat << 'EOF'
kubectl apply -f <file.yaml>      # Apply YAML manifest
kubectl delete -f <file.yaml>     # Delete resources from YAML
kubectl diff -f <file.yaml>       # Show differences
kubectl explain deployment.spec   # Explain resource fields
kubectl get deployment -o yaml    # Export resource as YAML
EOF

    print_section "Scaling & Updates"
    cat << 'EOF'
kubectl scale deployment <name> --replicas=5  # Scale replicas
kubectl set image deployment/<name> <container>=<image>  # Update image
kubectl rollout history deployment/<name>  # Show rollout history
kubectl rollout undo deployment/<name>     # Rollback to previous
kubectl set resources deployment/<name> --limits=cpu=200m,memory=512Mi
EOF

    print_section "Labels & Selectors"
    cat << 'EOF'
kubectl label pod <pod-name> key=value  # Add label to pod
kubectl get pods -l app=nginx           # Get pods with label
kubectl get pods -L tier                # Show label column
EOF

    print_section "Useful One-Liners"
    cat << 'EOF'
# Watch pod deployment progress
kubectl get pods -w

# Forward multiple ports
kubectl port-forward pod/my-pod 8080:8080 9090:9090

# Get resource usage
kubectl top pods --all-namespaces --sort-by=memory

# Find pods by node
kubectl get pods --all-namespaces --field-selector spec.nodeName=minikube

# Stream logs from all pods
kubectl logs -f -l app=myapp

# Execute command in all pods
kubectl exec -it <pod> -- <command>

# Show YAML differences
kubectl diff -f manifest.yaml

# Tail logs with timestamp
kubectl logs -f <pod> --timestamps=true

# Monitor events
watch kubectl get events --sort-by=.metadata.creationTimestamp
EOF

    print_section "Environment Variables"
    cat << 'EOF'
# Set default namespace
export KUBECONFIG=~/.kube/config

# Use specific context
kubectl config use-context minikube

# Show current context
kubectl config current-context
EOF
}

show_troubleshooting() {
    print_header
    echo -e "${YELLOW}Troubleshooting Guide${NC}\n"

    cat << 'EOF'
Problem: Minikube won't start
Solution:
  1. Check if virtualization is enabled in BIOS
  2. Try different driver: minikube start --driver=docker
  3. Check logs: minikube logs
  4. Delete and restart: minikube delete && minikube start

Problem: kubectl can't connect to cluster
Solution:
  1. Check minikube status: minikube status
  2. Reset kubeconfig: rm ~/.kube/config && minikube start
  3. Check context: kubectl config current-context

Problem: Pod stuck in Pending state
Solution:
  1. Check pod events: kubectl describe pod <name>
  2. Check resource availability: kubectl top nodes
  3. Check resource requests in deployment YAML
  4. Try scaling down other deployments

Problem: Out of disk space
Solution:
  1. Delete unused images: docker image prune
  2. Delete minikube: minikube delete
  3. Clean up volumes: docker volume prune
  4. Start fresh: minikube start

Problem: High CPU/Memory usage
Solution:
  1. Check resource usage: kubectl top pods -A
  2. Scale down replicas: kubectl scale deployment <name> --replicas=1
  3. Increase minikube resources: minikube config set memory 8192
  4. Check for resource leaks: kubectl logs <pod>

Problem: Service not accessible
Solution:
  1. Check service: kubectl get services
  2. Check endpoints: kubectl get endpoints
  3. Port forward: kubectl port-forward svc/<name> 8080:80
  4. Check pod logs: kubectl logs -l app=<name>

Problem: Image pull error
Solution:
  1. Build image locally: eval $(minikube docker-env) && docker build .
  2. Use local image: imagePullPolicy: Never
  3. Check image name and registry
  4. Use public registry: docker.io/image:tag
EOF
}

show_tips() {
    print_header
    echo -e "${GREEN}Tips & Best Practices${NC}\n"

    cat << 'EOF'
1. Always set resource requests and limits in deployments
   - Helps Minikube schedule pods efficiently
   - Prevents node from running out of resources

2. Use namespaces to organize applications
   - Easier management of multiple apps
   - Better resource isolation

3. Store sensitive data in Secrets, not ConfigMaps
   - Use kubectl create secret for passwords/tokens
   - Keep secrets encrypted at rest

4. Use health probes (livenessProbe, readinessProbe)
   - Ensures Kubernetes restarts unhealthy pods
   - Prevents traffic to unready pods

5. Use labels for pod selection
   - Easier to manage and organize pods
   - Required for services and deployments

6. Set appropriate resource requests
   - Helps Kubernetes scheduler
   - Prevents oversubscription

7. Use persistent volumes for stateful data
   - Survives pod restarts
   - Data persists across deployments

8. Monitor cluster with top and events
   - kubectl top nodes/pods
   - kubectl get events -w

9. Use readiness and liveness probes
   - Ensures service doesn't send traffic to unready pods
   - Automatically restarts crashed containers

10. Always use image tags (not 'latest' in production)
    - Ensures reproducible deployments
    - Better version control
EOF
}

show_examples() {
    print_header
    echo -e "${BLUE}Practical Examples${NC}\n"

    print_section "Example 1: Deploy Nginx"
    cat << 'EOF'
kubectl create deployment nginx --image=nginx:latest
kubectl expose deployment nginx --type=LoadBalancer --port=80
kubectl port-forward svc/nginx 8080:80
# Visit: http://localhost:8080
EOF

    print_section "Example 2: Deploy with YAML"
    cat << 'EOF'
cat > deployment.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
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
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
YAML

kubectl apply -f deployment.yaml
EOF

    print_section "Example 3: Scale and Update"
    cat << 'EOF'
kubectl scale deployment myapp --replicas=5
kubectl set image deployment/myapp myapp=nginx:1.21
kubectl rollout status deployment/myapp
EOF

    print_section "Example 4: Debug Pod"
    cat << 'EOF'
# Get pod name
POD=$(kubectl get pods -l app=myapp -o jsonpath='{.items[0].metadata.name}')

# View logs
kubectl logs $POD

# Execute command
kubectl exec -it $POD -- sh

# Describe pod
kubectl describe pod $POD
EOF
}

# Menu
show_menu() {
    clear
    echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  📖 Minikube Command Reference Menu  ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
    echo
    echo "1. Show all commands"
    echo "2. Troubleshooting guide"
    echo "3. Tips & best practices"
    echo "4. Practical examples"
    echo "5. Exit"
    echo
    read -p "Select option: " choice

    case $choice in
        1) show_all_commands | less ;;
        2) show_troubleshooting | less ;;
        3) show_tips | less ;;
        4) show_examples | less ;;
        5) exit 0 ;;
        *) echo "Invalid option" ;;
    esac

    show_menu
}

# Run menu if no arguments, otherwise show all commands
if [ $# -eq 0 ]; then
    show_menu
else
    case $1 in
        all) show_all_commands ;;
        troubleshooting) show_troubleshooting ;;
        tips) show_tips ;;
        examples) show_examples ;;
        *) show_all_commands ;;
    esac
fi
