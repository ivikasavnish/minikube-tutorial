#!/usr/bin/env bash

###############################################################################
# Deploy Minikube Script
# Intelligent deployment based on system architecture and OS
# Supports: x86_64, ARM64 (Apple Silicon, Raspberry Pi), amd64
# OS: macOS (Intel/Apple Silicon), Ubuntu, Debian, Fedora, RHEL
# Version: 1.0.0
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DETECTED_OS=""
DETECTED_ARCH=""
DETECTED_ARCH_NAME=""
CPU_COUNT=""
MEMORY_GB=""

# Print functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🚀 Minikube Intelligent Deployment Script v1.0.0         ║${NC}"
    echo -e "${BLUE}║  Auto-configured for your system architecture             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_section() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

# Detect operating system
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
        x86_64|amd64)
            DETECTED_ARCH="x86_64"
            DETECTED_ARCH_NAME="AMD64 (Intel/AMD)"
            ;;
        aarch64|arm64)
            DETECTED_ARCH="arm64"
            DETECTED_ARCH_NAME="ARM64 (Apple Silicon/ARM)"
            ;;
        armv7l)
            DETECTED_ARCH="armv7"
            DETECTED_ARCH_NAME="ARMv7 (32-bit ARM)"
            ;;
        *)
            DETECTED_ARCH="$arch"
            DETECTED_ARCH_NAME="$arch (Unknown)"
            ;;
    esac
}

# Get system resources
get_system_resources() {
    if [[ "$DETECTED_OS" == "macOS" ]]; then
        CPU_COUNT=$(sysctl -n hw.ncpu)
        MEMORY_GB=$(sysctl -n hw.memsize | awk '{printf "%.0f", $1/1024/1024/1024}')
    elif [[ "$DETECTED_OS" == "Linux" ]]; then
        CPU_COUNT=$(nproc)
        MEMORY_GB=$(free -g | awk '/^Mem:/{print $2}')
    fi
}

# Check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Display system information
show_system_info() {
    print_section "System Information"

    echo -e "${CYAN}Operating System:${NC}"
    echo "  OS: $DETECTED_OS"
    echo "  Architecture: $DETECTED_ARCH_NAME"

    echo
    echo -e "${CYAN}Hardware:${NC}"
    echo "  CPU Cores: $CPU_COUNT"
    echo "  Memory: ${MEMORY_GB}GB"

    echo
    echo -e "${CYAN}Installed Tools:${NC}"

    if command_exists docker; then
        docker_version=$(docker --version 2>/dev/null || echo "installed")
        print_success "Docker: $docker_version"
    else
        print_warning "Docker: NOT INSTALLED"
    fi

    if command_exists minikube; then
        minikube_version=$(minikube version 2>/dev/null || echo "installed")
        print_success "Minikube: $minikube_version"
    else
        print_warning "Minikube: NOT INSTALLED"
    fi

    if command_exists kubectl; then
        kubectl_version=$(kubectl version --client --short 2>/dev/null || echo "installed")
        print_success "kubectl: $kubectl_version"
    else
        print_warning "kubectl: NOT INSTALLED"
    fi
}

# Check system requirements
check_requirements() {
    print_section "System Requirements Check"

    local all_ok=true

    # Check CPU cores
    if [ "$CPU_COUNT" -ge 2 ]; then
        print_success "CPU Cores: $CPU_COUNT (sufficient)"
    else
        print_error "CPU Cores: $CPU_COUNT (minimum 2 required)"
        all_ok=false
    fi

    # Check memory
    if [ "$MEMORY_GB" -ge 8 ]; then
        print_success "Memory: ${MEMORY_GB}GB (recommended)"
    elif [ "$MEMORY_GB" -ge 4 ]; then
        print_warning "Memory: ${MEMORY_GB}GB (minimum - 8GB recommended)"
    else
        print_error "Memory: ${MEMORY_GB}GB (minimum 4GB required)"
        all_ok=false
    fi

    # Check disk space
    local disk_available=$(df -h / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "${disk_available%.*}" -ge 20 ]; then
        print_success "Disk Space: ${disk_available}B available"
    else
        print_warning "Disk Space: ${disk_available}B (minimum 20GB recommended)"
    fi

    # Check virtualization
    if [[ "$DETECTED_OS" == "Linux" ]]; then
        if grep -q "vmx\|svm" /proc/cpuinfo 2>/dev/null; then
            print_success "Virtualization: Enabled"
        else
            print_warning "Virtualization: Not detected (may be disabled in BIOS)"
        fi
    fi

    if $all_ok; then
        print_success "All requirements met!"
        return 0
    else
        print_error "Some requirements not met"
        return 1
    fi
}

# Recommend driver based on system
recommend_driver() {
    print_section "Driver Recommendation"

    local recommended_driver=""
    local driver_options=()

    case "$DETECTED_OS" in
        macOS)
            print_info "macOS detected"
            recommended_driver="docker"
            driver_options=("docker" "virtualbox" "hyperkit")

            if [[ "$DETECTED_ARCH" == "arm64" ]]; then
                print_success "Apple Silicon detected - optimized for Docker Desktop"
                recommended_driver="docker"
            else
                print_info "Intel Mac detected"
            fi
            ;;
        Linux)
            print_info "Linux detected"

            if [[ "$DETECTED_ARCH" == "arm64" ]]; then
                print_info "ARM64 Linux detected"
                recommended_driver="docker"
                driver_options=("docker" "kvm2")
            else
                print_info "x86_64 Linux detected"
                recommended_driver="kvm2"
                driver_options=("kvm2" "docker" "virtualbox")
            fi
            ;;
    esac

    echo
    echo -e "${CYAN}Recommended Driver: ${GREEN}$recommended_driver${NC}"
    echo -e "${CYAN}Available Options: ${GREEN}${driver_options[@]}${NC}"
    echo
}

# Deploy Minikube with optimal settings
deploy_minikube() {
    print_section "Deploying Minikube"

    # Get user's driver choice
    echo "Available drivers for your system:"

    case "$DETECTED_OS" in
        macOS)
            echo "  1. docker (recommended)"
            echo "  2. virtualbox"
            echo "  3. hyperkit"
            ;;
        Linux)
            if [[ "$DETECTED_ARCH" == "arm64" ]]; then
                echo "  1. docker (recommended)"
                echo "  2. kvm2"
            else
                echo "  1. kvm2 (recommended)"
                echo "  2. docker"
                echo "  3. virtualbox"
            fi
            ;;
    esac

    read -p "Select driver (1-3): " driver_choice

    local driver=""
    case "$driver_choice" in
        1) driver="docker" ;;
        2) driver="virtualbox" ;;
        3) driver="hyperkit" ;;
        *)
            print_error "Invalid choice"
            return 1
            ;;
    esac

    # Calculate optimal resources
    local cpus=$CPU_COUNT
    local memory=$((MEMORY_GB / 2))  # Use half of available memory

    # Ensure minimum resources
    if [ "$cpus" -lt 2 ]; then cpus=2; fi
    if [ "$memory" -lt 2 ]; then memory=4; fi
    if [ "$memory" -gt 8 ]; then memory=8; fi

    print_info "Configuring with: $cpus CPUs, ${memory}GB Memory"

    # Stop existing cluster if running
    if minikube status >/dev/null 2>&1; then
        print_info "Stopping existing Minikube cluster..."
        minikube stop || true
    fi

    # Deploy based on architecture
    print_info "Starting Minikube with $driver driver..."

    if [[ "$DETECTED_ARCH" == "arm64" && "$driver" == "docker" ]]; then
        print_info "ARM64 detected - using optimized settings"
        minikube start \
            --driver=$driver \
            --cpus=$cpus \
            --memory=${memory}gb \
            --container-runtime=docker
    elif [[ "$driver" == "kvm2" ]]; then
        print_info "KVM2 driver - using optimized settings"
        minikube start \
            --driver=$driver \
            --cpus=$cpus \
            --memory=${memory}gb \
            --disk-size=40gb
    else
        # Standard deployment
        minikube start \
            --driver=$driver \
            --cpus=$cpus \
            --memory=${memory}gb
    fi

    if [ $? -eq 0 ]; then
        print_success "Minikube deployed successfully!"

        echo
        print_info "Cluster Status:"
        minikube status

        echo
        print_info "Cluster Info:"
        kubectl cluster-info

        echo
        print_success "Deployment complete!"
        echo
        echo "Next steps:"
        echo "  1. Deploy an app: kubectl create deployment nginx --image=nginx"
        echo "  2. Expose service: kubectl expose deployment nginx --type=LoadBalancer --port=80"
        echo "  3. Access: minikube service nginx"
        echo "  4. Open dashboard: minikube dashboard"

        return 0
    else
        print_error "Failed to start Minikube"
        print_info "Checking logs: minikube logs"
        minikube logs | tail -20
        return 1
    fi
}

# Configure for specific Linux distribution
configure_linux() {
    print_section "Linux Configuration"

    if [ ! -f /etc/os-release ]; then
        print_error "Cannot determine Linux distribution"
        return 1
    fi

    source /etc/os-release
    print_info "Distribution: $NAME $VERSION"

    case "$ID" in
        ubuntu|debian)
            print_info "Ubuntu/Debian detected"

            if ! command_exists docker; then
                print_warning "Docker not installed"
                read -p "Install Docker? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    curl -fsSL https://get.docker.com -o get-docker.sh
                    sudo sh get-docker.sh
                    sudo usermod -aG docker $USER
                    print_success "Docker installed"
                fi
            fi

            # Check for KVM support
            if [[ "$DETECTED_ARCH" == "x86_64" ]]; then
                if grep -q "vmx\|svm" /proc/cpuinfo; then
                    read -p "Install KVM driver? (recommended) (y/n): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        sudo apt-get update
                        sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager
                        sudo usermod -a -G libvirt $USER
                        print_success "KVM installed"
                        print_warning "Please logout/login for group changes to take effect"
                    fi
                fi
            fi
            ;;
        fedora|rhel|centos)
            print_info "Fedora/RHEL/CentOS detected"

            if ! command_exists docker; then
                print_warning "Docker not installed"
                read -p "Install Docker? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    sudo dnf install -y docker
                    sudo systemctl start docker
                    sudo usermod -aG docker $USER
                    print_success "Docker installed"
                fi
            fi
            ;;
    esac
}

# Configure for macOS
configure_macos() {
    print_section "macOS Configuration"

    if [[ "$DETECTED_ARCH" == "arm64" ]]; then
        print_info "Apple Silicon (M1/M2/M3) detected"
        print_success "Native ARM64 support available"
    else
        print_info "Intel Mac detected"
    fi

    if ! command_exists docker; then
        print_warning "Docker not installed"
        print_info "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
        read -p "Press Enter after Docker Desktop is installed..."
    fi
}

# Interactive menu
show_menu() {
    clear
    print_header

    show_system_info
    echo
    check_requirements
    echo
    recommend_driver

    echo -e "${CYAN}What would you like to do?${NC}\n"
    echo "1. ✅ Deploy Minikube with optimal settings"
    echo "2. 🔍 Check system requirements"
    echo "3. 🔧 Show detailed system information"
    echo "4. 📋 Show available drivers"
    echo "5. ⚙️  Configure system for Minikube"
    echo "6. 🚀 Advanced deployment options"
    echo "0. 🚪 Exit"
    echo

    read -p "Select option (0-6): " choice

    case $choice in
        1) deploy_minikube ;;
        2) check_requirements ;;
        3) show_system_info ;;
        4) recommend_driver ;;
        5)
            if [[ "$DETECTED_OS" == "Linux" ]]; then
                configure_linux
            elif [[ "$DETECTED_OS" == "macOS" ]]; then
                configure_macos
            fi
            ;;
        6) advanced_deployment ;;
        0)
            print_success "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
    show_menu
}

# Advanced deployment options
advanced_deployment() {
    print_section "Advanced Deployment Options"

    echo "Custom Configuration:"
    read -p "CPU cores (current: $CPU_COUNT): " custom_cpus
    custom_cpus=${custom_cpus:-$CPU_COUNT}

    read -p "Memory in GB (current: $MEMORY_GB): " custom_memory
    custom_memory=${custom_memory:-$MEMORY_GB}

    read -p "Disk size in GB (default: 40): " custom_disk
    custom_disk=${custom_disk:-40}

    read -p "Driver (docker/kvm2/virtualbox): " custom_driver
    custom_driver=${custom_driver:-docker}

    echo
    print_info "Deploying with custom settings:"
    echo "  CPUs: $custom_cpus"
    echo "  Memory: ${custom_memory}GB"
    echo "  Disk: ${custom_disk}GB"
    echo "  Driver: $custom_driver"
    echo

    read -p "Proceed? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        minikube start \
            --driver=$custom_driver \
            --cpus=$custom_cpus \
            --memory=${custom_memory}gb \
            --disk-size=${custom_disk}gb

        print_success "Minikube deployed!"
        minikube status
    fi
}

# Main execution
main() {
    detect_os
    detect_architecture
    get_system_resources

    # If arguments provided, run specific function
    if [ $# -gt 0 ]; then
        case "$1" in
            info)
                print_header
                show_system_info
                ;;
            check)
                print_header
                check_requirements
                ;;
            deploy)
                print_header
                deploy_minikube
                ;;
            advanced)
                print_header
                advanced_deployment
                ;;
            *)
                print_header
                print_error "Unknown argument: $1"
                echo "Usage: $0 [info|check|deploy|advanced]"
                exit 1
                ;;
        esac
    else
        show_menu
    fi
}

main "$@"
