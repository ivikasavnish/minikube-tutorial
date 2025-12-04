#!/bin/bash

################################################################################
#                                                                              #
#  🔍 System Detection Module                                                #
#  Detects and reports on installed components:                              #
#  - Python version                                                           #
#  - Docker/Container runtime                                                #
#  - Minikube version and status                                              #
#  - kubectl version                                                          #
#  - Installed add-ons                                                        #
#  - Installed Helm packages                                                  #
#                                                                              #
################################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Detection functions
detect_python() {
    if command -v python3 &> /dev/null; then
        local version=$(python3 --version 2>&1 | awk '{print $2}')
        echo "${GREEN}✓${NC} Python 3 v${version}"
        return 0
    else
        echo "${RED}✗${NC} Python 3 not installed"
        return 1
    fi
}

detect_docker() {
    if command -v docker &> /dev/null; then
        local version=$(docker --version 2>&1 | sed 's/.*Docker version \([^ ,]*\).*/\1/')
        echo "${GREEN}✓${NC} Docker v${version}"
        return 0
    else
        echo "${RED}✗${NC} Docker not installed"
        return 1
    fi
}

detect_minikube() {
    if command -v minikube &> /dev/null; then
        local version=$(minikube version 2>&1 | sed 's/.*version: v//; s/,.*//' | head -1)
        local status=$(minikube status 2>&1 | grep -i "host" | awk '{print tolower($NF)}' | head -1)

        if [ -z "$status" ]; then
            status=$(minikube status 2>&1 | head -1 | awk '{print tolower($NF)}')
        fi

        echo -n "${GREEN}✓${NC} Minikube v${version}"

        if [ "$status" = "running" ] || echo "$status" | grep -q "Running"; then
            echo " (${GREEN}Running${NC})"
            return 0
        else
            echo " (${YELLOW}Stopped${NC})"
            return 2
        fi
    else
        echo "${RED}✗${NC} Minikube not installed"
        return 1
    fi
}

detect_kubectl() {
    if command -v kubectl &> /dev/null; then
        local version=$(kubectl version --client 2>&1 | sed 's/.*v//' | sed 's/,.*//' | head -1)
        echo "${GREEN}✓${NC} kubectl v${version}"
        return 0
    else
        echo "${RED}✗${NC} kubectl not installed"
        return 1
    fi
}

detect_helm() {
    if command -v helm &> /dev/null; then
        local version=$(helm version 2>&1 | sed 's/.*v//' | sed 's/,.*//' | head -1)
        echo "${GREEN}✓${NC} Helm v${version}"
        return 0
    else
        echo "${YELLOW}⊘${NC} Helm not installed"
        return 1
    fi
}

detect_uv() {
    if command -v uv &> /dev/null; then
        local version=$(uv --version 2>&1 | awk '{print $2}')
        echo "${GREEN}✓${NC} uv v${version}"
        return 0
    else
        echo "${YELLOW}⊘${NC} uv not installed"
        return 1
    fi
}

detect_minikube_addons() {
    if ! command -v minikube &> /dev/null; then
        echo "${RED}✗${NC} Minikube not installed (cannot detect add-ons)"
        return 1
    fi

    local addons=$(minikube addons list 2>&1)

    if [ -z "$addons" ]; then
        echo "${YELLOW}⊘${NC} No add-ons detected"
        return 1
    fi

    local enabled=()
    while IFS= read -r line; do
        if echo "$line" | grep -q "enabled"; then
            local addon=$(echo "$line" | awk '{print $1}' | sed 's/:$//')
            enabled+=("$addon")
        fi
    done <<< "$addons"

    if [ ${#enabled[@]} -eq 0 ]; then
        echo "${YELLOW}⊘${NC} No add-ons enabled"
        return 1
    fi

    echo "${GREEN}✓${NC} ${#enabled[@]} add-on(s) enabled:"
    for addon in "${enabled[@]}"; do
        echo "    • $addon"
    done
    return 0
}

detect_helm_releases() {
    if ! command -v helm &> /dev/null; then
        return 1
    fi

    if ! kubectl cluster-info &> /dev/null; then
        echo "${YELLOW}⊘${NC} Kubernetes cluster not accessible"
        return 1
    fi

    local releases=$(helm list -A 2>&1 | tail -n +2 | wc -l)

    if [ "$releases" -eq 0 ]; then
        echo "${YELLOW}⊘${NC} No Helm releases installed"
        return 1
    fi

    echo "${GREEN}✓${NC} ${releases} Helm release(s) installed:"
    helm list -A 2>&1 | tail -n +2 | awk '{print "    • " $1 " (" $2 ")"}'
    return 0
}

detect_cluster_info() {
    if ! kubectl cluster-info &> /dev/null; then
        echo "${YELLOW}⊘${NC} Kubernetes cluster not accessible"
        return 1
    fi

    local nodes=$(kubectl get nodes 2>&1 | tail -n +2 | wc -l)
    local pods=$(kubectl get pods -A 2>&1 | tail -n +2 | wc -l)
    local namespaces=$(kubectl get namespaces 2>&1 | tail -n +2 | wc -l)

    echo "${GREEN}✓${NC} Kubernetes cluster status:"
    echo "    • Nodes: ${nodes}"
    echo "    • Pods: ${pods}"
    echo "    • Namespaces: ${namespaces}"
    return 0
}

# Full system detection
detect_all() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🔍 System Detection Report"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${CYAN}Runtime Environment:${NC}"
    detect_python
    detect_docker
    detect_uv
    echo ""

    echo -e "${CYAN}Kubernetes Stack:${NC}"
    detect_minikube
    detect_kubectl
    detect_helm
    echo ""

    echo -e "${CYAN}Minikube Add-ons:${NC}"
    detect_minikube_addons
    echo ""

    echo -e "${CYAN}Cluster Information:${NC}"
    detect_cluster_info
    echo ""

    echo -e "${CYAN}Helm Releases:${NC}"
    detect_helm_releases
    echo ""
}

# Get status object for programmatic use
get_status() {
    local py_ok=0 docker_ok=0 minikube_ok=0 kubectl_ok=0 helm_ok=0 uv_ok=0

    command -v python3 &> /dev/null && py_ok=1
    command -v docker &> /dev/null && docker_ok=1
    command -v minikube &> /dev/null && minikube_ok=1
    command -v kubectl &> /dev/null && kubectl_ok=1
    command -v helm &> /dev/null && helm_ok=1
    command -v uv &> /dev/null && uv_ok=1

    # Check if minikube is running
    local minikube_running=0
    if [ $minikube_ok -eq 1 ]; then
        minikube status 2>&1 | grep -q "Running\|running" && minikube_running=1
    fi

    echo "python=$py_ok"
    echo "docker=$docker_ok"
    echo "minikube=$minikube_ok"
    echo "minikube_running=$minikube_running"
    echo "kubectl=$kubectl_ok"
    echo "helm=$helm_ok"
    echo "uv=$uv_ok"
}

# Main
case "${1:-}" in
    "all")
        detect_all
        ;;
    "python")
        detect_python
        ;;
    "docker")
        detect_docker
        ;;
    "minikube")
        detect_minikube
        ;;
    "kubectl")
        detect_kubectl
        ;;
    "helm")
        detect_helm
        ;;
    "uv")
        detect_uv
        ;;
    "addons")
        detect_minikube_addons
        ;;
    "releases")
        detect_helm_releases
        ;;
    "cluster")
        detect_cluster_info
        ;;
    "status")
        get_status
        ;;
    *)
        echo "Usage: $0 {all|python|docker|minikube|kubectl|helm|uv|addons|releases|cluster|status}"
        echo ""
        echo "Commands:"
        echo "  all       - Full system detection report"
        echo "  python    - Detect Python version"
        echo "  docker    - Detect Docker installation"
        echo "  minikube  - Detect Minikube and status"
        echo "  kubectl   - Detect kubectl version"
        echo "  helm      - Detect Helm installation"
        echo "  uv        - Detect uv installation"
        echo "  addons    - List enabled Minikube add-ons"
        echo "  releases  - List Helm releases"
        echo "  cluster   - Show Kubernetes cluster info"
        echo "  status    - Get machine-readable status"
        exit 1
        ;;
esac
