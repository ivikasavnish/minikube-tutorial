#!/bin/bash

###############################################################################
# System Verification Script
# Checks if all Minikube dependencies are installed and configured
# Version: 1.0.0
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🔍 Minikube System Check v1.0.0      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo
}

check_command() {
    local cmd=$1
    local display_name=$2

    ((TOTAL_CHECKS++))

    if command -v "$cmd" >/dev/null 2>&1; then
        version=$("$cmd" --version 2>/dev/null || "$cmd" version --client --short 2>/dev/null || echo "installed")
        echo -e "${GREEN}✓${NC} $display_name: $version"
        ((PASSED_CHECKS++))
    else
        echo -e "${RED}✗${NC} $display_name: NOT FOUND"
        ((FAILED_CHECKS++))
    fi
}

check_minikube_status() {
    ((TOTAL_CHECKS++))

    echo -e "\n${BLUE}━━ Minikube Cluster Status ━━${NC}"

    if command -v minikube >/dev/null 2>&1; then
        status=$(minikube status 2>/dev/null || echo "not running")

        if [[ $status == *"Running"* ]]; then
            echo -e "${GREEN}✓${NC} Minikube is running"
            ((PASSED_CHECKS++))

            # Show cluster info
            echo -e "\n${BLUE}Cluster Information:${NC}"
            minikube status --format='- Host: {{.Host}}' 2>/dev/null || true
            minikube status --format='- Kubelet: {{.Kubelet}}' 2>/dev/null || true
            minikube status --format='- APIServer: {{.APIServer}}' 2>/dev/null || true

            # Show node info
            echo -e "\n${BLUE}Kubernetes Nodes:${NC}"
            kubectl get nodes 2>/dev/null || true

        else
            echo -e "${YELLOW}⚠${NC}  Minikube is not running"
            echo -e "   Start with: ${BLUE}minikube start${NC}"
            ((FAILED_CHECKS++))
        fi
    fi
}

check_kubernetes_resources() {
    ((TOTAL_CHECKS++))

    echo -e "\n${BLUE}━━ Kubernetes Resources ━━${NC}"

    if command -v kubectl >/dev/null 2>&1; then
        echo -e "${BLUE}Deployments:${NC}"
        kubectl get deployments --all-namespaces 2>/dev/null | head -5 || echo "Unable to fetch"

        echo -e "\n${BLUE}Pods:${NC}"
        kubectl get pods --all-namespaces 2>/dev/null | head -5 || echo "Unable to fetch"

        echo -e "\n${BLUE}Services:${NC}"
        kubectl get services --all-namespaces 2>/dev/null | head -5 || echo "Unable to fetch"

        ((PASSED_CHECKS++))
    else
        echo -e "${RED}✗${NC} kubectl not found"
        ((FAILED_CHECKS++))
    fi
}

check_disk_space() {
    ((TOTAL_CHECKS++))

    echo -e "\n${BLUE}━━ Disk Space ━━${NC}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        available=$(df -h ~ | awk 'NR==2 {print $4}')
        echo "Available space in home: $available"
    else
        # Linux
        available=$(df -h ~ | awk 'NR==2 {print $4}')
        echo "Available space in home: $available"
    fi

    ((PASSED_CHECKS++))
}

check_virtualization() {
    ((TOTAL_CHECKS++))

    echo -e "\n${BLUE}━━ Virtualization Support ━━${NC}"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -q vmx /proc/cpuinfo; then
            echo -e "${GREEN}✓${NC} Intel VT-x detected"
            ((PASSED_CHECKS++))
        elif grep -q svm /proc/cpuinfo; then
            echo -e "${GREEN}✓${NC} AMD-V detected"
            ((PASSED_CHECKS++))
        else
            echo -e "${RED}✗${NC} Virtualization not detected"
            ((FAILED_CHECKS++))
        fi
    else
        echo -e "${YELLOW}ℹ${NC}  Virtualization check only available on Linux"
    fi
}

check_docker_daemon() {
    ((TOTAL_CHECKS++))

    echo -e "\n${BLUE}━━ Docker Daemon ━━${NC}"

    if command -v docker >/dev/null 2>&1; then
        if docker ps >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} Docker daemon is running"
            ((PASSED_CHECKS++))
        else
            echo -e "${YELLOW}⚠${NC}  Docker is installed but daemon may not be running"
            echo -e "   Start Docker daemon and try again"
            ((FAILED_CHECKS++))
        fi
    else
        echo -e "${RED}✗${NC} Docker not found"
        ((FAILED_CHECKS++))
    fi
}

check_memory() {
    ((TOTAL_CHECKS++))

    echo -e "\n${BLUE}━━ System Memory ━━${NC}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        total=$(sysctl -n hw.memsize | awk '{printf "%.0f", $1/1024/1024/1024}')
    else
        total=$(grep MemTotal /proc/meminfo | awk '{printf "%.0f", $2/1024/1024}')
    fi

    echo "Total RAM: ${total}GB"

    if (( $(echo "$total >= 8" | bc -l) )); then
        echo -e "${GREEN}✓${NC} Sufficient memory for Minikube"
        ((PASSED_CHECKS++))
    else
        echo -e "${YELLOW}⚠${NC}  Memory is less than 8GB recommended"
        ((FAILED_CHECKS++))
    fi
}

show_summary() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Verification Summary${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "Total Checks: $TOTAL_CHECKS"
    echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
    echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
    echo

    if [ $FAILED_CHECKS -eq 0 ]; then
        echo -e "${GREEN}✓ All checks passed! Your system is ready for Minikube.${NC}"
        exit 0
    else
        echo -e "${RED}✗ Some checks failed. Please review and fix the issues above.${NC}"
        exit 1
    fi
}

# Main execution
main() {
    print_header

    echo -e "${BLUE}Checking system requirements...${NC}\n"

    # Check installed tools
    echo -e "${BLUE}━━ Installation Status ━━${NC}"
    check_command "docker" "Docker"
    check_command "minikube" "Minikube"
    check_command "kubectl" "kubectl"

    # Check system
    check_memory
    check_disk_space
    check_virtualization
    check_docker_daemon

    # Check Minikube status
    check_minikube_status

    # Check Kubernetes resources
    check_kubernetes_resources

    # Show summary
    show_summary
}

# Run main
main
