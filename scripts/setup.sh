#!/usr/bin/env bash

################################################################################
#                                                                              #
#  🚀 Minikube Tutorial Setup Script                                         #
#  - Detects Python installation                                             #
#  - Installs uv package manager                                             #
#  - Creates virtual environment                                             #
#  - Detects system components (Minikube, Docker, kubectl, Helm)             #
#  - Activates venv and runs tutorial                                        #
#  - Skips completed steps automatically                                     #
#                                                                              #
################################################################################

set -e

# Source detection module
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/detect.sh" 2>/dev/null || true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="${PROJECT_DIR}/.venv"
SETUP_STATE_FILE="${PROJECT_DIR}/.setup_state"
UV_CACHE="${PROJECT_DIR}/.uv_cache"

# Logging functions
log_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
}

log_step() {
    echo -e "${CYAN}→${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_skip() {
    echo -e "${YELLOW}⊘${NC} $1 (skipping)"
}

log_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# State management functions
get_step_status() {
    local step=$1
    if [ -f "$SETUP_STATE_FILE" ]; then
        grep -q "^${step}=" "$SETUP_STATE_FILE" && echo "done" || echo "pending"
    else
        echo "pending"
    fi
}

mark_step_done() {
    local step=$1
    mkdir -p "$(dirname "$SETUP_STATE_FILE")"
    if grep -q "^${step}=" "$SETUP_STATE_FILE" 2>/dev/null; then
        sed -i '' "s/^${step}=.*/${step}=done/" "$SETUP_STATE_FILE"
    else
        echo "${step}=done" >> "$SETUP_STATE_FILE"
    fi
}

# Step 1: Check Python
check_python() {
    log_step "Checking Python installation..."

    if get_step_status "python_check" | grep -q "done"; then
        log_skip "Python already checked"
        return 0
    fi

    if command -v python3 &> /dev/null; then
        local python_version=$(python3 --version 2>&1 | awk '{print $2}')
        log_success "Python ${python_version} is installed"
        mark_step_done "python_check"
        return 0
    fi

    log_error "Python 3 is not installed"
    echo ""
    echo -e "${YELLOW}Please install Python 3:${NC}"
    echo "  macOS:  brew install python3"
    echo "  Linux:  apt-get install python3 python3-venv"
    echo "  Windows: Download from https://www.python.org/downloads/"
    exit 1
}

# Step 2: Install uv
install_uv() {
    log_step "Setting up uv package manager..."

    if get_step_status "uv_install" | grep -q "done"; then
        log_skip "uv already installed"
        return 0
    fi

    if command -v uv &> /dev/null; then
        local uv_version=$(uv --version 2>&1 | awk '{print $2}')
        log_success "uv ${uv_version} is already installed"
        mark_step_done "uv_install"
        return 0
    fi

    echo "Installing uv package manager..."

    if command -v curl &> /dev/null; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        mark_step_done "uv_install"
        log_success "uv installed successfully"
    else
        log_error "curl not found. Installing uv via pip..."
        python3 -m pip install --user uv
        mark_step_done "uv_install"
        log_success "uv installed via pip"
    fi

    # Add uv to PATH for this session
    if [ -d "$HOME/.local/bin" ]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

# Step 3: Create virtual environment
create_venv() {
    log_step "Creating virtual environment..."

    if get_step_status "venv_create" | grep -q "done"; then
        if [ -d "$VENV_DIR" ] && [ -f "$VENV_DIR/bin/activate" ]; then
            log_skip "Virtual environment already exists"
            return 0
        else
            log_info "Virtual environment marked as done but directory missing. Recreating..."
        fi
    fi

    if [ -d "$VENV_DIR" ]; then
        log_skip "Virtual environment already exists at ${VENV_DIR}"
        mark_step_done "venv_create"
        return 0
    fi

    echo "Creating virtual environment at ${VENV_DIR}..."

    if command -v uv &> /dev/null; then
        uv venv "$VENV_DIR" --python python3
    else
        python3 -m venv "$VENV_DIR"
    fi

    mark_step_done "venv_create"
    log_success "Virtual environment created"
}

# Step 4: Install requirements
install_requirements() {
    log_step "Installing Python dependencies..."

    if get_step_status "requirements_install" | grep -q "done"; then
        log_skip "Dependencies already installed"
        return 0
    fi

    if [ ! -f "$PROJECT_DIR/requirements.txt" ]; then
        log_info "No requirements.txt found. Skipping..."
        mark_step_done "requirements_install"
        return 0
    fi

    # Source the activate script
    source "$VENV_DIR/bin/activate"

    echo "Installing dependencies from requirements.txt..."

    if command -v uv &> /dev/null; then
        uv pip install -r "$PROJECT_DIR/requirements.txt"
    else
        pip install -r "$PROJECT_DIR/requirements.txt"
    fi

    mark_step_done "requirements_install"
    log_success "Dependencies installed"
}

# Step 5: Show status
show_status() {
    log_header "Setup Status"

    echo ""
    echo "Completed steps:"
    [ "$(get_step_status 'python_check')" = "done" ] && echo -e "  ${GREEN}✓${NC} Python detected" || echo -e "  ${RED}✗${NC} Python not detected"
    [ "$(get_step_status 'uv_install')" = "done" ] && echo -e "  ${GREEN}✓${NC} uv installed" || echo -e "  ${RED}✗${NC} uv not installed"
    [ "$(get_step_status 'venv_create')" = "done" ] && echo -e "  ${GREEN}✓${NC} Virtual environment created" || echo -e "  ${RED}✗${NC} Virtual environment not created"
    [ "$(get_step_status 'requirements_install')" = "done" ] && echo -e "  ${GREEN}✓${NC} Dependencies installed" || echo -e "  ${RED}✗${NC} Dependencies not installed"

    echo ""
    echo "Virtual environment:"
    [ -d "$VENV_DIR" ] && echo -e "  ${GREEN}✓${NC} Location: ${VENV_DIR}" || echo -e "  ${RED}✗${NC} Location: ${VENV_DIR} (not found)"

    echo ""
    echo "To manually activate environment:"
    echo "  source ${VENV_DIR}/bin/activate"
    echo ""

    # Show system detection
    echo ""
    log_header "System Components Detection"
    echo ""
    bash "$SCRIPT_DIR/detect.sh" all 2>/dev/null || echo "Detection module not available"
}

# Reset setup state
reset_setup() {
    if [ -f "$SETUP_STATE_FILE" ]; then
        rm -f "$SETUP_STATE_FILE"
        log_success "Setup state reset. Next run will redo all steps."
    else
        log_info "No setup state to reset."
    fi
}

# Main setup function
run_setup() {
    log_header "🚀 Minikube Tutorial Setup"

    echo ""
    echo "This script will:"
    echo "  1. Check Python installation"
    echo "  2. Install uv package manager (if needed)"
    echo "  3. Create a virtual environment (if needed)"
    echo "  4. Install Python dependencies (if needed)"
    echo "  5. Detect system components (Minikube, Docker, kubectl, Helm)"
    echo "  6. Launch the tutorial in the virtual environment"
    echo ""

    # Run setup steps
    check_python
    install_uv
    create_venv
    install_requirements

    echo ""
    show_status

    # Activate virtual environment and run tutorial
    log_step "Launching Minikube Tutorial..."
    echo ""

    source "$VENV_DIR/bin/activate"
    cd "$PROJECT_DIR"

    python3 minikube_tutorial.py
}

# Parse arguments
case "${1:-}" in
    "setup")
        run_setup
        ;;
    "status")
        show_status
        ;;
    "reset")
        reset_setup
        ;;
    "activate")
        source "$VENV_DIR/bin/activate"
        log_success "Virtual environment activated"
        echo "You can now run: python3 minikube_tutorial.py"
        exec bash
        ;;
    "shell")
        # New interactive shell with venv activated
        source "$VENV_DIR/bin/activate"
        exec bash
        ;;
    *)
        echo "Usage: $0 {setup|status|reset|activate|shell}"
        echo ""
        echo "Commands:"
        echo "  setup     - Run full setup (default)"
        echo "  status    - Show setup status"
        echo "  reset     - Reset setup state and redo on next run"
        echo "  activate  - Activate venv and return to shell"
        echo "  shell     - Launch new shell with venv activated"
        echo ""
        echo "Examples:"
        echo "  $0 setup              # Run setup and launch tutorial"
        echo "  $0 status             # Check what's been done"
        echo "  $0 reset              # Reset and start over"
        echo "  source $0 activate    # Activate venv in current shell"
        exit 1
        ;;
esac
