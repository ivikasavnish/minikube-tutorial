#!/bin/bash

###############################################################################
# Advanced System Check Script
# Comprehensive system analysis for all architectures and OS
# Supports: x86_64 (AMD/Intel), ARM64 (Apple Silicon, ARM), ARMv7
# OS: macOS (Intel/Silicon), Ubuntu, Debian, Fedora, RHEL, CentOS
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

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# System variables
DETECTED_OS=""
DETECTED_OS_VERSION=""
DETECTED_ARCH=""
DETECTED_ARCH_NAME=""
DETECTED_ARCH_BITS=""
CPU_BRAND=""
CPU_COUNT=""
CPU_THREADS=""
MEMORY_TOTAL=""
MEMORY_AVAILABLE=""

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║  🔍 Advanced Minikube System Check v1.0.0                          ║"
    echo "║  Comprehensive analysis for all architectures and OS               ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
    ((WARNING_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    DETECTED_OS="macOS" ;;
        Linux*)     DETECTED_OS="Linux" ;;
        MINGW*)     DETECTED_OS="Windows" ;;
        *)          DETECTED_OS="Unknown" ;;
    esac

    if [[ "$DETECTED_OS" == "Linux" ]] && [ -f /etc/os-release ]; then
        source /etc/os-release
        DETECTED_OS_VERSION="$PRETTY_NAME"
    elif [[ "$DETECTED_OS" == "macOS" ]]; then
        DETECTED_OS_VERSION=$(sw_vers -productVersion)
    fi
}

# Detect architecture
detect_architecture() {
    local arch=$(uname -m)

    case "$arch" in
        x86_64|amd64)
            DETECTED_ARCH="x86_64"
            DETECTED_ARCH_NAME="AMD64 (Intel/AMD)"
            DETECTED_ARCH_BITS="64-bit"
            ;;
        aarch64|arm64)
            DETECTED_ARCH="arm64"
            DETECTED_ARCH_NAME="ARM64 (Apple Silicon/ARM)"
            DETECTED_ARCH_BITS="64-bit"
            ;;
        armv7l)
            DETECTED_ARCH="armv7"
            DETECTED_ARCH_NAME="ARMv7 (32-bit ARM)"
            DETECTED_ARCH_BITS="32-bit"
            ;;
        armv6l)
            DETECTED_ARCH="armv6"
            DETECTED_ARCH_NAME="ARMv6 (Raspberry Pi)"
            DETECTED_ARCH_BITS="32-bit"
            ;;
        *)
            DETECTED_ARCH="$arch"
            DETECTED_ARCH_NAME="$arch (Unknown)"
            DETECTED_ARCH_BITS="Unknown"
            ;;
    esac
}

# Get CPU info
get_cpu_info() {
    if [[ "$DETECTED_OS" == "macOS" ]]; then
        CPU_BRAND=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")
        CPU_COUNT=$(sysctl -n hw.ncpu)
        CPU_THREADS=$(sysctl -n hw.ncpu)
    elif [[ "$DETECTED_OS" == "Linux" ]]; then
        CPU_BRAND=$(grep -m1 "model name" /proc/cpuinfo | sed 's/.*: //' || echo "Unknown")
        CPU_COUNT=$(nproc --all)
        CPU_THREADS=$(grep -c "^processor" /proc/cpuinfo || echo "$CPU_COUNT")
    fi
}

# Get memory info
get_memory_info() {
    if [[ "$DETECTED_OS" == "macOS" ]]; then
        MEMORY_TOTAL=$(sysctl -n hw.memsize | awk '{printf "%.0f", $1/1024/1024/1024}')
        MEMORY_AVAILABLE=$(vm_stat | grep "Pages free" | awk '{print int($3 * 4096 / 1024 / 1024 / 1024)}')
    elif [[ "$DETECTED_OS" == "Linux" ]]; then
        MEMORY_TOTAL=$(free -g | awk '/^Mem:/{print $2}')
        MEMORY_AVAILABLE=$(free -g | awk '/^Mem:/{print $7}')
    fi
}

# Check OS compatibility
check_os_compatibility() {
    print_section "Operating System Check"

    echo "OS: $DETECTED_OS"
    echo "Version: $DETECTED_OS_VERSION"

    case "$DETECTED_OS" in
        macOS)
            print_success "macOS is supported"

            if [[ "$DETECTED_ARCH" == "arm64" ]]; then
                print_success "Apple Silicon (M1/M2/M3/M4) detected - optimized support"
            else
                print_success "Intel Mac detected - full support"
            fi
            ;;
        Linux)
            if grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
                print_success "Ubuntu/Debian detected - fully supported"
            elif grep -qi "fedora\|rhel\|centos" /etc/os-release 2>/dev/null; then
                print_success "Fedora/RHEL/CentOS detected - fully supported"
            else
                print_warning "Linux distribution - should work but may need manual setup"
            fi
            ;;
        Windows)
            print_warning "Windows detected - use WSL2 or native support"
            ;;
        *)
            print_error "Unknown OS - compatibility not guaranteed"
            ;;
    esac
}

# Check architecture support
check_architecture_support() {
    print_section "CPU Architecture Check"

    echo "Architecture: $DETECTED_ARCH_NAME"
    echo "Bits: $DETECTED_ARCH_BITS"
    echo "CPU Brand: $CPU_BRAND"
    echo "Cores/Threads: $CPU_COUNT/$CPU_THREADS"

    case "$DETECTED_ARCH" in
        x86_64)
            print_success "AMD64/x86_64 - full Kubernetes support"
            ;;
        arm64)
            print_success "ARM64 - full Kubernetes support"
            if [[ "$DETECTED_OS" == "macOS" ]]; then
                print_info "Apple Silicon - optimized Docker Desktop available"
            fi
            ;;
        armv7)
            print_warning "ARMv7 - limited Kubernetes support"
            print_info "Some images may not be available for 32-bit ARM"
            ;;
        armv6)
            print_warning "ARMv6 (Raspberry Pi) - very limited support"
            print_info "Consider using k3s instead of full Kubernetes"
            ;;
        *)
            print_warning "Unknown architecture - compatibility uncertain"
            ;;
    esac
}

# Check CPU features
check_cpu_features() {
    print_section "CPU Features Check"

    if [[ "$DETECTED_OS" == "Linux" ]]; then
        # Check for virtualization support
        if grep -q "vmx" /proc/cpuinfo 2>/dev/null; then
            print_success "Intel VT-x (vmx) virtualization detected"
        elif grep -q "svm" /proc/cpuinfo 2>/dev/null; then
            print_success "AMD-V (svm) virtualization detected"
        else
            if [[ "$DETECTED_ARCH" == "arm64" || "$DETECTED_ARCH" == "armv7" ]]; then
                print_info "ARM architecture - virtualization may be handled differently"
            else
                print_warning "Virtualization not detected - may be disabled in BIOS"
                print_info "Enable in BIOS/UEFI for better performance"
            fi
        fi

        # Check for nested virtualization
        if [ -f /sys/module/kvm_intel/parameters/nested ] || [ -f /sys/module/kvm_amd/parameters/nesting ]; then
            print_info "Nested virtualization available (optional feature)"
        fi
    elif [[ "$DETECTED_OS" == "macOS" ]]; then
        print_info "macOS - native hypervisor framework available"
    fi
}

# Check memory
check_memory() {
    print_section "Memory Check"

    echo "Total Memory: ${MEMORY_TOTAL}GB"
    echo "Available Memory: ${MEMORY_AVAILABLE}GB"

    if [ "$MEMORY_TOTAL" -ge 8 ]; then
        print_success "Memory: ${MEMORY_TOTAL}GB (recommended)"
    elif [ "$MEMORY_TOTAL" -ge 4 ]; then
        print_warning "Memory: ${MEMORY_TOTAL}GB (minimum acceptable - 8GB recommended)"
    else
        print_error "Memory: ${MEMORY_TOTAL}GB (insufficient - minimum 4GB required)"
    fi
}

# Check disk space
check_disk_space() {
    print_section "Disk Space Check"

    local disk_usage=$(df -h / | awk 'NR==2')
    local disk_total=$(echo $disk_usage | awk '{print $2}')
    local disk_available=$(echo $disk_usage | awk '{print $4}')
    local disk_percent=$(echo $disk_usage | awk '{print $5}')

    echo "Total: $disk_total"
    echo "Available: $disk_available"
    echo "Used: $disk_percent"

    local available_int="${disk_available%G*}"
    if [ "${available_int%.*}" -ge 30 ]; then
        print_success "Disk space: $disk_available (recommended)"
    elif [ "${available_int%.*}" -ge 20 ]; then
        print_warning "Disk space: $disk_available (minimum acceptable)"
    else
        print_error "Disk space: $disk_available (insufficient - need 20GB+)"
    fi
}

# Check Docker installation
check_docker() {
    print_section "Docker Installation Check"

    if command -v docker >/dev/null 2>&1; then
        local docker_version=$(docker --version)
        print_success "Docker installed: $docker_version"

        if docker ps >/dev/null 2>&1; then
            print_success "Docker daemon is running"

            # Check docker architecture support
            local docker_arch=$(docker version --format '{{.Server.Arch}}' 2>/dev/null || echo "unknown")
            print_info "Docker architecture: $docker_arch"
        else
            print_error "Docker daemon is not running"
            print_info "Start Docker before running Minikube"
        fi
    else
        print_error "Docker not installed"
        print_info "Install Docker from: https://www.docker.com/products/docker-desktop"
    fi
}

# Check Minikube installation
check_minikube() {
    print_section "Minikube Installation Check"

    if command -v minikube >/dev/null 2>&1; then
        local minikube_version=$(minikube version)
        print_success "Minikube installed: $minikube_version"

        # Check minikube config
        if minikube profile list >/dev/null 2>&1; then
            print_info "Available profiles:"
            minikube profile list | head -5
        fi

        # Check status
        if minikube status >/dev/null 2>&1; then
            local status=$(minikube status)
            if echo "$status" | grep -q "Running"; then
                print_success "Minikube cluster is running"
            else
                print_warning "Minikube cluster is not running"
                print_info "Start with: minikube start"
            fi
        fi
    else
        print_error "Minikube not installed"
        print_info "Install with: ./scripts/quick-setup.sh"
    fi
}

# Check kubectl installation
check_kubectl() {
    print_section "kubectl Installation Check"

    if command -v kubectl >/dev/null 2>&1; then
        local kubectl_version=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null)
        print_success "kubectl installed: $kubectl_version"

        # Check context
        if kubectl config current-context >/dev/null 2>&1; then
            local context=$(kubectl config current-context)
            print_info "Current context: $context"
        fi
    else
        print_error "kubectl not installed"
        print_info "Install with: ./scripts/quick-setup.sh"
    fi
}

# Check container runtimes
check_container_runtimes() {
    print_section "Container Runtime Check"

    if command -v containerd >/dev/null 2>&1; then
        print_info "containerd: $(containerd --version)"
    fi

    if command -v cri-o >/dev/null 2>&1; then
        print_info "cri-o: $(crio --version)"
    fi

    if command -v podman >/dev/null 2>&1; then
        print_info "podman: $(podman --version)"
    fi

    if ! command -v docker >/dev/null 2>&1 && ! command -v containerd >/dev/null 2>&1; then
        print_warning "No container runtime detected"
    fi
}

# Check Kubernetes cluster
check_kubernetes_cluster() {
    print_section "Kubernetes Cluster Check"

    if command -v kubectl >/dev/null 2>&1; then
        if kubectl cluster-info >/dev/null 2>&1; then
            print_success "Kubernetes cluster is accessible"

            # Get cluster version
            local k8s_version=$(kubectl version --short 2>/dev/null | grep Server || echo "unknown")
            print_info "Server version: $k8s_version"

            # Get nodes
            echo
            print_info "Nodes:"
            kubectl get nodes 2>/dev/null | head -5

            # Get resources
            echo
            print_info "Resource Usage:"
            if kubectl top nodes >/dev/null 2>&1; then
                kubectl top nodes 2>/dev/null | head -5
            else
                print_info "Metrics not available (install metrics-server)"
            fi
        else
            print_warning "Kubernetes cluster not accessible"
        fi
    else
        print_error "kubectl not found - cannot check cluster"
    fi
}

# Check network
check_network() {
    print_section "Network Check"

    # Check internet connectivity
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        print_success "Internet connectivity: OK"
    else
        print_warning "Internet connectivity: May be offline or restricted"
    fi

    # Check DNS
    if nslookup kubernetes.io >/dev/null 2>&1; then
        print_success "DNS resolution: OK"
    else
        print_warning "DNS resolution: Failed"
    fi
}

# Check permissions
check_permissions() {
    print_section "User Permissions Check"

    # Check docker group (Linux)
    if [[ "$DETECTED_OS" == "Linux" ]]; then
        if groups | grep -q docker; then
            print_success "User in docker group"
        else
            print_warning "User not in docker group - sudo may be required"
            print_info "Fix with: sudo usermod -aG docker \$USER"
        fi

        # Check libvirt group
        if groups | grep -q libvirt; then
            print_success "User in libvirt group"
        else
            print_info "User not in libvirt group - may be needed for KVM"
        fi
    fi

    # Check home directory permissions
    if [ -w "$HOME" ]; then
        print_success "Home directory is writable"
    else
        print_error "Home directory is not writable"
    fi

    # Check .kube directory
    if [ -d "$HOME/.kube" ]; then
        if [ -w "$HOME/.kube" ]; then
            print_success "~/.kube directory is writable"
        else
            print_warning "~/.kube directory is not writable"
        fi
    fi
}

# Generate report
generate_report() {
    print_section "Summary Report"

    echo
    echo -e "${CYAN}System Profile:${NC}"
    echo "  OS: $DETECTED_OS ($DETECTED_OS_VERSION)"
    echo "  Architecture: $DETECTED_ARCH_NAME ($DETECTED_ARCH_BITS)"
    echo "  CPU: $CPU_BRAND"
    echo "  Cores: $CPU_COUNT"
    echo "  Memory: ${MEMORY_TOTAL}GB"

    echo
    echo -e "${CYAN}Check Results:${NC}"
    echo "  Total Checks: $TOTAL_CHECKS"
    echo -e "  ${GREEN}Passed: $PASSED_CHECKS${NC}"
    echo -e "  ${YELLOW}Warnings: $WARNING_CHECKS${NC}"
    echo -e "  ${RED}Failed: $FAILED_CHECKS${NC}"

    echo
    if [ $FAILED_CHECKS -eq 0 ]; then
        echo -e "${GREEN}✓ System is ready for Minikube!${NC}"
        return 0
    else
        echo -e "${RED}✗ System has issues - see above for details${NC}"
        return 1
    fi
}

# Main execution
main() {
    print_header

    detect_os
    detect_architecture
    get_cpu_info
    get_memory_info

    check_os_compatibility
    check_architecture_support
    check_cpu_features
    check_memory
    check_disk_space
    check_permissions
    check_network
    check_docker
    check_minikube
    check_kubectl
    check_container_runtimes
    check_kubernetes_cluster
    generate_report

    local result=$?

    echo
    echo -e "${CYAN}For more information:${NC}"
    echo "  • Full documentation: README.md"
    echo "  • Installation guide: INSTALL.md"
    echo "  • Quick start: GETTING_STARTED.md"
    echo "  • Deploy script: ./scripts/deploy-minikube.sh"

    return $result
}

main
