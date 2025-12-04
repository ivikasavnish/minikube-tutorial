#!/bin/bash

###############################################################################
# Interactive Minikube Installation Guide
# Step-by-step guided installation for all architectures
# Supports: macOS (Intel/ARM64), Ubuntu, Debian, Fedora, RHEL, Windows (WSL2)
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

# Global variables
DETECTED_OS=""
DETECTED_ARCH=""
STEP_COUNT=0
INSTALLATION_LOG=""

# Setup logging
INSTALL_DIR="${HOME}/.minikube_tutorial"
mkdir -p "$INSTALL_DIR/logs"
INSTALLATION_LOG="${INSTALL_DIR}/logs/installation_$(date +%Y%m%d_%H%M%S).log"

# Logging function
log_action() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$INSTALLATION_LOG"
}

# Print functions
print_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║        🚀 INTERACTIVE MINIKUBE INSTALLATION GUIDE                 ║"
    echo "║           Step-by-step guidance for your system                   ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_welcome() {
    echo -e "${GREEN}Welcome to the Minikube Installation Guide!${NC}\n"
    echo "This interactive script will guide you through installing Minikube,"
    echo "Docker, and kubectl on your system step by step.\n"
    echo "Let's get started! 🎉\n"
}

print_step() {
    ((STEP_COUNT++))
    echo -e "\n${BOLD}${CYAN}══════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}📍 STEP $STEP_COUNT: $1${NC}"
    echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════${NC}\n"
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
    echo -e "${BOLD}${MAGENTA}?${NC} $1"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    DETECTED_OS="macOS" ;;
        Linux*)     DETECTED_OS="Linux" ;;
        MINGW*)     DETECTED_OS="Windows" ;;
        *)          DETECTED_OS="Unknown" ;;
    esac
}

# Detect architecture
detect_architecture() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)   DETECTED_ARCH="x86_64" ;;
        aarch64|arm64)  DETECTED_ARCH="arm64" ;;
        armv7l)         DETECTED_ARCH="armv7" ;;
        *)              DETECTED_ARCH="$arch" ;;
    esac
}

# Check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Prompt user for yes/no
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

# Installation tracker
add_to_installed() {
    echo "$1" >> "$INSTALL_DIR/installed.txt"
}

is_installed() {
    if grep -q "^$1$" "$INSTALL_DIR/installed.txt" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# System information display
show_system_info() {
    print_step "System Information Detection"

    print_info "Analyzing your system...\n"

    detect_os
    detect_architecture

    echo "Operating System: $DETECTED_OS"

    if [[ "$DETECTED_OS" == "Linux" ]] && [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "Distribution: $PRETTY_NAME"
    elif [[ "$DETECTED_OS" == "macOS" ]]; then
        local version=$(sw_vers -productVersion)
        echo "macOS Version: $version"
    fi

    echo "Architecture: $DETECTED_ARCH"

    if [[ "$DETECTED_ARCH" == "arm64" ]]; then
        print_success "Apple Silicon detected - optimized setup available"
    fi

    # CPU and Memory
    if [[ "$DETECTED_OS" == "macOS" ]]; then
        local cpu_count=$(sysctl -n hw.ncpu)
        local memory_gb=$(sysctl -n hw.memsize | awk '{printf "%.0f", $1/1024/1024/1024}')
    elif [[ "$DETECTED_OS" == "Linux" ]]; then
        local cpu_count=$(nproc)
        local memory_gb=$(free -g | awk '/^Mem:/{print $2}')
    fi

    echo "CPU Cores: $cpu_count"
    echo "Memory: ${memory_gb}GB"

    log_action "System detected: $DETECTED_OS ($DETECTED_ARCH)"

    echo
    prompt_yn "Is this information correct?" "y" || {
        print_warning "Please verify your system manually"
        return 1
    }
}

# Docker installation guide
install_docker() {
    print_step "Docker Installation"

    if command_exists docker; then
        print_success "Docker is already installed"
        docker --version
        log_action "Docker already installed"
        return 0
    fi

    print_info "Docker is required for Minikube. Follow the instructions below.\n"

    case "$DETECTED_OS" in
        macOS)
            echo -e "${YELLOW}Manual Installation Required${NC}\n"
            echo "1. Visit: https://www.docker.com/products/docker-desktop"
            echo "2. Download Docker Desktop for $(uname -m)"
            echo "3. Install and start Docker Desktop"
            echo "4. Wait for Docker to be running"
            echo
            print_question "Have you installed and started Docker Desktop?" "y"
            if prompt_yn "" "y"; then
                sleep 2
                if command_exists docker; then
                    print_success "Docker detected!"
                    docker --version
                    log_action "Docker installed manually on macOS"
                else
                    print_error "Docker not found. Please ensure it's installed."
                    return 1
                fi
            else
                print_warning "Docker installation skipped"
                return 1
            fi
            ;;
        Linux)
            echo -e "${CYAN}Automatic Installation Available${NC}\n"
            echo "This will:"
            echo "  • Download Docker installation script"
            echo "  • Install Docker"
            echo "  • Add you to docker group"
            echo

            if prompt_yn "Proceed with automatic Docker installation?" "y"; then
                print_info "Installing Docker..."
                curl -fsSL https://get.docker.com -o get-docker.sh
                sudo sh get-docker.sh
                sudo usermod -aG docker $USER

                print_success "Docker installed!"
                log_action "Docker auto-installed on Linux"

                print_warning "Please logout and login for group changes to take effect"
                print_warning "Or run: newgrp docker"
            else
                echo
                echo "Manual installation:"
                echo "  $ curl -fsSL https://get.docker.com | sh"
                echo "  $ sudo usermod -aG docker \$USER"
                log_action "Docker manual installation on Linux"
            fi
            ;;
        *)
            print_error "Unsupported OS for automatic Docker installation"
            return 1
            ;;
    esac
}

# Minikube installation guide
install_minikube() {
    print_step "Minikube Installation"

    if command_exists minikube; then
        print_success "Minikube is already installed"
        minikube version
        log_action "Minikube already installed"
        return 0
    fi

    print_info "Installing Minikube...\n"

    case "$DETECTED_OS" in
        macOS)
            if command_exists brew; then
                print_info "Using Homebrew for installation\n"
                if prompt_yn "Install Minikube via Homebrew?" "y"; then
                    brew install minikube
                    print_success "Minikube installed via Homebrew"
                    log_action "Minikube installed via Homebrew on macOS"
                fi
            else
                print_info "Downloading Minikube directly\n"
                curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
                sudo install minikube-darwin-amd64 /usr/local/bin/minikube
                rm minikube-darwin-amd64
                print_success "Minikube installed"
                log_action "Minikube downloaded and installed on macOS"
            fi
            ;;
        Linux)
            print_info "Downloading Minikube...\n"
            curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
            sudo install minikube-linux-amd64 /usr/local/bin/minikube
            rm minikube-linux-amd64
            print_success "Minikube installed"
            log_action "Minikube downloaded and installed on Linux"
            ;;
    esac

    minikube version
}

# Kubectl installation guide
install_kubectl() {
    print_step "kubectl Installation"

    if command_exists kubectl; then
        print_success "kubectl is already installed"
        kubectl version --client --short
        log_action "kubectl already installed"
        return 0
    fi

    print_info "Installing kubectl...\n"

    case "$DETECTED_OS" in
        macOS)
            if command_exists brew; then
                print_info "Using Homebrew for installation\n"
                if prompt_yn "Install kubectl via Homebrew?" "y"; then
                    brew install kubectl
                    print_success "kubectl installed via Homebrew"
                    log_action "kubectl installed via Homebrew on macOS"
                fi
            else
                print_info "Downloading kubectl...\n"
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
                sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                rm kubectl
                print_success "kubectl installed"
                log_action "kubectl downloaded and installed on macOS"
            fi
            ;;
        Linux)
            print_info "Downloading kubectl...\n"
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
            print_success "kubectl installed"
            log_action "kubectl downloaded and installed on Linux"
            ;;
    esac

    kubectl version --client --short
}

# KVM setup for Linux
setup_kvm() {
    print_step "KVM Driver Setup (Linux Optional)"

    if [[ "$DETECTED_OS" != "Linux" ]]; then
        print_info "KVM is only available on Linux. Skipping.\n"
        return 0
    fi

    print_info "KVM (Kernel Virtual Machine) provides better performance than Docker on Linux.\n"
    echo "Benefits:"
    echo "  • Faster than Docker driver"
    echo "  • Native Linux hypervisor"
    echo "  • Better resource efficiency"
    echo

    if prompt_yn "Setup KVM driver?" "y"; then
        print_info "Checking virtualization support...\n"

        if grep -q "vmx\|svm" /proc/cpuinfo 2>/dev/null; then
            print_success "Virtualization support detected\n"

            print_info "Installing KVM packages...\n"

            if command_exists apt-get; then
                sudo apt-get update
                sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager
            elif command_exists dnf; then
                sudo dnf install -y qemu-kvm libvirt virt-daemon-system virt-manager
            else
                print_warning "Cannot auto-install KVM packages. Manual installation needed."
                return 1
            fi

            print_info "Adding user to libvirt group...\n"
            sudo usermod -a -G libvirt $USER

            print_success "KVM setup complete!"
            print_warning "Please logout and login for group changes to take effect"
            log_action "KVM setup completed on Linux"
        else
            print_warning "Virtualization not detected. May be disabled in BIOS."
            print_info "Enable Intel VT-x or AMD-V in BIOS/UEFI settings"
            log_action "Virtualization not detected"
        fi
    else
        print_info "KVM setup skipped. Docker driver will be used.\n"
    fi
}

# Verify installation
verify_installation() {
    print_step "Verification"

    print_info "Checking installed tools...\n"

    local all_ok=true

    if command_exists docker; then
        print_success "Docker: $(docker --version)"
    else
        print_error "Docker not found"
        all_ok=false
    fi

    if command_exists minikube; then
        print_success "Minikube: $(minikube version)"
    else
        print_error "Minikube not found"
        all_ok=false
    fi

    if command_exists kubectl; then
        print_success "kubectl: $(kubectl version --client --short 2>/dev/null)"
    else
        print_error "kubectl not found"
        all_ok=false
    fi

    echo

    if $all_ok; then
        print_success "All tools installed successfully!\n"
        log_action "Verification passed - all tools installed"
        return 0
    else
        print_error "Some tools are missing\n"
        log_action "Verification failed - missing tools"
        return 1
    fi
}

# Deploy Minikube
deploy_minikube() {
    print_step "Deploy Minikube Cluster"

    print_info "Starting Minikube cluster...\n"

    if minikube status >/dev/null 2>&1; then
        local status=$(minikube status 2>/dev/null | grep "host:" || echo "unknown")
        print_warning "A Minikube cluster already exists: $status\n"

        if prompt_yn "Delete existing cluster and create new one?" "n"; then
            minikube delete
        else
            print_info "Skipping cluster creation"
            return 0
        fi
    fi

    echo "Configuration options:"
    echo "  1. Minimal (2 CPUs, 4GB RAM) - for learning"
    echo "  2. Standard (4 CPUs, 8GB RAM) - recommended"
    echo "  3. High Performance (8 CPUs, 16GB RAM) - for production testing"
    echo "  4. Custom"
    echo

    read -p "Select configuration (1-4): " config_choice

    local cpus=4
    local memory=8192

    case $config_choice in
        1)
            cpus=2
            memory=4096
            print_info "Minimal configuration selected\n"
            ;;
        2)
            print_info "Standard configuration selected\n"
            ;;
        3)
            cpus=8
            memory=16384
            print_info "High Performance configuration selected\n"
            ;;
        4)
            read -p "Enter CPU cores: " cpus
            read -p "Enter memory (MB): " memory
            ;;
        *)
            print_warning "Invalid selection. Using standard."
            ;;
    esac

    print_info "Starting cluster with $cpus CPUs and ${memory}MB memory...\n"
    log_action "Starting Minikube: CPUs=$cpus, Memory=$memory"

    if minikube start --driver=docker --cpus=$cpus --memory=$memory; then
        print_success "Minikube cluster started successfully!\n"
        log_action "Minikube cluster started successfully"

        print_info "Cluster status:"
        minikube status

        echo
        log_action "Cluster creation successful"
    else
        print_error "Failed to start Minikube cluster\n"
        print_info "Checking logs: minikube logs"
        log_action "Minikube cluster creation failed"
        return 1
    fi
}

# Final summary
show_summary() {
    print_step "Installation Summary"

    echo -e "${GREEN}${BOLD}Installation Complete!${NC}\n"

    echo -e "${CYAN}Installed Components:${NC}"
    print_success "Docker - Container runtime"
    print_success "Minikube - Local Kubernetes cluster"
    print_success "kubectl - Kubernetes command-line tool"

    echo
    echo -e "${CYAN}Next Steps:${NC}"
    echo "1. Verify cluster is running:"
    echo "   $ minikube status"
    echo
    echo "2. Open Kubernetes dashboard:"
    echo "   $ minikube dashboard"
    echo
    echo "3. Deploy your first application:"
    echo "   $ kubectl create deployment nginx --image=nginx"
    echo "   $ kubectl expose deployment nginx --type=LoadBalancer --port=80"
    echo
    echo "4. Learn Kubernetes:"
    echo "   $ python3 minikube_tutorial.py"
    echo

    echo -e "${CYAN}Useful Commands:${NC}"
    echo "  minikube start        - Start cluster"
    echo "  minikube stop         - Stop cluster"
    echo "  minikube delete       - Delete cluster"
    echo "  kubectl get nodes     - List nodes"
    echo "  kubectl get pods      - List pods"
    echo

    echo -e "${CYAN}Installation Log:${NC}"
    echo "  $INSTALLATION_LOG"
    echo

    log_action "Installation completed successfully"

    print_success "Happy Minikube learning! 🚀\n"
}

# Main menu
show_menu() {
    while true; do
        print_header
        print_welcome

        echo "What would you like to do?"
        echo
        echo "1. 🔍 Detect System (automatic)"
        echo "2. 🐋 Install Docker"
        echo "3. 🚀 Install Minikube"
        echo "4. 📦 Install kubectl"
        echo "5. ⚙️  Setup KVM (Linux)"
        echo "6. ✅ Verify Installation"
        echo "7. 🎯 Deploy Minikube Cluster"
        echo "8. 🧠 Full Guided Installation (all steps)"
        echo "9. 📋 View Installation Log"
        echo "0. 🚪 Exit"
        echo

        read -p "Select option (0-9): " choice

        case $choice in
            1) show_system_info ;;
            2) install_docker ;;
            3) install_minikube ;;
            4) install_kubectl ;;
            5) setup_kvm ;;
            6) verify_installation ;;
            7) deploy_minikube ;;
            8) full_installation ;;
            9) view_log ;;
            0)
                print_info "Thank you for using the Minikube Installation Guide!"
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

# Full guided installation
full_installation() {
    print_header

    echo -e "${GREEN}Starting Full Guided Installation...${NC}\n"
    log_action "Full installation started"

    STEP_COUNT=0

    show_system_info || return 1
    sleep 1

    install_docker || return 1
    sleep 1

    install_minikube || return 1
    sleep 1

    install_kubectl || return 1
    sleep 1

    setup_kvm
    sleep 1

    verify_installation || return 1
    sleep 1

    if prompt_yn "Deploy Minikube cluster now?" "y"; then
        deploy_minikube || return 1
    fi

    show_summary
}

# View log
view_log() {
    print_header

    if [ -f "$INSTALLATION_LOG" ]; then
        echo -e "${CYAN}Installation Log:${NC}\n"
        cat "$INSTALLATION_LOG"
        echo
    else
        print_warning "No installation log found"
    fi
}

# Main execution
main() {
    log_action "=== Interactive Installation Script Started ==="
    show_menu
}

main "$@"
