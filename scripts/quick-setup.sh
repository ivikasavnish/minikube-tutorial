#!/bin/bash

###############################################################################
# Minikube Quick Setup Script
# Automatically installs and configures Minikube for your system
# Version: 1.0.0
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macOS" ;;
        Linux*)     echo "Linux" ;;
        MINGW*)     echo "Windows" ;;
        *)          echo "UNKNOWN" ;;
    esac
}

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker
install_docker() {
    print_header "Installing Docker"

    OS=$(detect_os)

    case "$OS" in
        macOS)
            print_info "Installing Docker Desktop for macOS..."
            print_info "Download from: https://www.docker.com/products/docker-desktop"
            print_warning "Please install Docker Desktop manually and rerun this script"
            ;;
        Linux)
            print_info "Installing Docker for Linux..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker "$USER"
            print_success "Docker installed"
            print_warning "Please logout and login again for group permissions to take effect"
            ;;
        *)
            print_error "Unsupported OS for automatic Docker installation"
            ;;
    esac
}

# Install Minikube
install_minikube() {
    print_header "Installing Minikube"

    OS=$(detect_os)

    case "$OS" in
        macOS)
            if command_exists brew; then
                print_info "Using Homebrew to install Minikube..."
                brew install minikube
            else
                print_info "Downloading Minikube directly..."
                curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
                sudo install minikube-darwin-amd64 /usr/local/bin/minikube
                rm minikube-darwin-amd64
            fi
            ;;
        Linux)
            print_info "Downloading Minikube for Linux..."
            curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
            sudo install minikube-linux-amd64 /usr/local/bin/minikube
            rm minikube-linux-amd64
            ;;
        *)
            print_error "Unsupported OS"
            exit 1
            ;;
    esac

    print_success "Minikube installed"
    minikube version
}

# Install kubectl
install_kubectl() {
    print_header "Installing kubectl"

    OS=$(detect_os)

    case "$OS" in
        macOS)
            if command_exists brew; then
                brew install kubectl
            else
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
                sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                rm kubectl
            fi
            ;;
        Linux)
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
            ;;
        *)
            print_error "Unsupported OS"
            exit 1
            ;;
    esac

    print_success "kubectl installed"
    kubectl version --client --short
}

# Install KVM (Linux only)
install_kvm() {
    OS=$(detect_os)

    if [ "$OS" != "Linux" ]; then
        print_warning "KVM installation is only available on Linux"
        return
    fi

    print_header "Installing KVM and QEMU"

    # Check for virtualization support
    print_info "Checking for virtualization support..."

    if grep -q vmx /proc/cpuinfo; then
        print_success "Intel virtualization detected"
    elif grep -q svm /proc/cpuinfo; then
        print_success "AMD virtualization detected"
    else
        print_error "Virtualization not supported on this CPU"
        return
    fi

    # Install packages
    print_info "Installing KVM packages..."
    sudo apt-get update
    sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager

    # Configure user permissions
    print_info "Configuring user permissions..."
    sudo usermod -a -G libvirt "$USER"

    print_success "KVM installed"
    print_warning "Please logout and login again for group permissions to take effect"
}

# Start Minikube
start_minikube() {
    print_header "Starting Minikube"

    OS=$(detect_os)
    DRIVER="docker"

    if [ "$OS" = "Linux" ]; then
        read -p "Use KVM driver? (recommended for Linux) (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            DRIVER="kvm2"
            print_info "Using KVM2 driver with 4 CPUs and 8GB RAM"
            minikube start --driver="$DRIVER" --cpus=4 --memory=8192
        else
            print_info "Using Docker driver"
            minikube start --driver=docker
        fi
    else
        print_info "Starting Minikube with Docker driver..."
        minikube start --driver=docker
    fi

    print_success "Minikube started"
}

# Check installation
check_installation() {
    print_header "Verifying Installation"

    local all_ok=true

    if command_exists docker; then
        docker_version=$(docker --version)
        print_success "Docker: $docker_version"
    else
        print_error "Docker not found"
        all_ok=false
    fi

    if command_exists minikube; then
        minikube_version=$(minikube version)
        print_success "Minikube: $minikube_version"
    else
        print_error "Minikube not found"
        all_ok=false
    fi

    if command_exists kubectl; then
        kubectl_version=$(kubectl version --client --short 2>/dev/null)
        print_success "kubectl: $kubectl_version"
    else
        print_error "kubectl not found"
        all_ok=false
    fi

    if $all_ok; then
        print_success "All components installed successfully!"
        return 0
    else
        print_error "Some components are missing"
        return 1
    fi
}

# Main menu
main_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🚀 Minikube Quick Setup Script v1.0  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo
    echo "1. Check requirements"
    echo "2. Install Docker"
    echo "3. Install Minikube"
    echo "4. Install kubectl"
    echo "5. Install KVM (Linux only)"
    echo "6. Full automated setup"
    echo "7. Start Minikube"
    echo "8. Verify installation"
    echo "0. Exit"
    echo
    read -p "Select option (0-8): " choice

    case $choice in
        1) check_requirements ;;
        2) install_docker ;;
        3) install_minikube ;;
        4) install_kubectl ;;
        5) install_kvm ;;
        6) full_setup ;;
        7) start_minikube ;;
        8) check_installation ;;
        0) print_success "Goodbye!"; exit 0 ;;
        *) print_error "Invalid option" ;;
    esac

    echo
    read -p "Press Enter to continue..."
    main_menu
}

# Check requirements
check_requirements() {
    print_header "Checking System Requirements"

    OS=$(detect_os)
    print_info "Operating System: $OS"

    print_info "Checking virtualization support..."
    if [ "$OS" = "Linux" ]; then
        if grep -q vmx /proc/cpuinfo || grep -q svm /proc/cpuinfo; then
            print_success "CPU virtualization enabled"
        else
            print_warning "CPU virtualization not detected"
        fi
    fi

    print_info "Checking RAM..."
    if [ "$OS" = "Darwin" ]; then
        RAM=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
    elif [ "$OS" = "Linux" ]; then
        RAM=$(free -g | awk '/^Mem:/{print $2}')
    fi

    if [ "$RAM" -ge 8 ]; then
        print_success "RAM: ${RAM}GB (sufficient)"
    elif [ "$RAM" -ge 4 ]; then
        print_warning "RAM: ${RAM}GB (minimum, 8GB recommended)"
    else
        print_error "RAM: ${RAM}GB (insufficient - need 4GB minimum)"
    fi
}

# Full automated setup
full_setup() {
    print_header "Starting Full Automated Setup"

    print_info "This will install Docker, Minikube, and kubectl"
    read -p "Continue? (y/n): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Setup cancelled"
        return
    fi

    # Install components
    if ! command_exists docker; then
        install_docker
    else
        print_success "Docker already installed"
    fi

    if ! command_exists minikube; then
        install_minikube
    else
        print_success "Minikube already installed"
    fi

    if ! command_exists kubectl; then
        install_kubectl
    else
        print_success "kubectl already installed"
    fi

    # Ask about KVM
    OS=$(detect_os)
    if [ "$OS" = "Linux" ]; then
        read -p "Install KVM? (recommended for Linux) (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_kvm
        fi
    fi

    # Check installation
    if check_installation; then
        read -p "Start Minikube now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            start_minikube
        fi
    fi
}

# Run main menu
main_menu
