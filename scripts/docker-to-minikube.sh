#!/bin/bash

###############################################################################
# Docker/Docker-Compose to Minikube Deployment Tool
# Automatically detect Docker files and convert to Kubernetes manifests
# Uses Kompose to convert docker-compose to Kubernetes YAML
# Version: 1.0.0
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Configuration
WORK_DIR="${PWD}"
DOCKER_FILE_FOUND=""
COMPOSE_FILE_FOUND=""
KOMPOSE_INSTALLED=0

# Print functions
print_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║  🐳 Docker/Docker-Compose to Minikube Deployment Tool             ║"
    echo "║     Automatically deploy Docker apps to Kubernetes                ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

print_question() {
    echo -e "${MAGENTA}?${NC} $1"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macOS" ;;
        Linux*)     echo "Linux" ;;
        *)          echo "Unknown" ;;
    esac
}

# Check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Find Docker files in current directory and subdirectories
find_docker_files() {
    print_section "Step 1: Scanning for Docker Files"

    print_info "Scanning $WORK_DIR for Docker files...\n"

    # Find Dockerfile
    if find "$WORK_DIR" -maxdepth 3 -name "Dockerfile" 2>/dev/null | grep -q .; then
        DOCKER_FILE_FOUND=$(find "$WORK_DIR" -maxdepth 3 -name "Dockerfile" 2>/dev/null | head -1)
        print_success "Found Dockerfile: $DOCKER_FILE_FOUND"
    fi

    # Find docker-compose files
    if find "$WORK_DIR" -maxdepth 3 \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) 2>/dev/null | grep -q .; then
        COMPOSE_FILE_FOUND=$(find "$WORK_DIR" -maxdepth 3 \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) 2>/dev/null | head -1)
        print_success "Found Docker Compose: $COMPOSE_FILE_FOUND"
    fi

    echo

    if [ -z "$DOCKER_FILE_FOUND" ] && [ -z "$COMPOSE_FILE_FOUND" ]; then
        print_warning "No Dockerfile or docker-compose.yml found in current directory"
        print_info "Please navigate to your Docker project directory or specify files manually"
        return 1
    fi
}

# Check if Kompose is installed
check_kompose() {
    print_section "Step 2: Check Kompose Installation"

    if command_exists kompose; then
        print_success "Kompose is installed"
        echo "Version: $(kompose version)"
        KOMPOSE_INSTALLED=1
        echo
        return 0
    else
        print_warning "Kompose is not installed\n"
        print_info "Kompose is required to convert Docker Compose to Kubernetes YAML\n"

        if prompt_yn "Would you like to install Kompose?" "y"; then
            install_kompose
        else
            print_warning "Kompose installation skipped"
            print_info "You can install it later from: https://kompose.io/"
            return 1
        fi
    fi
}

# Install Kompose
install_kompose() {
    print_info "Installing Kompose...\n"

    local os=$(detect_os)
    local install_dir="/usr/local/bin"

    case "$os" in
        macOS)
            if command_exists brew; then
                brew install kompose
                print_success "Kompose installed via Homebrew"
            else
                curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-darwin-amd64 -o kompose
                chmod +x kompose
                sudo mv kompose "$install_dir/kompose"
                print_success "Kompose installed"
            fi
            ;;
        Linux)
            curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-linux-amd64 -o kompose
            chmod +x kompose
            sudo mv kompose "$install_dir/kompose"
            print_success "Kompose installed"
            ;;
        *)
            print_error "Unsupported OS"
            return 1
            ;;
    esac

    echo
}

# Build Docker image
build_docker_image() {
    print_section "Step 3: Build Docker Image"

    if [ -z "$DOCKER_FILE_FOUND" ]; then
        print_info "No Dockerfile found. Skipping image build.\n"
        return 0
    fi

    local dockerfile_dir=$(dirname "$DOCKER_FILE_FOUND")
    local app_name=$(basename "$dockerfile_dir")

    print_info "Found Dockerfile at: $DOCKER_FILE_FOUND"
    print_info "Application name: $app_name\n"

    read -p "Enter Docker image name (default: $app_name): " image_name
    image_name=${image_name:-$app_name}

    read -p "Enter image tag (default: latest): " image_tag
    image_tag=${image_tag:-latest}

    echo

    # Set up Docker environment to use Minikube's Docker daemon
    print_info "Configuring Docker to use Minikube...\n"

    if command_exists minikube; then
        eval $(minikube docker-env)
        print_success "Minikube Docker environment loaded"
    fi

    echo
    print_info "Building Docker image: $image_name:$image_tag\n"

    if docker build -t "$image_name:$image_tag" "$dockerfile_dir"; then
        print_success "Docker image built successfully: $image_name:$image_tag"
    else
        print_error "Failed to build Docker image"
        return 1
    fi

    echo
}

# Convert Docker Compose to Kubernetes
convert_compose_to_k8s() {
    print_section "Step 4: Convert Docker Compose to Kubernetes"

    if [ -z "$COMPOSE_FILE_FOUND" ]; then
        print_info "No docker-compose.yml found. Skipping conversion.\n"
        return 0
    fi

    if [ $KOMPOSE_INSTALLED -eq 0 ]; then
        print_warning "Kompose not installed. Cannot convert docker-compose.yml"
        return 1
    fi

    local compose_dir=$(dirname "$COMPOSE_FILE_FOUND")
    local compose_name=$(basename "$compose_dir")
    local output_dir="${compose_dir}/kubernetes"

    print_info "Found docker-compose.yml at: $COMPOSE_FILE_FOUND"
    print_info "Output directory: $output_dir\n"

    mkdir -p "$output_dir"

    print_info "Converting docker-compose.yml to Kubernetes manifests...\n"

    if cd "$compose_dir" && kompose convert -o "$output_dir"; then
        print_success "Docker Compose converted to Kubernetes YAML"
        print_info "Generated files in: $output_dir\n"
        ls -lah "$output_dir"
    else
        print_error "Failed to convert docker-compose.yml"
        return 1
    fi

    echo
}

# Generate Kubernetes manifests
generate_k8s_manifests() {
    print_section "Step 5: Generate Kubernetes Manifests"

    local output_dir="${WORK_DIR}/kubernetes-generated"
    mkdir -p "$output_dir"

    print_info "Generating Kubernetes manifests...\n"

    if [ -n "$COMPOSE_FILE_FOUND" ]; then
        print_success "Using converted Docker Compose manifests"
    else
        print_info "Creating basic Kubernetes deployment...\n"

        read -p "Enter application name: " app_name
        read -p "Enter Docker image (format: image:tag): " docker_image
        read -p "Enter number of replicas (default: 1): " replicas
        replicas=${replicas:-1}

        cat > "$output_dir/deployment.yaml" << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $app_name
spec:
  replicas: $replicas
  selector:
    matchLabels:
      app: $app_name
  template:
    metadata:
      labels:
        app: $app_name
    spec:
      containers:
      - name: $app_name
        image: $docker_image
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: $app_name
spec:
  selector:
    app: $app_name
  ports:
  - port: 80
    targetPort: 8080
  type: LoadBalancer
EOF

        print_success "Generated basic deployment manifest"
    fi

    print_info "Manifests ready in: $output_dir"
    echo
}

# Deploy to Minikube
deploy_to_minikube() {
    print_section "Step 6: Deploy to Minikube"

    if ! command_exists kubectl; then
        print_error "kubectl not found. Please install kubectl first."
        return 1
    fi

    if ! minikube status >/dev/null 2>&1; then
        print_warning "Minikube cluster not running\n"

        if prompt_yn "Start Minikube cluster?" "y"; then
            minikube start --driver=docker
        else
            print_error "Cannot deploy without running Minikube cluster"
            return 1
        fi
    fi

    print_success "Minikube cluster is running\n"

    # Find YAML files to deploy
    local yaml_files=()

    if [ -n "$COMPOSE_FILE_FOUND" ]; then
        local compose_dir=$(dirname "$COMPOSE_FILE_FOUND")
        yaml_files=($(find "${compose_dir}/kubernetes" -name "*.yaml" 2>/dev/null))
    fi

    if [ -n "$DOCKER_FILE_FOUND" ]; then
        yaml_files+=($(find "${WORK_DIR}/kubernetes-generated" -name "*.yaml" 2>/dev/null))
    fi

    if [ ${#yaml_files[@]} -eq 0 ]; then
        print_warning "No YAML files found to deploy"
        return 1
    fi

    print_info "Found ${#yaml_files[@]} YAML file(s) to deploy:\n"
    for file in "${yaml_files[@]}"; do
        echo "  - $file"
    done
    echo

    if prompt_yn "Deploy these files to Minikube?" "y"; then
        for file in "${yaml_files[@]}"; do
            print_info "Deploying: $file"
            kubectl apply -f "$file"
        done

        print_success "Deployment complete!\n"

        print_info "Checking deployment status...\n"
        kubectl get deployments
        kubectl get services
        kubectl get pods

        echo
        print_success "Your application is deployed to Minikube!"
    fi

    echo
}

# Show access instructions
show_access_instructions() {
    print_section "Step 7: Access Your Application"

    print_info "How to access your deployed application:\n"

    echo "Option 1: Port Forward"
    echo "  $ kubectl port-forward svc/<service-name> 8080:80"
    echo "  Then visit: http://localhost:8080"
    echo

    echo "Option 2: Minikube Service"
    echo "  $ minikube service <service-name>"
    echo

    echo "Option 3: Get Service Info"
    echo "  $ kubectl get services"
    echo "  $ kubectl describe service <service-name>"
    echo

    print_info "Useful commands:\n"
    echo "  kubectl logs -f deployment/<app-name>     # View logs"
    echo "  kubectl scale deployment/<app> --replicas=3  # Scale app"
    echo "  kubectl describe pod <pod-name>           # Show pod details"
    echo "  kubectl delete deployment <app-name>      # Delete deployment"
    echo

    if prompt_yn "View application logs now?" "y"; then
        local first_pod=$(kubectl get pods -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
        if [ -n "$first_pod" ]; then
            kubectl logs -f "$first_pod"
        fi
    fi
}

# Cleanup deployment
cleanup_deployment() {
    print_section "Cleanup"

    print_question "Delete deployment from Minikube?" "n"

    if prompt_yn "" "n"; then
        kubectl get deployments -o name | while read deployment; do
            kubectl delete "$deployment"
        done
        print_success "Deployment deleted"
    fi

    echo
}

# Main menu
show_menu() {
    while true; do
        print_header

        echo "Choose an option:"
        echo
        echo "1. 🔍 Find Docker Files (scan current directory)"
        echo "2. 🐳 Build Docker Image"
        echo "3. 🔄 Convert Docker Compose to Kubernetes"
        echo "4. 📦 Generate Kubernetes Manifests"
        echo "5. ✅ Verify Minikube Status"
        echo "6. 🚀 Deploy to Minikube"
        echo "7. 📋 Show Access Instructions"
        echo "8. 🧠 Full Deployment (all steps)"
        echo "9. 🧹 Cleanup Deployment"
        echo "0. 🚪 Exit"
        echo

        read -p "Select option (0-9): " choice

        case $choice in
            1) find_docker_files ;;
            2) build_docker_image ;;
            3) check_kompose && convert_compose_to_k8s ;;
            4) generate_k8s_manifests ;;
            5) check_minikube_status ;;
            6) deploy_to_minikube ;;
            7) show_access_instructions ;;
            8) full_deployment ;;
            9) cleanup_deployment ;;
            0)
                print_info "Thank you for using Docker to Minikube tool!"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                sleep 2
                ;;
        esac

        echo
        read -p "Press Enter to continue..."
    done
}

# Check Minikube status
check_minikube_status() {
    print_section "Minikube Status"

    if command_exists minikube; then
        minikube status
        echo
        kubectl cluster-info
    else
        print_error "Minikube not found"
    fi

    echo
}

# Full deployment workflow
full_deployment() {
    print_header

    echo -e "${GREEN}Starting Full Deployment Workflow...${NC}\n"

    find_docker_files || return 1
    sleep 1

    check_kompose || {
        print_warning "Kompose required for Docker Compose conversion"
    }
    sleep 1

    if [ -n "$DOCKER_FILE_FOUND" ]; then
        if prompt_yn "Build Docker image?" "y"; then
            build_docker_image || return 1
        fi
    fi
    sleep 1

    if [ -n "$COMPOSE_FILE_FOUND" ]; then
        convert_compose_to_k8s || return 1
    fi
    sleep 1

    generate_k8s_manifests || return 1
    sleep 1

    if prompt_yn "Deploy to Minikube now?" "y"; then
        deploy_to_minikube || return 1
    fi
    sleep 1

    show_access_instructions
}

# Prompt for yes/no
prompt_yn() {
    local prompt="$1"
    local default="${2:-y}"

    if [[ "$default" == "y" ]]; then
        prompt_text="(Y/n)"
    else
        prompt_text="(y/N)"
    fi

    read -p "$(echo -e ${MAGENTA}?)$(echo -e ${NC}) $prompt $prompt_text: " -n 1 -r
    echo

    if [[ -z "$REPLY" ]]; then
        [[ "$default" == "y" ]] && return 0 || return 1
    fi

    [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
}

# Main execution
main() {
    if [ "$1" == "auto" ]; then
        # Automatic mode
        find_docker_files || exit 1
        check_kompose || exit 1
        [ -n "$DOCKER_FILE_FOUND" ] && build_docker_image || true
        [ -n "$COMPOSE_FILE_FOUND" ] && convert_compose_to_k8s || true
        generate_k8s_manifests || exit 1
        deploy_to_minikube || exit 1
        show_access_instructions
    else
        # Interactive menu
        show_menu
    fi
}

main "$@"
