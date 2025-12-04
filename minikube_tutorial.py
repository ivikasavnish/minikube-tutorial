#!/usr/bin/env python3
"""
🚀 Minikube Interactive Tutorial
A beginner-friendly guide to deploying applications with Minikube as an alternative to Docker/Docker Compose
Version: 1.0.0
"""

import os
import sys
import subprocess
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple
import time

# Setup logging
LOG_DIR = Path.home() / ".minikube_tutorial" / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_DIR / f"tutorial_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Color codes for terminal output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class MinikubeTutorial:
    """Main tutorial class managing the interactive experience"""

    VERSION = "1.0.0"
    TUTORIAL_DIR = Path.home() / ".minikube_tutorial"

    def __init__(self):
        self.tutorial_dir = self.TUTORIAL_DIR
        self.tutorial_dir.mkdir(parents=True, exist_ok=True)
        self.config_file = self.tutorial_dir / "config.json"
        self.config = self._load_config()
        logger.info(f"Tutorial initialized. Version: {self.VERSION}")

    def _load_config(self) -> Dict:
        """Load or create configuration"""
        if self.config_file.exists():
            with open(self.config_file) as f:
                return json.load(f)
        return {
            "completed_sections": [],
            "minikube_installed": False,
            "docker_installed": False,
            "kvm_configured": False,
            "tutorial_version": self.VERSION
        }

    def _save_config(self):
        """Save configuration to file"""
        with open(self.config_file, 'w') as f:
            json.dump(self.config, f, indent=2)

    def print_header(self):
        """Print beautiful header"""
        header = f"""
{Colors.OKBLUE}╔═══════════════════════════════════════════════════════════════╗
║  🚀  MINIKUBE INTERACTIVE TUTORIAL - v{self.VERSION:<37}║
║  Deploy applications as an alternative to Docker/Docker Compose  ║
╚═══════════════════════════════════════════════════════════════╝{Colors.ENDC}
"""
        print(header)

    def print_menu(self):
        """Display main menu"""
        self.print_header()
        print(f"{Colors.BOLD}📋 MAIN MENU{Colors.ENDC}\n")
        print("1. 📖 Introduction - What is Minikube?")
        print("2. 🔧 Full Installation Guide (Docker, Minikube, kubectl)")
        print("3. 🐳 Install Minikube Only (Quick Setup)")
        print("4. ⚙️  Configure KVM (Linux)")
        print("5. 🎯 Deploy Sample Application")
        print("6. 📊 Setup Logging")
        print("7. 🔍 Setup Distributed Tracing")
        print("8. ✅ Verify Installation")
        print("9. 📝 View Logs")
        print("10. ℹ️  Version & System Info")
        print("11. 🎛️  Manage Minikube Add-ons (Dashboard, Registry, Metrics)")
        print("12. 📦 Install Helm Packages (20+ Development & Analytics Tools)")
        print("13. 📋 Browse & Deploy Recipes (12 Ready-to-Use Apps)")
        print("0. 🚪 Exit\n")

    def print_section_header(self, title: str, emoji: str = ""):
        """Print section header"""
        header = f"\n{Colors.OKCYAN}{Colors.BOLD}{emoji} {title}{Colors.ENDC}"
        print(header)
        print(Colors.OKCYAN + "─" * 70 + Colors.ENDC)

    def run_command(self, cmd: List[str], description: str = "") -> Tuple[bool, str]:
        """Execute command and return result"""
        if description:
            logger.info(f"Running: {description}")
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                logger.info(f"✅ {description}")
                return True, result.stdout
            else:
                logger.warning(f"❌ {description}: {result.stderr}")
                return False, result.stderr
        except subprocess.TimeoutExpired:
            logger.error(f"⏱️  Command timeout: {description}")
            return False, "Command timeout"
        except Exception as e:
            logger.error(f"❌ Error executing command: {str(e)}")
            return False, str(e)

    def section_introduction(self):
        """Interactive introduction section"""
        self.print_section_header("Introduction to Minikube", "📖")

        intro_text = """
{header}What is Minikube?{endc}
Minikube is a local Kubernetes cluster that runs on your machine. Instead of using
Docker/Docker Compose for simple applications, Minikube provides a complete Kubernetes
experience with:

{bold}Key Benefits:{endc}
  ✓ Run Kubernetes locally without needing a cloud account
  ✓ Perfect for learning and development
  ✓ Supports multiple container runtimes (Docker, containerd, CRI-O)
  ✓ Built-in add-ons for monitoring, ingress, and dashboards
  ✓ Cross-platform (macOS, Linux, Windows)

{header}When to Use Minikube vs Docker Compose:{endc}

{bold}Use Docker Compose when:{endc}
  • Running simple multi-container applications
  • Quick local development
  • No need for orchestration or scaling

{bold}Use Minikube when:{endc}
  • Learning Kubernetes
  • Testing Kubernetes configurations
  • Need load balancing, service discovery
  • Practice microservices architecture
  • Deploy multiple replicated services

{header}Kubernetes Components (explained simply):{endc}

  🔹 Pod: Smallest deployable unit (usually 1 container per pod)
  🔹 Service: Exposes pods internally or externally
  🔹 Deployment: Manages pod replicas
  🔹 ConfigMap: Store configuration data
  🔹 StatefulSet: For stateful applications (databases)
  🔹 Ingress: Route external traffic to services

{header}System Requirements:{endc}
  • 2 CPU cores minimum (4 recommended)
  • 4GB RAM minimum (8GB recommended)
  • 20GB free disk space
  • Docker, VirtualBox, KVM, or Hyper-V
""".format(
    header=f"{Colors.BOLD}{Colors.OKGREEN}",
    bold=f"{Colors.BOLD}",
    endc=Colors.ENDC
)
        print(intro_text)

        self.config["completed_sections"].append("introduction")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_installation(self):
        """Guided installation with interactive steps"""
        self.print_section_header("Guided Installation", "🔧")

        system = self._detect_os()

        print(f"\n{Colors.BOLD}{Colors.OKGREEN}✓ Detected OS: {system}{Colors.ENDC}\n")

        # Step 1: Check Docker
        print("1️⃣  {Colors.BOLD}Docker Installation{Colors.ENDC}".format(Colors=Colors))
        success, output = self.run_command(["docker", "--version"], "Checking Docker")

        if success:
            print(f"{Colors.OKGREEN}✓ Docker is already installed: {output.strip()}{Colors.ENDC}\n")
        else:
            print(f"{Colors.WARNING}⚠️  Docker is not installed{Colors.ENDC}")
            print(f"\n{Colors.BOLD}Installation Instructions:{Colors.ENDC}\n")

            if system == "Darwin":
                docker_instructions = """
{bold}macOS - Docker Desktop:{endc}
1. Download from: https://www.docker.com/products/docker-desktop
2. Double-click the .dmg file
3. Drag Docker.app to Applications folder
4. Launch Docker from Applications
5. Allow privileged helper installation when prompted
6. Verify: docker --version
""".format(bold=Colors.BOLD, endc=Colors.ENDC)
            elif system == "Linux":
                docker_instructions = """
{bold}Linux - Docker Installation:{endc}
{code}
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
{endc}
6. Verify: docker --version
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)
            else:
                docker_instructions = """
{bold}Windows - Docker Desktop:{endc}
1. Download from: https://www.docker.com/products/docker-desktop
2. Run the installer
3. Enable WSL 2 backend when prompted
4. Restart your computer
5. Verify: docker --version
""".format(bold=Colors.BOLD, endc=Colors.ENDC)

            print(docker_instructions)
            install_docker = input(f"\n{Colors.BOLD}Have you installed Docker? (y/n): {Colors.ENDC}").lower()

            if install_docker == 'y':
                success, output = self.run_command(["docker", "--version"], "Verifying Docker")
                if success:
                    print(f"{Colors.OKGREEN}✓ Docker verified: {output.strip()}{Colors.ENDC}\n")
                else:
                    print(f"{Colors.FAIL}❌ Docker verification failed. Please install Docker first.{Colors.ENDC}\n")
                    input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                    return
            else:
                print(f"{Colors.WARNING}⚠️  Please install Docker first before continuing.{Colors.ENDC}\n")
                input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                return

        # Step 2: Check Minikube
        print("\n2️⃣  {Colors.BOLD}Minikube Installation{Colors.ENDC}".format(Colors=Colors))
        success, output = self.run_command(["minikube", "version"], "Checking Minikube")

        if success:
            print(f"{Colors.OKGREEN}✓ Minikube is already installed: {output.strip()}{Colors.ENDC}\n")
        else:
            print(f"{Colors.WARNING}⚠️  Minikube is not installed{Colors.ENDC}")
            print(f"\n{Colors.BOLD}Installation Instructions:{Colors.ENDC}\n")

            if system == "Darwin":
                minikube_instructions = """
{bold}macOS - Minikube Installation:{endc}

{bold}Option 1: Using Homebrew (recommended):{endc}
{code}
brew install minikube
{endc}

{bold}Option 2: Direct download:{endc}
{code}
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
{endc}

Verify: minikube version
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)
            elif system == "Linux":
                minikube_instructions = """
{bold}Linux - Minikube Installation:{endc}

{bold}For Intel/AMD x86_64:{endc}
{code}
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
{endc}

{bold}For ARM64:{endc}
{code}
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
{endc}

Verify: minikube version
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)
            else:
                minikube_instructions = """
{bold}Windows - Minikube Installation:{endc}

{bold}Option 1: Using Chocolatey:{endc}
{code}
choco install minikube
{endc}

{bold}Option 2: Direct download:{endc}
Download from: https://github.com/kubernetes/minikube/releases
Add to PATH

Verify: minikube version
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)

            print(minikube_instructions)
            install_minikube = input(f"\n{Colors.BOLD}Have you installed Minikube? (y/n): {Colors.ENDC}").lower()

            if install_minikube == 'y':
                success, output = self.run_command(["minikube", "version"], "Verifying Minikube")
                if success:
                    print(f"{Colors.OKGREEN}✓ Minikube verified: {output.strip()}{Colors.ENDC}\n")
                else:
                    print(f"{Colors.FAIL}❌ Minikube verification failed. Please install Minikube first.{Colors.ENDC}\n")
                    input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                    return
            else:
                print(f"{Colors.WARNING}⚠️  Please install Minikube first before continuing.{Colors.ENDC}\n")
                input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                return

        # Step 3: Check kubectl
        print("3️⃣  {Colors.BOLD}kubectl (Kubernetes CLI) Installation{Colors.ENDC}".format(Colors=Colors))
        success, output = self.run_command(["kubectl", "version", "--client"], "Checking kubectl")

        if success:
            print(f"{Colors.OKGREEN}✓ kubectl is already installed{Colors.ENDC}\n")
        else:
            print(f"{Colors.WARNING}⚠️  kubectl is not installed{Colors.ENDC}")
            print(f"\n{Colors.BOLD}Installation Instructions:{Colors.ENDC}\n")

            if system == "Darwin":
                kubectl_instructions = """
{bold}macOS - kubectl Installation:{endc}

{bold}Option 1: Using Homebrew (recommended):{endc}
{code}
brew install kubectl
{endc}

{bold}Option 2: Direct download:{endc}
{code}
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
{endc}

Verify: kubectl version --client
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)
            elif system == "Linux":
                kubectl_instructions = """
{bold}Linux - kubectl Installation:{endc}

{bold}For Intel/AMD x86_64:{endc}
{code}
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
{endc}

{bold}For ARM64:{endc}
{code}
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
{endc}

Verify: kubectl version --client
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)
            else:
                kubectl_instructions = """
{bold}Windows - kubectl Installation:{endc}

{bold}Option 1: Using Chocolatey:{endc}
{code}
choco install kubernetes-cli
{endc}

{bold}Option 2: Download from:{endc}
https://kubernetes.io/docs/tasks/tools/

Add to PATH
Verify: kubectl version --client
""".format(bold=Colors.BOLD, code=Colors.OKGREEN, endc=Colors.ENDC)

            print(kubectl_instructions)
            install_kubectl = input(f"\n{Colors.BOLD}Have you installed kubectl? (y/n): {Colors.ENDC}").lower()

            if install_kubectl == 'y':
                success, output = self.run_command(["kubectl", "version", "--client"], "Verifying kubectl")
                if success:
                    print(f"{Colors.OKGREEN}✓ kubectl verified{Colors.ENDC}\n")
                else:
                    print(f"{Colors.FAIL}❌ kubectl verification failed.{Colors.ENDC}\n")
                    input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                    return
            else:
                print(f"{Colors.WARNING}⚠️  Please install kubectl first.{Colors.ENDC}\n")
                input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                return

        # Step 4: Start Minikube
        print("\n4️⃣  {Colors.BOLD}Start Minikube{Colors.ENDC}".format(Colors=Colors))
        success, output = self.run_command(["minikube", "status"], "Checking Minikube status")

        if success:
            print(f"{Colors.OKGREEN}✓ Minikube is already running{Colors.ENDC}\n")
        else:
            print(f"{Colors.WARNING}⚠️  Minikube is not running{Colors.ENDC}")
            print(f"\n{Colors.BOLD}Starting Minikube...{Colors.ENDC}\n")

            start_choice = input(f"{Colors.BOLD}Start Minikube now? (y/n): {Colors.ENDC}").lower()

            if start_choice == 'y':
                if system == "Linux":
                    driver_choice = input(f"\n{Colors.BOLD}Which driver to use? (1=docker, 2=kvm2): {Colors.ENDC}").strip()
                    driver = "kvm2" if driver_choice == "2" else "docker"
                    print(f"\nStarting with {driver} driver...\n")
                    self.run_command(["minikube", "start", f"--driver={driver}", "--cpus=4", "--memory=8192"],
                                   "Starting Minikube with KVM2")
                else:
                    print(f"\nStarting with docker driver...\n")
                    self.run_command(["minikube", "start", "--driver=docker"], "Starting Minikube")

                time.sleep(2)
                success, _ = self.run_command(["minikube", "status"], "Verifying Minikube")
                if success:
                    print(f"\n{Colors.OKGREEN}✓ Minikube started successfully!{Colors.ENDC}\n")
                else:
                    print(f"\n{Colors.FAIL}❌ Failed to start Minikube. Check your system configuration.{Colors.ENDC}\n")

        # Final summary
        print(f"""
{Colors.OKGREEN}{Colors.BOLD}✓ Installation Complete!{Colors.ENDC}

{Colors.BOLD}Next Steps:{Colors.ENDC}
1. Verify everything is working: minikube status
2. Deploy an app: kubectl create deployment hello --image=nginx
3. Access dashboard: minikube dashboard
4. Or continue with the tutorial!

{Colors.BOLD}Useful Commands:{Colors.ENDC}
  minikube start         # Start cluster
  minikube stop          # Stop cluster
  minikube delete        # Delete cluster
  kubectl get pods       # List pods
  minikube dashboard     # Open dashboard
""")

        self.config["completed_sections"].append("installation")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_minikube_install(self):
        """Quick Minikube-only installation"""
        self.print_section_header("Install Minikube (Quick Setup)", "🐳")

        system = self._detect_os()

        print(f"\n{Colors.BOLD}{Colors.OKGREEN}✓ Detected OS: {system}{Colors.ENDC}\n")

        # Check if Minikube is already installed
        print(f"{Colors.BOLD}Checking if Minikube is already installed...{Colors.ENDC}\n")
        success, output = self.run_command(["minikube", "version"], "Checking Minikube")

        if success:
            version = output.strip().split('\n')[0]
            print(f"{Colors.OKGREEN}✓ Minikube is already installed: {version}{Colors.ENDC}\n")

            # Check status
            success, status = self.run_command(["minikube", "status"], "Checking Minikube status")
            if success:
                if "Running" in status or "running" in status:
                    print(f"{Colors.OKGREEN}✓ Minikube is running!{Colors.ENDC}\n")
                else:
                    print(f"{Colors.WARNING}⚠️  Minikube is installed but not running.{Colors.ENDC}")
                    start = input(f"\n{Colors.BOLD}Start Minikube now? (y/n): {Colors.ENDC}").lower()
                    if start == 'y':
                        print(f"\n{Colors.OKCYAN}Starting Minikube...{Colors.ENDC}\n")
                        self.run_command(["minikube", "start", "--driver=docker"], "Starting Minikube")

            input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
            return

        # Minikube not installed - show installation instructions
        print(f"{Colors.WARNING}⚠️  Minikube is not installed{Colors.ENDC}\n")
        print(f"{Colors.BOLD}Installation Instructions:{Colors.ENDC}\n")

        if system == "macOS":
            instructions = f"""
{Colors.BOLD}macOS - Install via Homebrew (Recommended):{Colors.ENDC}

{Colors.OKGREEN}
# Install Minikube
brew install minikube

# Install kubectl (if not already installed)
brew install kubectl

# Verify installation
minikube version
kubectl version --client
{Colors.ENDC}

{Colors.BOLD}Or download manually:{Colors.ENDC}
  1. Visit: https://minikube.sigs.k8s.io/docs/start/
  2. Download the macOS binary
  3. Move to /usr/local/bin: sudo mv minikube /usr/local/bin/
  4. Verify: minikube version
"""
        elif system == "Linux":
            instructions = f"""
{Colors.BOLD}Linux - Install via Package Manager:{Colors.ENDC}

{Colors.BOLD}Option 1: Using curl (Universal):{Colors.ENDC}
{Colors.OKGREEN}
# Download latest release
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify
minikube version
kubectl version --client
{Colors.ENDC}

{Colors.BOLD}Option 2: Using apt (Ubuntu/Debian):{Colors.ENDC}
{Colors.OKGREEN}
sudo apt-get update
sudo apt-get install -y curl
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
{Colors.ENDC}

{Colors.BOLD}Choose driver (for Linux):{Colors.ENDC}
  • {Colors.OKGREEN}Docker (Recommended if Docker installed):{Colors.ENDC} minikube start --driver=docker
  • {Colors.OKGREEN}KVM2 (Faster, requires libvirt):{Colors.ENDC} minikube start --driver=kvm2
  • {Colors.OKGREEN}QEMU (No special setup needed):{Colors.ENDC} minikube start --driver=qemu
"""
        else:  # Windows
            instructions = f"""
{Colors.BOLD}Windows - Install Minikube:{Colors.ENDC}

{Colors.BOLD}Option 1: Using Chocolatey (Recommended):{Colors.ENDC}
{Colors.OKGREEN}
choco install minikube kubectl
{Colors.ENDC}

{Colors.BOLD}Option 2: Using Windows Package Manager:{Colors.ENDC}
{Colors.OKGREEN}
winget install Kubernetes.minikube
winget install Kubernetes.kubectl
{Colors.ENDC}

{Colors.BOLD}Option 3: Download Manually:{Colors.ENDC}
  1. Visit: https://minikube.sigs.k8s.io/docs/start/
  2. Download Windows installer
  3. Run the installer
  4. Add to PATH if not automatic
  5. Verify: minikube version

{Colors.BOLD}Requirements:{Colors.ENDC}
  • Docker Desktop for Windows OR
  • Hyper-V (built into Windows Pro/Enterprise)
  • WSL 2 (recommended)
"""

        print(instructions)

        # Ask if user has installed Minikube
        install = input(f"\n{Colors.BOLD}Have you installed Minikube? (y/n): {Colors.ENDC}").lower()

        if install == 'y':
            # Verify installation
            print(f"\n{Colors.OKCYAN}Verifying Minikube installation...{Colors.ENDC}\n")
            time.sleep(1)
            success, output = self.run_command(["minikube", "version"], "Verifying Minikube")

            if success:
                print(f"{Colors.OKGREEN}✓ Minikube installed successfully!{Colors.ENDC}\n")
                print(f"{Colors.BOLD}{output.strip()}{Colors.ENDC}\n")

                # Show startup instructions
                print(f"\n{Colors.BOLD}Next Steps:{Colors.ENDC}\n")
                print(f"1. {Colors.OKGREEN}Start Minikube with Docker driver:{Colors.ENDC}")
                print(f"   {Colors.OKCYAN}minikube start --driver=docker{Colors.ENDC}\n")

                if system == "Linux":
                    print(f"2. {Colors.OKGREEN}Or start with KVM2 driver (faster):{Colors.ENDC}")
                    print(f"   {Colors.OKCYAN}minikube start --driver=kvm2 --cpus=4 --memory=8192{Colors.ENDC}\n")

                print(f"3. {Colors.OKGREEN}Check Minikube status:{Colors.ENDC}")
                print(f"   {Colors.OKCYAN}minikube status{Colors.ENDC}\n")

                print(f"4. {Colors.OKGREEN}Open Minikube dashboard:{Colors.ENDC}")
                print(f"   {Colors.OKCYAN}minikube dashboard{Colors.ENDC}\n")

                # Ask if they want to start now
                start_now = input(f"\n{Colors.BOLD}Start Minikube now? (y/n): {Colors.ENDC}").lower()
                if start_now == 'y':
                    print(f"\n{Colors.OKCYAN}Starting Minikube...{Colors.ENDC}\n")
                    print(f"{Colors.WARNING}Note: This may take a minute or two on first run.{Colors.ENDC}\n")
                    success, output = self.run_command(["minikube", "start", "--driver=docker"], "Starting Minikube")

                    if success:
                        print(f"\n{Colors.OKGREEN}✓ Minikube started successfully!{Colors.ENDC}\n")

                        # Show useful info
                        print(f"{Colors.BOLD}Cluster Information:{Colors.ENDC}\n")
                        self.run_command(["minikube", "status"], "Getting Minikube status")

                        print(f"\n{Colors.BOLD}Useful Commands:{Colors.ENDC}")
                        print(f"  • Verify cluster: {Colors.OKCYAN}kubectl cluster-info{Colors.ENDC}")
                        print(f"  • List pods: {Colors.OKCYAN}kubectl get pods -A{Colors.ENDC}")
                        print(f"  • Check system: {Colors.OKCYAN}make detect{Colors.ENDC}\n")
                    else:
                        print(f"\n{Colors.FAIL}❌ Failed to start Minikube.{Colors.ENDC}\n")
                        print(f"You can try manually with: minikube start --driver=docker\n")
            else:
                print(f"{Colors.FAIL}❌ Minikube not found in PATH.{Colors.ENDC}")
                print(f"Please ensure it's properly installed and accessible in your PATH.\n")
        else:
            print(f"\n{Colors.WARNING}⚠️  Please install Minikube first, then restart this section.{Colors.ENDC}\n")

        self.config["completed_sections"].append("minikube_install")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_kvm_setup(self):
        """KVM setup for Linux"""
        self.print_section_header("Configure KVM Driver (Linux)", "⚙️")

        system = self._detect_os()

        if system != "Linux":
            print(f"{Colors.WARNING}⚠️  KVM is only available on Linux. You're running {system}.{Colors.ENDC}\n")
            input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
            return

        print(f"""
{Colors.BOLD}Why KVM?{Colors.ENDC}
KVM (Kernel Virtual Machine) is faster and more efficient than Docker as a Minikube driver.

{Colors.BOLD}Installation Steps:{Colors.ENDC}

1️⃣  Check if KVM is supported:
{Colors.OKGREEN}
grep -cw vmx /proc/cpuinfo    # For Intel
grep -cw svm /proc/cpuinfo    # For AMD
{Colors.ENDC}
(Output should be > 0)

2️⃣  Install KVM packages:
{Colors.OKGREEN}
sudo apt-get update
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients
sudo apt-get install -y virt-manager docker.io
{Colors.ENDC}

3️⃣  Add your user to libvirt group:
{Colors.OKGREEN}
sudo usermod -a -G libvirt $USER
newgrp libvirt
{Colors.ENDC}

4️⃣  Install Minikube with KVM:
{Colors.OKGREEN}
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
{Colors.ENDC}

5️⃣  Start Minikube with KVM driver:
{Colors.OKGREEN}
minikube start --driver=kvm2 --cpus=4 --memory=8192
{Colors.ENDC}

6️⃣  Verify KVM is working:
{Colors.OKGREEN}
minikube config view
virsh list
{Colors.ENDC}
""")

        self.config["completed_sections"].append("kvm_setup")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_deploy_app(self):
        """Deploy sample application"""
        self.print_section_header("Deploy Your First Application", "🎯")

        app_name = input(f"\n{Colors.BOLD}Enter application name (default: myapp): {Colors.ENDC}").strip() or "myapp"
        replicas = input(f"{Colors.BOLD}Number of replicas (default: 3): {Colors.ENDC}").strip() or "3"

        print(f"\n{Colors.OKGREEN}✓ Creating deployment for '{app_name}' with {replicas} replicas{Colors.ENDC}\n")

        # Create sample YAML
        yaml_content = self._generate_sample_deployment(app_name, replicas)
        yaml_file = self.tutorial_dir / f"{app_name}-deployment.yaml"

        with open(yaml_file, 'w') as f:
            f.write(yaml_content)

        print(f"{Colors.BOLD}Generated deployment file: {yaml_file}{Colors.ENDC}\n")
        print(f"{Colors.OKCYAN}{yaml_content}{Colors.ENDC}\n")

        # Check if minikube is running
        success, _ = self.run_command(["minikube", "status"], "Checking Minikube status")

        if not success:
            print(f"{Colors.FAIL}❌ Minikube is not running!{Colors.ENDC}")
            start_choice = input(f"{Colors.WARNING}Start Minikube now? (y/n): {Colors.ENDC}")
            if start_choice.lower() == 'y':
                self.run_command(["minikube", "start", "--driver=docker"], "Starting Minikube")
                time.sleep(3)
            else:
                return

        # Deploy application
        deploy_choice = input(f"\n{Colors.BOLD}Deploy application to Minikube? (y/n): {Colors.ENDC}")

        if deploy_choice.lower() == 'y':
            print(f"\n{Colors.OKGREEN}Deploying...{Colors.ENDC}\n")
            self.run_command(["kubectl", "apply", "-f", str(yaml_file)], f"Deploying {app_name}")

            time.sleep(2)

            # Show deployment status
            print(f"\n{Colors.BOLD}Deployment Status:{Colors.ENDC}\n")
            self.run_command(["kubectl", "get", "deployments"], "Getting deployments")

            print(f"\n{Colors.BOLD}Pods Status:{Colors.ENDC}\n")
            self.run_command(["kubectl", "get", "pods"], "Getting pods")

            print(f"\n{Colors.BOLD}Services:{Colors.ENDC}\n")
            self.run_command(["kubectl", "get", "services"], "Getting services")

            # Show access instructions
            print(f"""
{Colors.OKGREEN}{Colors.BOLD}✓ Application deployed successfully!{Colors.ENDC}

{Colors.BOLD}Access your application:{Colors.ENDC}

# Forward port locally
kubectl port-forward svc/{app_name} 8080:80

# Then visit: http://localhost:8080

# Or use Minikube service
minikube service {app_name}

{Colors.BOLD}View logs:{Colors.ENDC}
kubectl logs -f deployment/{app_name}

{Colors.BOLD}Update replicas:{Colors.ENDC}
kubectl scale deployment {app_name} --replicas=5

{Colors.BOLD}Delete deployment:{Colors.ENDC}
kubectl delete deployment {app_name}
""")

        self.config["completed_sections"].append("deploy_app")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_logging(self):
        """Setup logging"""
        self.print_section_header("Setup Logging", "📊")

        print(f"""
{Colors.BOLD}Kubernetes Logging Strategies:{Colors.ENDC}

{Colors.BOLD}1. Basic Pod Logs (Built-in):{Colors.ENDC}
{Colors.OKGREEN}
# View logs from a pod
kubectl logs <pod-name>

# View logs from a deployment
kubectl logs deployment/<deployment-name>

# Stream logs (like tail -f)
kubectl logs -f pod/<pod-name>

# View logs from previous container (if crashed)
kubectl logs <pod-name> --previous

# Show timestamps
kubectl logs <pod-name> --timestamps=true
{Colors.ENDC}

{Colors.BOLD}2. Structured Logging with ELK Stack:{Colors.ENDC}

Create a sample logging deployment:
{Colors.OKGREEN}
cat > logging-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: logging-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: logging-app
  template:
    metadata:
      labels:
        app: logging-app
    spec:
      containers:
      - name: app
        image: python:3.9
        command: ["python", "-c"]
        args:
        - |
          import json
          import time
          from datetime import datetime

          while True:
            log_entry = {{
              "timestamp": datetime.utcnow().isoformat(),
              "level": "INFO",
              "message": "Application running",
              "component": "app"
            }}
            print(json.dumps(log_entry))
            time.sleep(2)
EOF

kubectl apply -f logging-deployment.yaml
{Colors.ENDC}

{Colors.BOLD}3. View Logs in JSON Format:{Colors.ENDC}
{Colors.OKGREEN}
kubectl logs deployment/logging-app -f | jq '.'
{Colors.ENDC}

{Colors.BOLD}4. Multi-container Pod Logging:{Colors.ENDC}
{Colors.OKGREEN}
# If pod has multiple containers
kubectl logs <pod-name> -c <container-name>

# Get logs from all containers
kubectl logs <pod-name> --all-containers=true
{Colors.ENDC}

{Colors.BOLD}5. Event Logging:{Colors.ENDC}
{Colors.OKGREEN}
# View cluster events
kubectl get events --sort-by=.metadata.creationTimestamp

# Watch events in real-time
kubectl get events -w
{Colors.ENDC}

{Colors.BOLD}6. Persistent Logging Setup (Manual):{Colors.ENDC}
{Colors.OKGREEN}
# Create a ConfigMap with logging configuration
kubectl create configmap app-logs --from-literal=log_level=INFO --dry-run=client -o yaml | kubectl apply -f -

# Mount logs to persistent volume
# (See deployment configuration in next section)
{Colors.ENDC}
""")

        self.config["completed_sections"].append("logging")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_tracing(self):
        """Setup distributed tracing"""
        self.print_section_header("Setup Distributed Tracing", "🔍")

        print(f"""
{Colors.BOLD}What is Distributed Tracing?{Colors.ENDC}
Distributed tracing helps you track requests across multiple services in your application.

{Colors.BOLD}Popular Solutions:{Colors.ENDC}
  • Jaeger (OpenTelemetry)
  • Zipkin
  • DataDog
  • New Relic

{Colors.BOLD}1. Install Jaeger in Minikube:{Colors.ENDC}
{Colors.OKGREEN}
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-kubernetes/raw/master/jaeger-all-in-one-template.yml -n observability
{Colors.ENDC}

{Colors.BOLD}2. Access Jaeger UI:{Colors.ENDC}
{Colors.OKGREEN}
# Port forward to local machine
kubectl port-forward -n observability svc/jaeger-query 16686:16686

# Visit: http://localhost:16686
{Colors.ENDC}

{Colors.BOLD}3. Sample App with OpenTelemetry (Python):{Colors.ENDC}
{Colors.OKGREEN}
cat > traced-app.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: traced-app
spec:
  selector:
    app: traced-app
  ports:
  - port: 8000
    targetPort: 8000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: traced-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: traced-app
  template:
    metadata:
      labels:
        app: traced-app
    spec:
      containers:
      - name: app
        image: python:3.9
        env:
        - name: OTEL_EXPORTER_OTLP_ENDPOINT
          value: "http://jaeger-collector:4317"
        - name: OTEL_SERVICE_NAME
          value: "traced-app"
        command: ["python", "-c"]
        args:
        - |
          from opentelemetry import trace
          from opentelemetry.exporter.jaeger.thrift import JaegerExporter
          from opentelemetry.sdk.trace import TracerProvider
          from opentelemetry.sdk.trace.export import BatchSpanProcessor
          import time

          jaeger_exporter = JaegerExporter(
              agent_host_name="jaeger-agent",
              agent_port=6831,
          )

          trace.set_tracer_provider(TracerProvider())
          trace.get_tracer_provider().add_span_processor(
              BatchSpanProcessor(jaeger_exporter)
          )

          tracer = trace.get_tracer(__name__)

          while True:
              with tracer.start_as_current_span("work"):
                  print("Doing work...")
                  time.sleep(1)
EOF

kubectl apply -f traced-app.yaml
{Colors.ENDC}

{Colors.BOLD}4. View Traces in Jaeger:{Colors.ENDC}
Open http://localhost:16686 and search for "traced-app" service

{Colors.BOLD}5. Manual Tracing with Logs:{Colors.ENDC}
{Colors.OKGREEN}
# Each request gets a trace ID
kubectl logs -l app=traced-app | grep "trace_id"
{Colors.ENDC}
""")

        self.config["completed_sections"].append("tracing")
        self._save_config()

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_verify(self):
        """Verify installation"""
        self.print_section_header("Verify Installation", "✅")

        checks = {
            "Docker": (["docker", "--version"], "Docker"),
            "Minikube": (["minikube", "version"], "Minikube"),
            "kubectl": (["kubectl", "version", "--client"], "kubectl"),
        }

        print(f"\n{Colors.BOLD}Running system checks...{Colors.ENDC}\n")

        all_ok = True
        for name, (cmd, display_name) in checks.items():
            success, output = self.run_command(cmd, f"Checking {display_name}")
            if success:
                print(f"{Colors.OKGREEN}✅ {display_name}{Colors.ENDC}")
                if output:
                    print(f"   {output.strip().split(chr(10))[0]}\n")
            else:
                print(f"{Colors.FAIL}❌ {display_name} not found{Colors.ENDC}\n")
                all_ok = False

        # Check Minikube status
        print(f"\n{Colors.BOLD}Minikube Status:{Colors.ENDC}\n")
        success, output = self.run_command(["minikube", "status"], "Checking Minikube status")
        if success:
            print(f"{Colors.OKGREEN}{output}{Colors.ENDC}")
        else:
            print(f"{Colors.WARNING}Minikube is not running. Start it with: minikube start{Colors.ENDC}\n")

        # Check cluster info
        print(f"\n{Colors.BOLD}Kubernetes Cluster Info:{Colors.ENDC}\n")
        self.run_command(["kubectl", "cluster-info"], "Getting cluster info")

        if all_ok:
            print(f"\n{Colors.OKGREEN}{Colors.BOLD}✓ All systems ready!{Colors.ENDC}\n")
        else:
            print(f"\n{Colors.WARNING}⚠️  Please install missing components. See Installation Guide.{Colors.ENDC}\n")

        input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_logs(self):
        """View tutorial logs"""
        self.print_section_header("Tutorial Logs", "📝")

        log_files = list(LOG_DIR.glob("*.log"))
        if not log_files:
            print(f"{Colors.WARNING}No log files found.{Colors.ENDC}\n")
            input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
            return

        log_files.sort(key=lambda x: x.stat().st_mtime, reverse=True)

        print(f"\n{Colors.BOLD}Recent Log Files:{Colors.ENDC}\n")
        for i, log_file in enumerate(log_files[:10], 1):
            print(f"{i}. {log_file.name}")

        choice = input(f"\n{Colors.BOLD}View log file (1-{min(10, len(log_files))}) or 'q' to quit: {Colors.ENDC}")

        if choice.lower() != 'q' and choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(log_files):
                with open(log_files[idx]) as f:
                    print(f"\n{Colors.OKGREEN}=== {log_files[idx].name} ==={Colors.ENDC}\n")
                    print(f.read())

        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_version_info(self):
        """Show version and system info"""
        self.print_section_header("Version & System Information", "ℹ️")

        info = f"""
{Colors.BOLD}Tutorial Information:{Colors.ENDC}
  Version: {self.VERSION}
  Config Directory: {self.tutorial_dir}
  Log Directory: {LOG_DIR}
  Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

{Colors.BOLD}Completed Sections:{Colors.ENDC}
"""
        if self.config["completed_sections"]:
            for section in self.config["completed_sections"]:
                info += f"  ✓ {section.replace('_', ' ').title()}\n"
        else:
            info += "  (None yet)\n"

        info += f"\n{Colors.BOLD}System Information:{Colors.ENDC}\n"

        # Get version information
        tools = {
            "Docker": ["docker", "--version"],
            "Minikube": ["minikube", "version"],
            "kubectl": ["kubectl", "version", "--client", "-o", "json"],
        }

        for tool_name, cmd in tools.items():
            success, output = self.run_command(cmd, f"Getting {tool_name} version")
            if success:
                info += f"  {tool_name}: {output.strip().split(chr(10))[0]}\n"
            else:
                info += f"  {tool_name}: {Colors.FAIL}Not installed{Colors.ENDC}\n"

        # OS information
        os_name = self._detect_os()
        info += f"  OS: {os_name}\n"

        print(info)
        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def _detect_os(self) -> str:
        """Detect operating system"""
        if sys.platform == "darwin":
            return "macOS"
        elif sys.platform.startswith("linux"):
            return "Linux"
        elif sys.platform == "win32":
            return "Windows"
        return "Unknown"

    def _generate_sample_deployment(self, app_name: str, replicas: str) -> str:
        """Generate sample deployment YAML"""
        return f"""apiVersion: v1
kind: Service
metadata:
  name: {app_name}
  labels:
    app: {app_name}
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: {app_name}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {app_name}
  labels:
    app: {app_name}
spec:
  replicas: {replicas}
  selector:
    matchLabels:
      app: {app_name}
  template:
    metadata:
      labels:
        app: {app_name}
    spec:
      containers:
      - name: {app_name}
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
"""

    def section_addons(self):
        """Manage Minikube add-ons"""
        self.print_section_header("Minikube Add-ons Management", "🎛️")

        addons_info = f"""
{Colors.BOLD}Available Add-ons:{Colors.ENDC}
  1. 🖥️  Dashboard - Web UI for cluster management
  2. 🔗 Tunnel (MetalLB) - LoadBalancer service support
  3. 📦 Registry - Local Docker image registry
  4. 📈 Metrics Server - Resource monitoring
  5. 🔌 Ingress Controller - HTTP/HTTPS routing

{Colors.BOLD}Quick Start:{Colors.ENDC}
  Run: ./scripts/minikube-addons.sh
  Or:  ./scripts/minikube-addons.sh auto (for full setup)

{Colors.BOLD}What Each Add-on Does:{Colors.ENDC}

{Colors.OKCYAN}Dashboard:{Colors.ENDC}
  • Web-based cluster visualization
  • Pod and deployment management
  • Real-time cluster insights
  • Access: minikube dashboard

{Colors.OKCYAN}Tunnel (MetalLB):{Colors.ENDC}
  • LoadBalancer service support
  • External IP assignment
  • Service discovery
  • Access: minikube tunnel (separate terminal)

{Colors.OKCYAN}Registry:{Colors.ENDC}
  • Local Docker image registry
  • No Docker Hub push needed
  • Fast image distribution
  • Available at: localhost:5000

{Colors.OKCYAN}Metrics Server:{Colors.ENDC}
  • CPU/Memory monitoring
  • kubectl top commands
  • HPA (Horizontal Pod Autoscaler) support
  • Commands: kubectl top nodes/pods

{Colors.BOLD}Documentation:{Colors.ENDC}
  Read detailed guide: ADDONS_GUIDE.md
"""
        print(addons_info)
        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def section_helm_packages(self):
        """Install Helm packages"""
        self.print_section_header("Helm Packages Installation", "📦")

        helm_info = f"""
{Colors.BOLD}20 Production-Ready Packages Available:{Colors.ENDC}

{Colors.OKCYAN}Monitoring Stack (3 packages):{Colors.ENDC}
  • Prometheus - Metrics collection and storage
  • Grafana - Visualization and dashboards
  • Thanos - Long-term metrics storage

{Colors.OKCYAN}Logging Stack (3 packages):{Colors.ENDC}
  • Loki - Log aggregation
  • Elasticsearch - Log storage and analysis
  • Kibana - Log visualization

{Colors.OKCYAN}Tracing Stack (2 packages):{Colors.ENDC}
  • Jaeger - Distributed tracing
  • OpenTelemetry Collector - Unified telemetry

{Colors.OKCYAN}Databases (6 packages):{Colors.ENDC}
  • PostgreSQL - Relational database
  • MongoDB - NoSQL document database
  • Redis - In-memory cache
  • RabbitMQ - Message broker
  • Kafka - Event streaming
  • MinIO - Object storage

{Colors.OKCYAN}Infrastructure Tools (6 packages):{Colors.ENDC}
  • Nginx Ingress - HTTP/HTTPS routing
  • Cert-Manager - SSL certificate management
  • Sealed Secrets - Secret encryption
  • ArgoCD - GitOps deployment
  • Vault - Secret management

{Colors.BOLD}Quick Start:{Colors.ENDC}
  Install all: ./scripts/helm-packages.sh auto
  Interactive: ./scripts/helm-packages.sh

{Colors.BOLD}Installation Times:{Colors.ENDC}
  • Single package: ~5 minutes
  • Full stack: ~15 minutes
  • All 20 packages: ~30 minutes

{Colors.BOLD}Namespaces Created:{Colors.ENDC}
  • monitoring - Prometheus, Grafana, Thanos
  • logging - Loki, Elasticsearch, Kibana
  • tracing - Jaeger, OpenTelemetry
  • databases - All database packages
  • management - ArgoCD, infrastructure tools
  • security - Vault, Sealed Secrets

{Colors.BOLD}Documentation:{Colors.ENDC}
  Read detailed guide: HELM_PACKAGES_GUIDE.md
"""
        print(helm_info)
        input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def _load_recipes(self) -> List[Dict]:
        """Load recipes from recipes.json"""
        recipes_file = Path.cwd() / "recipes.json"
        if recipes_file.exists():
            with open(recipes_file) as f:
                data = json.load(f)
                return data.get("recipes", [])
        return []

    def _deploy_recipe(self, recipe: Dict) -> bool:
        """Deploy a selected recipe"""
        recipe_id = recipe['id']
        recipe_name = recipe['name']
        yaml_path = recipe['yaml']

        # Check if YAML file exists
        if not Path(yaml_path).exists():
            print(f"{Colors.FAIL}Error: {yaml_path} not found{Colors.ENDC}")
            return False

        print(f"\n{Colors.BOLD}{Colors.OKGREEN}╔════════════════════════════════════════╗{Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.OKGREEN}║{Colors.ENDC}  {Colors.OKCYAN}{recipe_name}{Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.OKGREEN}╚════════════════════════════════════════╝{Colors.ENDC}\n")

        # Show recipe details
        details = f"""
{Colors.OKCYAN}Category:{Colors.ENDC} {recipe.get('category', 'N/A')}
{Colors.OKCYAN}Difficulty:{Colors.ENDC} {recipe.get('difficulty', 'N/A')}
{Colors.OKCYAN}Time to Deploy:{Colors.ENDC} {recipe.get('time', 'N/A')}
{Colors.OKCYAN}Description:{Colors.ENDC} {recipe.get('description', 'N/A')}
"""
        print(details)

        # Show port mappings
        if recipe.get('ports'):
            print(f"{Colors.BOLD}Port Mappings:{Colors.ENDC}")
            for port in recipe['ports']:
                print(f"  • {port.get('service', 'Service')}: localhost:{port.get('local')} → :{port.get('container')}")

        # Show credentials if available
        if recipe.get('credentials'):
            print(f"\n{Colors.BOLD}Credentials:{Colors.ENDC}")
            for key, value in recipe['credentials'].items():
                print(f"  • {key}: {value}")

        # Ask for confirmation
        confirm = input(f"\n{Colors.WARNING}Deploy this recipe? (y/n): {Colors.ENDC}").strip().lower()

        if confirm != 'y':
            print(f"{Colors.WARNING}Deployment cancelled.{Colors.ENDC}")
            return False

        # Deploy using kubectl
        print(f"\n{Colors.BOLD}Deploying {recipe_name}...{Colors.ENDC}")
        success, output = self.run_command(["kubectl", "apply", "-f", yaml_path], f"Deploying {recipe_name}")

        if success:
            print(f"\n{Colors.OKGREEN}✓ {recipe_name} deployed successfully!{Colors.ENDC}\n")

            # Show access instructions
            if recipe.get('access'):
                print(f"{Colors.BOLD}How to Access:{Colors.ENDC}")
                print(f"{Colors.OKCYAN}{recipe['access']}{Colors.ENDC}\n")

            # Show common commands
            if recipe.get('commands'):
                print(f"{Colors.BOLD}Common Commands:{Colors.ENDC}")
                commands = recipe['commands']
                for cmd_name, cmd_value in commands.items():
                    print(f"  {cmd_name}: {cmd_value}")
                print()

            # Offer to open documentation
            if recipe.get('docs_url'):
                open_docs = input(f"{Colors.WARNING}Open documentation in browser? (y/n): {Colors.ENDC}").strip().lower()
                if open_docs == 'y':
                    self._open_url(recipe['docs_url'])

            return True
        else:
            print(f"{Colors.FAIL}✗ Failed to deploy {recipe_name}{Colors.ENDC}")
            print(f"{Colors.FAIL}Error: {output}{Colors.ENDC}")
            return False

    def _open_url(self, url_or_file: str):
        """Open URL or file in browser"""
        if url_or_file.startswith('http'):
            cmd = None
            if sys.platform == 'darwin':
                cmd = ['open', url_or_file]
            elif sys.platform == 'linux':
                cmd = ['xdg-open', url_or_file]
            elif sys.platform == 'win32':
                cmd = ['start', url_or_file]

            if cmd:
                try:
                    subprocess.Popen(cmd)
                except Exception as e:
                    print(f"{Colors.WARNING}Could not open browser: {e}{Colors.ENDC}")
                    print(f"{Colors.WARNING}Please visit: {url_or_file}{Colors.ENDC}")
        else:
            # It's a local file
            if Path(url_or_file).exists():
                if sys.platform == 'darwin':
                    subprocess.Popen(['open', str(Path(url_or_file).absolute())])
                elif sys.platform == 'linux':
                    subprocess.Popen(['xdg-open', str(Path(url_or_file).absolute())])
                elif sys.platform == 'win32':
                    subprocess.Popen(['start', str(Path(url_or_file).absolute())])

    def section_recipes(self):
        """Interactive minikube recipes section"""
        while True:
            self.print_section_header("Minikube Recipes - Ready-to-Deploy Apps", "📋")

            recipes = self._load_recipes()

            if not recipes:
                print(f"{Colors.FAIL}Error: Could not load recipes.json{Colors.ENDC}\n")
                input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                return

            # Display recipe list
            print(f"{Colors.BOLD}Available Recipes:{Colors.ENDC}\n")

            for recipe in recipes:
                recipe_id = recipe['id']
                name = recipe['name']
                difficulty = recipe['difficulty']
                time = recipe['time']
                print(f"  {recipe_id:2d}. {name:35s} | {difficulty:12s} | {time}")

            print(f"\n  L. List deployed recipes")
            print(f"  D. Delete recipe")
            print(f"  B. Back to menu")
            print(f"  Q. Quit\n")

            choice = input(f"{Colors.BOLD}Select recipe to deploy (1-{len(recipes)}) or option: {Colors.ENDC}").strip().lower()

            if choice == 'b':
                break
            elif choice == 'q':
                sys.exit(0)
            elif choice == 'l':
                # List deployed
                print(f"\n{Colors.BOLD}Deployed Applications:{Colors.ENDC}")
                success, output = self.run_command(["kubectl", "get", "pods"], "Listing pods")
                if success:
                    print(output)
                else:
                    print(f"{Colors.FAIL}Could not fetch pod list{Colors.ENDC}")
                input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                continue
            elif choice == 'd':
                # Delete recipe
                delete_choice = input(f"{Colors.WARNING}Enter recipe number to delete (or 'c' to cancel): {Colors.ENDC}").strip()
                if delete_choice.lower() != 'c':
                    try:
                        recipe_num = int(delete_choice)
                        recipe_to_delete = next((r for r in recipes if r['id'] == recipe_num), None)
                        if recipe_to_delete:
                            confirm = input(f"{Colors.FAIL}Delete {recipe_to_delete['name']}? (y/n): {Colors.ENDC}").strip().lower()
                            if confirm == 'y':
                                yaml_path = recipe_to_delete['yaml']
                                self.run_command(["kubectl", "delete", "-f", yaml_path], f"Deleting {recipe_to_delete['name']}")
                                print(f"{Colors.OKGREEN}Recipe deleted.{Colors.ENDC}")
                    except ValueError:
                        pass
                input(f"\n{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
                continue

            # Try to deploy selected recipe
            try:
                recipe_num = int(choice)
                selected_recipe = next((r for r in recipes if r['id'] == recipe_num), None)

                if selected_recipe:
                    if self._deploy_recipe(selected_recipe):
                        again = input(f"{Colors.WARNING}Deploy another recipe? (y/n): {Colors.ENDC}").strip().lower()
                        if again != 'y':
                            break
                else:
                    print(f"{Colors.FAIL}Invalid recipe number{Colors.ENDC}")
                    input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
            except ValueError:
                print(f"{Colors.FAIL}Invalid choice{Colors.ENDC}")
                input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def run(self):
        """Main tutorial loop"""
        while True:
            self.print_menu()
            choice = input(f"{Colors.BOLD}Enter your choice (0-13): {Colors.ENDC}").strip()

            menu_actions = {
                "1": self.section_introduction,
                "2": self.section_installation,
                "3": self.section_minikube_install,
                "4": self.section_kvm_setup,
                "5": self.section_deploy_app,
                "6": self.section_logging,
                "7": self.section_tracing,
                "8": self.section_verify,
                "9": self.section_logs,
                "10": self.section_version_info,
                "11": self.section_addons,
                "12": self.section_helm_packages,
                "13": self.section_recipes,
                "0": self.exit_tutorial,
            }

            action = menu_actions.get(choice)
            if action:
                try:
                    action()
                except KeyboardInterrupt:
                    print(f"\n{Colors.WARNING}Interrupted by user.{Colors.ENDC}\n")
                except Exception as e:
                    logger.error(f"Error in section: {str(e)}")
                    print(f"{Colors.FAIL}Error: {str(e)}{Colors.ENDC}\n")
                    input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")
            else:
                print(f"{Colors.FAIL}Invalid choice. Please try again.{Colors.ENDC}\n")
                input(f"{Colors.WARNING}Press Enter to continue...{Colors.ENDC}")

    def exit_tutorial(self):
        """Exit the tutorial"""
        exit_msg = f"""
{Colors.OKGREEN}{Colors.BOLD}Thank you for using Minikube Tutorial!{Colors.ENDC}

{Colors.BOLD}Quick Reference Commands:{Colors.ENDC}
  minikube start              # Start cluster
  minikube stop               # Stop cluster
  minikube delete             # Delete cluster
  kubectl get nodes           # List nodes
  kubectl get pods -A         # List all pods
  kubectl apply -f <file>     # Deploy application
  kubectl delete -f <file>    # Remove application
  minikube dashboard          # Open dashboard
  minikube logs               # View Minikube logs

{Colors.BOLD}Logs saved to:{Colors.ENDC}
  {LOG_DIR}

Happy learning! 🚀
"""
        print(exit_msg)
        logger.info("Tutorial ended")
        sys.exit(0)


def main():
    """Entry point"""
    tutorial = MinikubeTutorial()
    try:
        tutorial.run()
    except KeyboardInterrupt:
        print(f"\n{Colors.WARNING}Tutorial interrupted. Goodbye!{Colors.ENDC}")
        sys.exit(0)


if __name__ == "__main__":
    main()
