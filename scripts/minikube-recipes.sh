#!/usr/bin/env bash

#############################################################################
# 📋 Minikube Recipes - Ready-to-Deploy Application Templates
#############################################################################
# Description: Browse and deploy pre-configured Kubernetes recipes
#   - Simple web servers
#   - Database deployments
#   - Full-stack applications
#   - Message queues
#   - And more!
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
LOG_FILE="$LOG_DIR/recipes_$(date +%Y%m%d_%H%M%S).log"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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
    echo "║          📋 MINIKUBE RECIPES - Ready-to-Deploy Apps            ║"
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

check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}✗ kubectl not found${NC}"
        exit 1
    fi
}

open_docs() {
    local doc_url=$1
    local doc_name=$2

    echo -e "${CYAN}Opening documentation for ${doc_name}...${NC}"

    # Check if URL is a file or web URL
    if [[ "$doc_url" == http* ]]; then
        # Web URL
        if command -v xdg-open &> /dev/null; then
            xdg-open "$doc_url" &
        elif command -v open &> /dev/null; then
            open "$doc_url" &
        elif command -v start &> /dev/null; then
            start "$doc_url" &
        else
            echo -e "${YELLOW}Cannot open browser. Visit:${NC} $doc_url"
        fi
    else
        # Local file
        local file_path="$SCRIPT_DIR/$doc_url"
        if [ -f "$file_path" ]; then
            echo -e "${GREEN}Documentation file: $file_path${NC}"
            echo -e "${CYAN}Open in your editor to view${NC}"
        else
            echo -e "${YELLOW}Documentation not found: $file_path${NC}"
        fi
    fi
}

show_recipes_list() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}Available Recipes:${NC}\n"

    # Parse JSON and display recipes
    if command -v jq &> /dev/null; then
        jq -r '.recipes[] | "\(.id). \(.name) (\(.category) - \(.difficulty))\n   \(.description)"' "$SCRIPT_DIR/recipes.json"
    else
        # Fallback if jq is not available
        grep '"name"' "$SCRIPT_DIR/recipes.json" | sed 's/.*"name": "//' | sed 's/".*//' | nl
    fi

    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

deploy_recipe() {
    local recipe_id=$1

    # Parse JSON to get recipe details
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}✗ jq not found. Install jq to use recipes.${NC}"
        echo -e "${YELLOW}Install with:${NC} brew install jq  (macOS)"
        return 1
    fi

    # Get recipe by ID
    local recipe=$(jq -r ".recipes[] | select(.id == $recipe_id)" "$SCRIPT_DIR/recipes.json")

    if [ -z "$recipe" ]; then
        echo -e "${RED}✗ Recipe not found${NC}"
        return 1
    fi

    # Extract recipe details
    local name=$(echo "$recipe" | jq -r '.name')
    local yaml=$(echo "$recipe" | jq -r '.yaml')
    local yaml_path="$SCRIPT_DIR/$yaml"
    local category=$(echo "$recipe" | jq -r '.category')
    local difficulty=$(echo "$recipe" | jq -r '.difficulty')
    local time=$(echo "$recipe" | jq -r '.time')
    local access=$(echo "$recipe" | jq -r '.access')
    local docs=$(echo "$recipe" | jq -r '.docs_url')

    echo -e "\n${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}  ${CYAN}${name}${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}\n"

    echo -e "${YELLOW}Category:${NC} $category"
    echo -e "${YELLOW}Difficulty:${NC} $difficulty"
    echo -e "${YELLOW}Time:${NC} $time\n"

    echo -e "${BOLD}${YELLOW}Description:${NC}"
    echo "$recipe" | jq -r '.description'
    echo ""

    # Show credentials if present
    local credentials=$(echo "$recipe" | jq -r '.credentials // empty')
    if [ ! -z "$credentials" ]; then
        echo -e "${YELLOW}Credentials:${NC}"
        echo "$credentials" | jq -r 'to_entries[] | "  \(.key): \(.value)"'
        echo ""
    fi

    # Show ports
    local ports=$(echo "$recipe" | jq -r '.ports // empty')
    if [ ! -z "$ports" ]; then
        echo -e "${YELLOW}Services:${NC}"
        echo "$ports" | jq -r '.[] | "  \(.service): localhost:\(.local) → \(.container)/tcp"'
        echo ""
    fi

    # Check if YAML file exists
    if [ ! -f "$yaml_path" ]; then
        echo -e "${YELLOW}⚠️  YAML file not found at: $yaml_path${NC}"
        echo -e "${CYAN}Creating sample deployment...${NC}\n"
        # Option to view docs or skip
        read -p "$(echo -e ${YELLOW}Open documentation instead? \(y/n\): ${NC})" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open_docs "$docs" "$name"
        fi
        return 1
    fi

    # Ask for confirmation
    echo -e "${BOLD}${GREEN}Ready to deploy!${NC}\n"
    read -p "$(echo -e ${YELLOW}Deploy this recipe? \(y/n\): ${NC})" -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return 1
    fi

    # Deploy the recipe
    echo -e "${CYAN}Deploying...${NC}\n"
    if kubectl apply -f "$yaml_path"; then
        echo -e "\n${GREEN}✓ Recipe deployed successfully!${NC}\n"
        log_message "INFO" "Deployed recipe: $name"

        # Show access instructions
        echo -e "${MAGENTA}Access Instructions:${NC}"
        echo "$access" | while IFS= read -r line; do
            echo -e "  ${CYAN}$line${NC}"
        done

        # Ask about viewing logs or docs
        echo -e "\n${YELLOW}Next Steps:${NC}"
        read -p "$(echo -e ${YELLOW}View logs? \(y/n\): ${NC})" -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}Pod logs:${NC}"
            kubectl logs -f $(kubectl get pods -l app=$(echo "$name" | awk '{print $1}' | tr '[:upper:]' '[:lower:]') -o jsonpath='{.items[0].metadata.name}' 2>/dev/null) 2>/dev/null || echo "Logs not yet available"
        fi

        read -p "$(echo -e ${YELLOW}Open documentation? \(y/n\): ${NC})" -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open_docs "$docs" "$name"
        fi

    else
        echo -e "${RED}✗ Deployment failed${NC}"
        log_message "ERROR" "Failed to deploy recipe: $name"
        return 1
    fi
}

show_deployed_recipes() {
    echo -e "${CYAN}=== Deployed Applications ===${NC}\n"
    kubectl get deployments -A
    echo ""
    kubectl get statefulsets -A
    echo ""
    kubectl get services -A
    log_message "INFO" "Listed deployed applications"
}

delete_recipe() {
    local recipe_id=$1

    if ! command -v jq &> /dev/null; then
        echo -e "${RED}✗ jq not found${NC}"
        return 1
    fi

    local recipe=$(jq -r ".recipes[] | select(.id == $recipe_id)" "$SCRIPT_DIR/recipes.json")
    local name=$(echo "$recipe" | jq -r '.name')
    local yaml=$(echo "$recipe" | jq -r '.yaml')
    local yaml_path="$SCRIPT_DIR/$yaml"

    if [ ! -f "$yaml_path" ]; then
        echo -e "${RED}✗ YAML file not found${NC}"
        return 1
    fi

    echo -e "${YELLOW}Deleting: $name${NC}\n"
    read -p "$(echo -e ${RED}Are you sure? This will delete all resources. \(y/n\): ${NC})" -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if kubectl delete -f "$yaml_path"; then
            echo -e "${GREEN}✓ Recipe deleted${NC}"
            log_message "INFO" "Deleted recipe: $name"
        else
            echo -e "${RED}✗ Failed to delete recipe${NC}"
            log_message "ERROR" "Failed to delete recipe: $name"
        fi
    else
        echo -e "${YELLOW}Cancelled.${NC}"
    fi
}

#############################################################################
# Main Menu
#############################################################################

show_menu() {
    print_header

    echo -e "${CYAN}Checking prerequisites...${NC}"
    check_minikube_status
    check_kubectl

    echo ""
    echo -e "${MAGENTA}┌─ MAIN MENU ──────────────────────────────────────┐${NC}"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  📋 RECIPES AVAILABLE:"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  1. 🌐 Web Server (Nginx)"
    echo -e "${MAGENTA}│${NC}  2. 🗄️  PostgreSQL Database"
    echo -e "${MAGENTA}│${NC}  3. 📄 MongoDB Database"
    echo -e "${MAGENTA}│${NC}  4. ⚡ Redis Cache"
    echo -e "${MAGENTA}│${NC}  5. 🏗️  Multi-Tier Application"
    echo -e "${MAGENTA}│${NC}  6. 📬 RabbitMQ Message Queue"
    echo -e "${MAGENTA}│${NC}  7. 📊 App with Logging"
    echo -e "${MAGENTA}│${NC}  8. 🔗 App with Tracing"
    echo -e "${MAGENTA}│${NC}  9. 🧪 Load Testing App"
    echo -e "${MAGENTA}│${NC}  10. 💾 Redis Cluster (StatefulSet)"
    echo -e "${MAGENTA}│${NC}  11. 🔧 Jenkins CI/CD"
    echo -e "${MAGENTA}│${NC}  12. 🚪 Kong API Gateway"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  UTILITIES:"
    echo -e "${MAGENTA}│${NC}  L. 📋 List All Recipes"
    echo -e "${MAGENTA}│${NC}  D. 👀 Show Deployed Apps"
    echo -e "${MAGENTA}│${NC}  0. 🚪 Exit"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}└──────────────────────────────────────────────────┘${NC}"
    echo ""
}

#############################################################################
# Main Script
#############################################################################

main() {
    while true; do
        show_menu

        read -p "Select recipe or option: " choice

        case $choice in
            1)  deploy_recipe 1 ;;
            2)  deploy_recipe 2 ;;
            3)  deploy_recipe 3 ;;
            4)  deploy_recipe 4 ;;
            5)  deploy_recipe 5 ;;
            6)  deploy_recipe 6 ;;
            7)  deploy_recipe 7 ;;
            8)  deploy_recipe 8 ;;
            9)  deploy_recipe 9 ;;
            10) deploy_recipe 10 ;;
            11) deploy_recipe 11 ;;
            12) deploy_recipe 12 ;;
            l|L)
                show_recipes_list
                ;;
            d|D)
                show_deployed_recipes
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
