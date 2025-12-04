.PHONY: setup setup-status setup-reset detect tutorial install recipes addons helm verify help clean docker-to-k8s dashboard logs pods services deployments status start stop delete check version

# Variables
PYTHON := python3
SHELL_DIR := ./scripts
PROJECT_DIR := $(shell pwd)

# Default target
.DEFAULT_GOAL := help

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)╔═══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║         🚀 Minikube Tutorial - Available Commands             ║$(NC)"
	@echo "$(BLUE)╚═══════════════════════════════════════════════════════════════╝$(NC)\n"
	@echo "$(GREEN)Getting Started (First Time):$(NC)"
	@echo "  make setup             - Setup Python/uv/venv and launch tutorial"
	@echo "  make setup-status      - Show setup progress"
	@echo "  make setup-reset       - Reset setup and redo on next run"
	@echo "  make detect            - Show system components detection report"
	@echo ""
	@echo "$(GREEN)Getting Started (After Setup):$(NC)"
	@echo "  make tutorial          - Launch interactive Minikube tutorial (full menu)"
	@echo "  make install           - Launch installer (select Option 2 in menu)"
	@echo ""
	@echo "$(GREEN)Deployment & Management:$(NC)"
	@echo "  make recipes           - Browse and deploy recipes (12 apps)"
	@echo "  make addons            - Manage Minikube add-ons"
	@echo "  make helm              - Install Helm packages"
	@echo "  make docker-to-k8s     - Convert Docker Compose to Kubernetes"
	@echo ""
	@echo "$(GREEN)Cluster Management:$(NC)"
	@echo "  make verify            - Verify installation"
	@echo "  make dashboard         - Open Kubernetes dashboard"
	@echo "  make logs              - View tutorial logs"
	@echo "  make status            - Check Minikube status"
	@echo "  make start             - Start Minikube cluster"
	@echo "  make stop              - Stop Minikube cluster"
	@echo "  make delete            - Delete Minikube cluster"
	@echo ""
	@echo "$(GREEN)Quick Commands:$(NC)"
	@echo "  make pods              - List all pods"
	@echo "  make services          - List all services"
	@echo "  make deployments       - List all deployments"
	@echo "  make check             - Run system check"
	@echo ""
	@echo "$(GREEN)Help & Information:$(NC)"
	@echo "  make help              - Show this help message"
	@echo "  make version           - Show version information"
	@echo "  make clean             - Clean logs and temporary files"
	@echo ""

# ╔════════════════════════════════════════════════════════════╗
# ║                   MAIN ENTRY POINTS                        ║
# ╚════════════════════════════════════════════════════════════╝

setup:
	@echo "$(BLUE)🔧 Setting up environment...$(NC)\n"
	@bash $(SHELL_DIR)/setup.sh setup

setup-status:
	@echo "$(BLUE)📊 Setup Status$(NC)\n"
	@bash $(SHELL_DIR)/setup.sh status

setup-reset:
	@echo "$(YELLOW)🔄 Resetting setup...$(NC)\n"
	@bash $(SHELL_DIR)/setup.sh reset
	@echo ""
	@echo "$(GREEN)✓ Setup reset complete. Run 'make setup' to redo setup.$(NC)"

detect:
	@echo "$(BLUE)🔍 System Detection Report$(NC)\n"
	@bash $(SHELL_DIR)/detect.sh all

tutorial:
	@echo "$(BLUE)📚 Launching Minikube Interactive Tutorial...$(NC)\n"
	@cd $(PROJECT_DIR) && $(PYTHON) minikube_tutorial.py

install:
	@echo "$(BLUE)🔧 Guided Installation${NC}\n"
	@echo "Starting interactive installation..."
	@echo "$(YELLOW)Note: Choose Option 2 (Installation Guide) from the menu${NC}\n"
	@cd $(PROJECT_DIR) && $(PYTHON) minikube_tutorial.py

recipes:
	@echo "$(BLUE)📋 Launching Recipe Installer...$(NC)\n"
	@bash $(SHELL_DIR)/minikube-recipes.sh

addons:
	@echo "$(BLUE)🎛️  Managing Minikube Add-ons...$(NC)\n"
	@bash $(SHELL_DIR)/minikube-addons.sh

helm:
	@echo "$(BLUE)📦 Installing Helm Packages...$(NC)\n"
	@bash $(SHELL_DIR)/helm-packages.sh

docker-to-k8s:
	@echo "$(BLUE)🐳 Converting Docker Compose to Kubernetes...$(NC)\n"
	@bash $(SHELL_DIR)/docker-to-minikube.sh

# ╔════════════════════════════════════════════════════════════╗
# ║                   VERIFICATION & CHECKS                    ║
# ╚════════════════════════════════════════════════════════════╝

verify:
	@echo "$(BLUE)✅ Verifying Installation...$(NC)\n"
	@bash $(SHELL_DIR)/check-system.sh

check:
	@echo "$(BLUE)🔍 Running System Check...$(NC)\n"
	@bash $(SHELL_DIR)/system-check-advanced.sh

version:
	@echo "$(BLUE)ℹ️  Version Information$(NC)\n"
	@echo "$(BOLD)Minikube Tutorial:$(NC) v1.0.0+"
	@echo "$(BOLD)Recipe System:$(NC) 12 production-ready templates"
	@echo "$(BOLD)Features:$(NC) Interactive deployment, Make commands, Cross-platform\n"
	@echo "For full version info, run: make tutorial (select Option 9)"

# ╔════════════════════════════════════════════════════════════╗
# ║              MINIKUBE CLUSTER MANAGEMENT                   ║
# ╚════════════════════════════════════════════════════════════╝

status:
	@echo "$(BLUE)📊 Minikube Status:$(NC)\n"
	@minikube status

start:
	@echo "$(GREEN)▶️  Starting Minikube cluster...$(NC)\n"
	@minikube start --driver=docker

stop:
	@echo "$(YELLOW)⏹️  Stopping Minikube cluster...$(NC)\n"
	@minikube stop

delete:
	@echo "$(RED)🗑️  Deleting Minikube cluster...$(NC)\n"
	@minikube delete

dashboard:
	@echo "$(BLUE)🖥️  Opening Kubernetes Dashboard...$(NC)\n"
	@minikube dashboard

# ╔════════════════════════════════════════════════════════════╗
# ║               KUBERNETES RESOURCES                         ║
# ╚════════════════════════════════════════════════════════════╝

pods:
	@echo "$(BLUE)📦 Listing Pods:$(NC)\n"
	@kubectl get pods -A

services:
	@echo "$(BLUE)🔌 Listing Services:$(NC)\n"
	@kubectl get services -A

deployments:
	@echo "$(BLUE)🚀 Listing Deployments:$(NC)\n"
	@kubectl get deployments -A

logs:
	@echo "$(BLUE)📝 Tutorial Logs Directory:$(NC)\n"
	@ls -lh ~/.minikube_tutorial/logs/ 2>/dev/null || echo "No logs found yet"
	@echo ""
	@echo "$(BLUE)Recent logs:$(NC)"
	@ls -lt ~/.minikube_tutorial/logs/*.log 2>/dev/null | head -5 || echo "No log files found"

# ╔════════════════════════════════════════════════════════════╗
# ║                    UTILITIES                               ║
# ╚════════════════════════════════════════════════════════════╝

clean:
	@echo "$(YELLOW)🧹 Cleaning temporary files...$(NC)\n"
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@echo "$(GREEN)✓ Cleaned.$(NC)\n"

# Display info on make invocation
.SILENT: help
