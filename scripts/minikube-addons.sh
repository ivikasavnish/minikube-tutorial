#!/usr/bin/env bash

#############################################################################
# 🎛️  Minikube Add-ons Management Tool
#############################################################################
# Description: Manage essential Minikube add-ons:
#   - Dashboard: Web UI for Kubernetes cluster
#   - Tunnel: Access services outside cluster
#   - Registry: Local Docker image registry
#   - Metrics Server: Kubernetes resource metrics
#############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Log file setup
LOG_DIR="$HOME/.minikube_tutorial/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/addons_$(date +%Y%m%d_%H%M%S).log"

#############################################################################
# Logging Function
#############################################################################
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

#############################################################################
# Helper Functions
#############################################################################

print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║           🎛️  MINIKUBE ADD-ONS MANAGEMENT TOOL                ║"
    echo "║                                                                ║"
    echo "║    Version: 1.0.0  |  Status: Production Ready ✅              ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_minikube_status() {
    if ! minikube status > /dev/null 2>&1; then
        echo -e "${RED}✗ Minikube is not running${NC}"
        echo -e "${YELLOW}Start Minikube with:${NC} minikube start"
        log_message "ERROR" "Minikube not running"
        exit 1
    fi
    echo -e "${GREEN}✓ Minikube is running${NC}"
    log_message "INFO" "Minikube status verified"
}

list_addons() {
    echo -e "${CYAN}=== Current Add-ons Status ===${NC}"
    minikube addons list
    log_message "INFO" "Listed add-ons status"
}

#############################################################################
# Add-on Management Functions
#############################################################################

enable_dashboard() {
    echo -e "${CYAN}Enabling Minikube Dashboard...${NC}"
    log_message "INFO" "Enabling dashboard add-on"

    if minikube addons enable dashboard; then
        echo -e "${GREEN}✓ Dashboard enabled successfully${NC}"
        echo -e "${YELLOW}Access dashboard with:${NC}"
        echo -e "  ${CYAN}minikube dashboard${NC}"
        log_message "INFO" "Dashboard enabled successfully"
    else
        echo -e "${RED}✗ Failed to enable dashboard${NC}"
        log_message "ERROR" "Failed to enable dashboard"
        return 1
    fi
}

disable_dashboard() {
    echo -e "${CYAN}Disabling Minikube Dashboard...${NC}"
    log_message "INFO" "Disabling dashboard add-on"

    if minikube addons disable dashboard; then
        echo -e "${GREEN}✓ Dashboard disabled${NC}"
        log_message "INFO" "Dashboard disabled"
    else
        echo -e "${RED}✗ Failed to disable dashboard${NC}"
        log_message "ERROR" "Failed to disable dashboard"
        return 1
    fi
}

open_dashboard() {
    echo -e "${CYAN}Opening Minikube Dashboard...${NC}"
    log_message "INFO" "Opening dashboard"

    # Check if already enabled
    if ! minikube addons list | grep dashboard | grep -q enabled; then
        echo -e "${YELLOW}Dashboard not enabled. Enabling now...${NC}"
        minikube addons enable dashboard
    fi

    minikube dashboard &
    echo -e "${GREEN}✓ Dashboard opening in browser${NC}"
    log_message "INFO" "Dashboard opened"
}

enable_tunnel() {
    echo -e "${CYAN}Enabling Minikube Tunnel...${NC}"
    log_message "INFO" "Enabling tunnel add-on"

    if minikube addons enable metallb; then
        echo -e "${GREEN}✓ MetalLB (Tunnel) enabled successfully${NC}"
        echo -e "${YELLOW}Note:${NC} Run 'minikube tunnel' in separate terminal for service access"
        log_message "INFO" "Tunnel (MetalLB) enabled"
    else
        echo -e "${RED}✗ Failed to enable tunnel${NC}"
        log_message "ERROR" "Failed to enable tunnel"
        return 1
    fi
}

start_tunnel() {
    echo -e "${CYAN}Starting Minikube Tunnel (MetalLB)...${NC}"
    log_message "INFO" "Starting tunnel"

    # Check if metallb is enabled
    if ! minikube addons list | grep metallb | grep -q enabled; then
        echo -e "${YELLOW}MetalLB not enabled. Enabling now...${NC}"
        minikube addons enable metallb
    fi

    echo -e "${YELLOW}Starting tunnel... This will run in foreground.${NC}"
    echo -e "${CYAN}Press Ctrl+C to stop.${NC}"
    minikube tunnel
    log_message "INFO" "Tunnel stopped"
}

enable_registry() {
    echo -e "${CYAN}Enabling Minikube Registry...${NC}"
    log_message "INFO" "Enabling registry add-on"

    if minikube addons enable registry; then
        echo -e "${GREEN}✓ Registry enabled successfully${NC}"
        echo -e "${YELLOW}Registry is available at:${NC} localhost:5000"
        echo -e "${CYAN}Note:${NC} For remote access, use 'minikube tunnel' in another terminal"
        log_message "INFO" "Registry enabled"
    else
        echo -e "${RED}✗ Failed to enable registry${NC}"
        log_message "ERROR" "Failed to enable registry"
        return 1
    fi
}

enable_metrics_server() {
    echo -e "${CYAN}Enabling Metrics Server...${NC}"
    log_message "INFO" "Enabling metrics server add-on"

    if minikube addons enable metrics-server; then
        echo -e "${GREEN}✓ Metrics Server enabled successfully${NC}"
        echo -e "${YELLOW}Metrics will be available in ~1 minute${NC}"
        echo -e "${CYAN}View metrics with:${NC}"
        echo -e "  kubectl top nodes"
        echo -e "  kubectl top pods"
        log_message "INFO" "Metrics server enabled"
    else
        echo -e "${RED}✗ Failed to enable metrics server${NC}"
        log_message "ERROR" "Failed to enable metrics server"
        return 1
    fi
}

disable_metrics_server() {
    echo -e "${CYAN}Disabling Metrics Server...${NC}"
    log_message "INFO" "Disabling metrics server"

    if minikube addons disable metrics-server; then
        echo -e "${GREEN}✓ Metrics Server disabled${NC}"
        log_message "INFO" "Metrics server disabled"
    else
        echo -e "${RED}✗ Failed to disable metrics server${NC}"
        log_message "ERROR" "Failed to disable metrics server"
        return 1
    fi
}

view_metrics() {
    echo -e "${CYAN}=== Node Metrics ===${NC}"
    kubectl top nodes 2>/dev/null || {
        echo -e "${YELLOW}Metrics not yet available. Wait a moment and try again.${NC}"
        return 1
    }

    echo -e "\n${CYAN}=== Pod Metrics ===${NC}"
    kubectl top pods --all-namespaces 2>/dev/null || {
        echo -e "${YELLOW}No pods with metrics available${NC}"
        return 1
    }
    log_message "INFO" "Viewed metrics"
}

enable_ingress() {
    echo -e "${CYAN}Enabling Ingress Controller...${NC}"
    log_message "INFO" "Enabling ingress add-on"

    if minikube addons enable ingress; then
        echo -e "${GREEN}✓ Ingress Controller enabled successfully${NC}"
        log_message "INFO" "Ingress controller enabled"
    else
        echo -e "${RED}✗ Failed to enable ingress${NC}"
        log_message "ERROR" "Failed to enable ingress"
        return 1
    fi
}

full_setup() {
    echo -e "${CYAN}=== Full Add-ons Setup ===${NC}"
    log_message "INFO" "Starting full add-ons setup"

    check_minikube_status

    echo -e "\n${YELLOW}1. Enabling Dashboard...${NC}"
    enable_dashboard && sleep 2

    echo -e "\n${YELLOW}2. Enabling MetalLB (Tunnel)...${NC}"
    enable_tunnel && sleep 2

    echo -e "\n${YELLOW}3. Enabling Registry...${NC}"
    enable_registry && sleep 2

    echo -e "\n${YELLOW}4. Enabling Metrics Server...${NC}"
    enable_metrics_server && sleep 2

    echo -e "\n${YELLOW}5. Enabling Ingress Controller...${NC}"
    enable_ingress && sleep 2

    echo -e "\n${GREEN}✓ All add-ons setup complete!${NC}"
    list_addons
    log_message "INFO" "Full add-ons setup completed"
}

show_access_info() {
    echo -e "${CYAN}=== Add-ons Access Information ===${NC}"
    echo ""

    echo -e "${MAGENTA}Dashboard:${NC}"
    echo -e "  ${CYAN}minikube dashboard${NC}"
    echo -e "  Opens web UI in default browser"
    echo ""

    echo -e "${MAGENTA}Tunnel (Service Access):${NC}"
    echo -e "  ${CYAN}minikube tunnel${NC}"
    echo -e "  Run in separate terminal for LoadBalancer services"
    echo ""

    echo -e "${MAGENTA}Registry (Local Image Registry):${NC}"
    echo -e "  Push: ${CYAN}docker tag myimage localhost:5000/myimage${NC}"
    echo -e "  Push: ${CYAN}docker push localhost:5000/myimage${NC}"
    echo -e "  Use in YAML: ${CYAN}image: localhost:5000/myimage${NC}"
    echo ""

    echo -e "${MAGENTA}Metrics:${NC}"
    echo -e "  Nodes: ${CYAN}kubectl top nodes${NC}"
    echo -e "  Pods:  ${CYAN}kubectl top pods --all-namespaces${NC}"
    echo ""

    log_message "INFO" "Displayed access information"
}

#############################################################################
# Main Menu
#############################################################################

show_menu() {
    print_header

    echo -e "${CYAN}Check Status:${NC}"
    check_minikube_status

    echo ""
    echo -e "${MAGENTA}┌─ MAIN MENU ──────────────────────────────────────┐${NC}"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  1. 📊 List All Add-ons Status"
    echo -e "${MAGENTA}│${NC}  2. 🖥️  Enable Dashboard"
    echo -e "${MAGENTA}│${NC}  3. 🌐 Open Dashboard in Browser"
    echo -e "${MAGENTA}│${NC}  4. 🔗 Enable Tunnel (MetalLB)"
    echo -e "${MAGENTA}│${NC}  5. 🚦 Start Tunnel (foreground)"
    echo -e "${MAGENTA}│${NC}  6. 📦 Enable Registry"
    echo -e "${MAGENTA}│${NC}  7. 📈 Enable Metrics Server"
    echo -e "${MAGENTA}│${NC}  8. 📊 View Metrics"
    echo -e "${MAGENTA}│${NC}  9. 🔌 Enable Ingress Controller"
    echo -e "${MAGENTA}│${NC}  10. 🧠 Full Setup (all add-ons)"
    echo -e "${MAGENTA}│${NC}  11. ℹ️  Show Access Information"
    echo -e "${MAGENTA}│${NC}  12. 📋 View Activity Log"
    echo -e "${MAGENTA}│${NC}  0. 🚪 Exit"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}└──────────────────────────────────────────────────┘${NC}"
    echo ""
}

#############################################################################
# Main Script
#############################################################################

main() {
    # Handle command-line arguments
    if [ "$1" == "auto" ]; then
        log_message "INFO" "Running in automatic mode"
        check_minikube_status
        full_setup
        exit 0
    fi

    while true; do
        show_menu

        read -p "Select option: " choice

        case $choice in
            1)
                list_addons
                ;;
            2)
                enable_dashboard
                ;;
            3)
                open_dashboard
                ;;
            4)
                enable_tunnel
                ;;
            5)
                start_tunnel
                ;;
            6)
                enable_registry
                ;;
            7)
                enable_metrics_server
                ;;
            8)
                view_metrics
                ;;
            9)
                enable_ingress
                ;;
            10)
                full_setup
                ;;
            11)
                show_access_info
                ;;
            12)
                echo -e "${CYAN}=== Activity Log ===${NC}"
                tail -20 "$LOG_FILE"
                ;;
            0)
                echo -e "${GREEN}Goodbye!${NC}"
                log_message "INFO" "Script exited normally"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
