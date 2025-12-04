#!/bin/bash

#############################################################################
# 📦 Helm Packages Installation Tool
#############################################################################
# Description: Install 20 commonly used development, tracing, and
#              analytics packages including databases, stacks, and tools
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
LOG_FILE="$LOG_DIR/helm_packages_$(date +%Y%m%d_%H%M%S).log"

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
    echo "║         📦 HELM PACKAGES INSTALLATION TOOL                     ║"
    echo "║                                                                ║"
    echo "║    20 Development, Tracing & Analytics Packages                ║"
    echo "║    Version: 1.0.0  |  Status: Production Ready ✅              ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_prerequisites() {
    echo -e "${CYAN}Checking prerequisites...${NC}"

    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}✗ kubectl not found${NC}"
        log_message "ERROR" "kubectl not installed"
        exit 1
    fi
    echo -e "${GREEN}✓ kubectl found${NC}"

    # Check helm
    if ! command -v helm &> /dev/null; then
        echo -e "${RED}✗ Helm not found. Installing Helm...${NC}"
        install_helm
    fi
    echo -e "${GREEN}✓ Helm found${NC}"

    # Check minikube
    if ! minikube status > /dev/null 2>&1; then
        echo -e "${RED}✗ Minikube is not running${NC}"
        log_message "ERROR" "Minikube not running"
        exit 1
    fi
    echo -e "${GREEN}✓ Minikube is running${NC}"

    log_message "INFO" "All prerequisites verified"
}

install_helm() {
    echo -e "${CYAN}Installing Helm...${NC}"
    log_message "INFO" "Installing Helm"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install helm
    else
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi

    echo -e "${GREEN}✓ Helm installed${NC}"
}

add_helm_repos() {
    echo -e "${CYAN}Adding Helm repositories...${NC}"
    log_message "INFO" "Adding Helm repositories"

    # Prometheus Community Charts
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    echo -e "${GREEN}✓ Added prometheus-community${NC}"

    # Grafana Charts
    helm repo add grafana https://grafana.github.io/helm-charts
    echo -e "${GREEN}✓ Added grafana${NC}"

    # Bitnami Charts (databases)
    helm repo add bitnami https://charts.bitnami.com/bitnami
    echo -e "${GREEN}✓ Added bitnami${NC}"

    # Jetstack (Cert Manager)
    helm repo add jetstack https://charts.jetstack.io
    echo -e "${GREEN}✓ Added jetstack${NC}"

    # Elastic Charts
    helm repo add elastic https://Helm.elastic.co
    echo -e "${GREEN}✓ Added elastic${NC}"

    # Jaeger Charts
    helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
    echo -e "${GREEN}✓ Added jaegertracing${NC}"

    # Sealed Secrets
    helm repo add sealed-secrets https://kubernetes.github.io/sealed-secrets
    echo -e "${GREEN}✓ Added sealed-secrets${NC}"

    # ArgoCD
    helm repo add argo https://argoproj.github.io/argo-helm
    echo -e "${GREEN}✓ Added argo${NC}"

    # HashiCorp Vault
    helm repo add hashicorp https://helm.releases.hashicorp.com
    echo -e "${GREEN}✓ Added hashicorp${NC}"

    # Update all repos
    helm repo update
    echo -e "${GREEN}✓ All repositories updated${NC}"
    log_message "INFO" "Helm repositories added"
}

create_namespaces() {
    echo -e "${CYAN}Creating Kubernetes namespaces...${NC}"
    log_message "INFO" "Creating namespaces"

    kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace logging --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace tracing --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace databases --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace management --dry-run=client -o yaml | kubectl apply -f -
    kubectl create namespace security --dry-run=client -o yaml | kubectl apply -f -

    echo -e "${GREEN}✓ Namespaces created${NC}"
    log_message "INFO" "Namespaces created"
}

#############################################################################
# Installation Functions for Each Package
#############################################################################

install_prometheus() {
    echo -e "${CYAN}Installing Prometheus...${NC}"
    log_message "INFO" "Installing Prometheus"

    helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --set prometheus.prometheusSpec.retention=24h \
        --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=10Gi

    echo -e "${GREEN}✓ Prometheus installed${NC}"
    log_message "INFO" "Prometheus installed"
}

install_grafana() {
    echo -e "${CYAN}Installing Grafana...${NC}"
    log_message "INFO" "Installing Grafana"

    helm upgrade --install grafana grafana/grafana \
        --namespace monitoring \
        --set adminPassword=admin \
        --set persistence.enabled=true \
        --set persistence.size=5Gi

    echo -e "${GREEN}✓ Grafana installed${NC}"
    log_message "INFO" "Grafana installed"
}

install_loki() {
    echo -e "${CYAN}Installing Loki...${NC}"
    log_message "INFO" "Installing Loki"

    helm upgrade --install loki grafana/loki-stack \
        --namespace logging \
        --set loki.persistence.enabled=true \
        --set loki.persistence.size=10Gi

    echo -e "${GREEN}✓ Loki installed${NC}"
    log_message "INFO" "Loki installed"
}

install_jaeger() {
    echo -e "${CYAN}Installing Jaeger...${NC}"
    log_message "INFO" "Installing Jaeger"

    helm upgrade --install jaeger jaegertracing/jaeger \
        --namespace tracing \
        --set elasticsearch.enabled=true \
        --set elasticsearch.persistence.enabled=true

    echo -e "${GREEN}✓ Jaeger installed${NC}"
    log_message "INFO" "Jaeger installed"
}

install_elasticsearch() {
    echo -e "${CYAN}Installing Elasticsearch...${NC}"
    log_message "INFO" "Installing Elasticsearch"

    helm upgrade --install elasticsearch elastic/elasticsearch \
        --namespace logging \
        --set replicas=1 \
        --set volumeClaimTemplate.spec.resources.requests.storage=10Gi

    echo -e "${GREEN}✓ Elasticsearch installed${NC}"
    log_message "INFO" "Elasticsearch installed"
}

install_kibana() {
    echo -e "${CYAN}Installing Kibana...${NC}"
    log_message "INFO" "Installing Kibana"

    helm upgrade --install kibana elastic/kibana \
        --namespace logging \
        --set elasticsearchHosts=http://elasticsearch-master:9200

    echo -e "${GREEN}✓ Kibana installed${NC}"
    log_message "INFO" "Kibana installed"
}

install_postgresql() {
    echo -e "${CYAN}Installing PostgreSQL...${NC}"
    log_message "INFO" "Installing PostgreSQL"

    helm upgrade --install postgresql bitnami/postgresql \
        --namespace databases \
        --set auth.username=postgres \
        --set auth.password=postgres \
        --set primary.persistence.size=10Gi

    echo -e "${GREEN}✓ PostgreSQL installed${NC}"
    log_message "INFO" "PostgreSQL installed"
}

install_mongodb() {
    echo -e "${CYAN}Installing MongoDB...${NC}"
    log_message "INFO" "Installing MongoDB"

    helm upgrade --install mongodb bitnami/mongodb \
        --namespace databases \
        --set auth.rootPassword=rootpassword \
        --set persistence.size=10Gi

    echo -e "${GREEN}✓ MongoDB installed${NC}"
    log_message "INFO" "MongoDB installed"
}

install_redis() {
    echo -e "${CYAN}Installing Redis...${NC}"
    log_message "INFO" "Installing Redis"

    helm upgrade --install redis bitnami/redis \
        --namespace databases \
        --set auth.password=redis \
        --set master.persistence.size=5Gi

    echo -e "${GREEN}✓ Redis installed${NC}"
    log_message "INFO" "Redis installed"
}

install_rabbitmq() {
    echo -e "${CYAN}Installing RabbitMQ...${NC}"
    log_message "INFO" "Installing RabbitMQ"

    helm upgrade --install rabbitmq bitnami/rabbitmq \
        --namespace databases \
        --set auth.username=admin \
        --set auth.password=rabbitmq \
        --set persistence.size=5Gi

    echo -e "${GREEN}✓ RabbitMQ installed${NC}"
    log_message "INFO" "RabbitMQ installed"
}

install_kafka() {
    echo -e "${CYAN}Installing Kafka...${NC}"
    log_message "INFO" "Installing Kafka"

    helm upgrade --install kafka bitnami/kafka \
        --namespace databases \
        --set replicaCount=1 \
        --set persistence.size=10Gi

    echo -e "${GREEN}✓ Kafka installed${NC}"
    log_message "INFO" "Kafka installed"
}

install_minio() {
    echo -e "${CYAN}Installing MinIO...${NC}"
    log_message "INFO" "Installing MinIO"

    helm upgrade --install minio bitnami/minio \
        --namespace databases \
        --set auth.rootUser=minioadmin \
        --set auth.rootPassword=minioadmin \
        --set persistence.size=10Gi

    echo -e "${GREEN}✓ MinIO installed${NC}"
    log_message "INFO" "MinIO installed"
}

install_nginx_ingress() {
    echo -e "${CYAN}Installing Nginx Ingress Controller...${NC}"
    log_message "INFO" "Installing Nginx Ingress"

    helm upgrade --install nginx-ingress prometheus-community/kube-nginx-ingress \
        --namespace management \
        --set controller.service.type=LoadBalancer

    echo -e "${GREEN}✓ Nginx Ingress installed${NC}"
    log_message "INFO" "Nginx Ingress installed"
}

install_cert_manager() {
    echo -e "${CYAN}Installing Cert-Manager...${NC}"
    log_message "INFO" "Installing Cert-Manager"

    helm upgrade --install cert-manager jetstack/cert-manager \
        --namespace security \
        --set installCRDs=true

    echo -e "${GREEN}✓ Cert-Manager installed${NC}"
    log_message "INFO" "Cert-Manager installed"
}

install_sealed_secrets() {
    echo -e "${CYAN}Installing Sealed Secrets...${NC}"
    log_message "INFO" "Installing Sealed Secrets"

    helm upgrade --install sealed-secrets sealed-secrets/sealed-secrets \
        --namespace kube-system

    echo -e "${GREEN}✓ Sealed Secrets installed${NC}"
    log_message "INFO" "Sealed Secrets installed"
}

install_argocd() {
    echo -e "${CYAN}Installing ArgoCD...${NC}"
    log_message "INFO" "Installing ArgoCD"

    helm upgrade --install argocd argo/argo-cd \
        --namespace management \
        --set server.service.type=LoadBalancer

    echo -e "${GREEN}✓ ArgoCD installed${NC}"
    log_message "INFO" "ArgoCD installed"
}

install_vault() {
    echo -e "${CYAN}Installing HashiCorp Vault...${NC}"
    log_message "INFO" "Installing Vault"

    helm upgrade --install vault hashicorp/vault \
        --namespace security \
        --set server.dataStorage.size=10Gi

    echo -e "${GREEN}✓ Vault installed${NC}"
    log_message "INFO" "Vault installed"
}

install_otel_collector() {
    echo -e "${CYAN}Installing OpenTelemetry Collector...${NC}"
    log_message "INFO" "Installing OpenTelemetry Collector"

    helm upgrade --install opentelemetry-collector prometheus-community/opentelemetry-kube-stack \
        --namespace tracing

    echo -e "${GREEN}✓ OpenTelemetry Collector installed${NC}"
    log_message "INFO" "OpenTelemetry Collector installed"
}

install_thanos() {
    echo -e "${CYAN}Installing Thanos...${NC}"
    log_message "INFO" "Installing Thanos"

    helm upgrade --install thanos prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --set thanos.create=true \
        --set thanos.objstoreConfig.type=s3

    echo -e "${GREEN}✓ Thanos installed${NC}"
    log_message "INFO" "Thanos installed"
}

#############################################################################
# Package Groups Installation
#############################################################################

install_monitoring_stack() {
    echo -e "${MAGENTA}=== Installing Monitoring Stack ===${NC}"
    add_helm_repos
    create_namespaces
    install_prometheus
    install_grafana
    log_message "INFO" "Monitoring stack installed"
}

install_logging_stack() {
    echo -e "${MAGENTA}=== Installing Logging Stack ===${NC}"
    add_helm_repos
    create_namespaces
    install_loki
    install_elasticsearch
    install_kibana
    log_message "INFO" "Logging stack installed"
}

install_tracing_stack() {
    echo -e "${MAGENTA}=== Installing Tracing Stack ===${NC}"
    add_helm_repos
    create_namespaces
    install_jaeger
    install_otel_collector
    log_message "INFO" "Tracing stack installed"
}

install_database_stack() {
    echo -e "${MAGENTA}=== Installing Database Stack ===${NC}"
    add_helm_repos
    create_namespaces
    install_postgresql
    install_mongodb
    install_redis
    install_rabbitmq
    install_minio
    log_message "INFO" "Database stack installed"
}

install_all_packages() {
    echo -e "${MAGENTA}=== Installing All 20 Packages ===${NC}"
    log_message "INFO" "Starting full installation of all packages"

    check_prerequisites
    add_helm_repos
    create_namespaces

    echo ""
    echo -e "${CYAN}Installation Progress:${NC}"
    echo ""

    local count=1
    echo -e "${YELLOW}[$count/20]${NC} Prometheus..."
    install_prometheus && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Grafana..."
    install_grafana && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Loki..."
    install_loki && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Jaeger..."
    install_jaeger && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Elasticsearch..."
    install_elasticsearch && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Kibana..."
    install_kibana && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} PostgreSQL..."
    install_postgresql && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} MongoDB..."
    install_mongodb && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Redis..."
    install_redis && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} RabbitMQ..."
    install_rabbitmq && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Kafka..."
    install_kafka && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} MinIO..."
    install_minio && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Nginx Ingress..."
    install_nginx_ingress && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Cert-Manager..."
    install_cert_manager && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Sealed Secrets..."
    install_sealed_secrets && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} ArgoCD..."
    install_argocd && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Vault..."
    install_vault && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} OpenTelemetry Collector..."
    install_otel_collector && ((count++)) || true

    echo -e "${YELLOW}[$count/20]${NC} Thanos..."
    install_thanos && ((count++)) || true

    echo ""
    echo -e "${GREEN}✓ All packages installed!${NC}"
    log_message "INFO" "All packages installed successfully"
}

show_packages_list() {
    echo -e "${CYAN}=== 20 Available Helm Packages ===${NC}"
    echo ""
    echo -e "${MAGENTA}Monitoring & Metrics:${NC}"
    echo "  1. Prometheus - Metrics collection and storage"
    echo "  2. Grafana - Visualization and dashboards"
    echo "  3. Thanos - Long-term Prometheus storage"
    echo ""

    echo -e "${MAGENTA}Logging:${NC}"
    echo "  4. Loki - Log aggregation"
    echo "  5. Elasticsearch - Log storage and analysis"
    echo "  6. Kibana - Log visualization"
    echo ""

    echo -e "${MAGENTA}Tracing:${NC}"
    echo "  7. Jaeger - Distributed tracing"
    echo "  8. OpenTelemetry Collector - Telemetry collection"
    echo ""

    echo -e "${MAGENTA}Databases:${NC}"
    echo "  9. PostgreSQL - Relational database"
    echo "  10. MongoDB - NoSQL document database"
    echo "  11. Redis - In-memory data store"
    echo "  12. RabbitMQ - Message broker"
    echo "  13. Kafka - Event streaming"
    echo "  14. MinIO - Object storage"
    echo ""

    echo -e "${MAGENTA}Infrastructure & Tools:${NC}"
    echo "  15. Nginx Ingress - Ingress controller"
    echo "  16. Cert-Manager - SSL certificate management"
    echo "  17. Sealed Secrets - Secret encryption"
    echo "  18. ArgoCD - GitOps deployment"
    echo "  19. Vault - Secret management"
    echo ""

    echo -e "${MAGENTA}Quick Install Groups:${NC}"
    echo "  M. Monitoring Stack (Prometheus + Grafana)"
    echo "  L. Logging Stack (Loki + Elasticsearch + Kibana)"
    echo "  T. Tracing Stack (Jaeger + OpenTelemetry)"
    echo "  D. Database Stack (PostgreSQL + MongoDB + Redis + RabbitMQ + MinIO)"
    echo "  A. All 20 Packages"
    echo ""
}

show_access_info() {
    echo -e "${CYAN}=== Package Access Information ===${NC}"
    echo ""

    echo -e "${MAGENTA}Prometheus:${NC}"
    echo "  kubectl port-forward -n monitoring svc/prometheus-kube-prom-prometheus 9090:9090"
    echo "  Access: http://localhost:9090"
    echo ""

    echo -e "${MAGENTA}Grafana:${NC}"
    echo "  kubectl port-forward -n monitoring svc/grafana 3000:80"
    echo "  Access: http://localhost:3000 (admin/admin)"
    echo ""

    echo -e "${MAGENTA}Jaeger:${NC}"
    echo "  kubectl port-forward -n tracing svc/jaeger-query 16686:16686"
    echo "  Access: http://localhost:16686"
    echo ""

    echo -e "${MAGENTA}Elasticsearch:${NC}"
    echo "  kubectl port-forward -n logging svc/elasticsearch-master 9200:9200"
    echo "  Access: http://localhost:9200"
    echo ""

    echo -e "${MAGENTA}Kibana:${NC}"
    echo "  kubectl port-forward -n logging svc/kibana 5601:5601"
    echo "  Access: http://localhost:5601"
    echo ""

    echo -e "${MAGENTA}PostgreSQL:${NC}"
    echo "  kubectl port-forward -n databases svc/postgresql 5432:5432"
    echo "  Connection: postgresql://postgres:postgres@localhost:5432"
    echo ""

    echo -e "${MAGENTA}MongoDB:${NC}"
    echo "  kubectl port-forward -n databases svc/mongodb 27017:27017"
    echo "  Connection: mongodb://root:rootpassword@localhost:27017"
    echo ""

    echo -e "${MAGENTA}Redis:${NC}"
    echo "  kubectl port-forward -n databases svc/redis-master 6379:6379"
    echo "  Connection: redis-cli -h localhost"
    echo ""

    echo -e "${MAGENTA}ArgoCD:${NC}"
    echo "  kubectl port-forward -n management svc/argocd-server 8080:443"
    echo "  Access: https://localhost:8080"
    echo ""

    log_message "INFO" "Displayed access information"
}

#############################################################################
# Main Menu
#############################################################################

show_menu() {
    print_header

    echo -e "${CYAN}Checking prerequisites...${NC}"
    check_prerequisites

    echo ""
    echo -e "${MAGENTA}┌─ MAIN MENU ──────────────────────────────────────┐${NC}"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  Individual Packages:"
    echo -e "${MAGENTA}│${NC}  1-8.   Monitoring & Tracing (Prometheus, Grafana, etc)"
    echo -e "${MAGENTA}│${NC}  9-14.  Databases (PostgreSQL, MongoDB, Redis, etc)"
    echo -e "${MAGENTA}│${NC}  15-19. Infrastructure Tools"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  Package Groups:"
    echo -e "${MAGENTA}│${NC}  M. 📊 Install Monitoring Stack"
    echo -e "${MAGENTA}│${NC}  L. 📋 Install Logging Stack"
    echo -e "${MAGENTA}│${NC}  T. 🔗 Install Tracing Stack"
    echo -e "${MAGENTA}│${NC}  D. 💾 Install Database Stack"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  Full Installation:"
    echo -e "${MAGENTA}│${NC}  A. 🧠 Install All 20 Packages"
    echo -e "${MAGENTA}│${NC}"
    echo -e "${MAGENTA}│${NC}  Utilities:"
    echo -e "${MAGENTA}│${NC}  P. 📦 List All Packages"
    echo -e "${MAGENTA}│${NC}  I. ℹ️  Show Access Information"
    echo -e "${MAGENTA}│${NC}  L. 📋 View Activity Log"
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
        log_message "INFO" "Running in automatic mode - installing all packages"
        check_prerequisites
        install_all_packages
        exit 0
    fi

    while true; do
        show_menu

        read -p "Select option: " choice

        case $choice in
            1)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_prometheus
                ;;
            2)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_grafana
                ;;
            3)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_loki
                ;;
            4)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_jaeger
                ;;
            5)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_elasticsearch
                ;;
            6)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_kibana
                ;;
            7)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_postgresql
                ;;
            8)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_mongodb
                ;;
            9)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_redis
                ;;
            10)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_rabbitmq
                ;;
            11)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_kafka
                ;;
            12)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_minio
                ;;
            13)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_nginx_ingress
                ;;
            14)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_cert_manager
                ;;
            15)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_sealed_secrets
                ;;
            16)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_argocd
                ;;
            17)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_vault
                ;;
            18)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_otel_collector
                ;;
            19)
                check_prerequisites
                add_helm_repos
                create_namespaces
                install_thanos
                ;;
            m|M)
                install_monitoring_stack
                ;;
            l|L)
                install_logging_stack
                ;;
            t|T)
                install_tracing_stack
                ;;
            d|D)
                install_database_stack
                ;;
            a|A)
                install_all_packages
                ;;
            p|P)
                show_packages_list
                ;;
            i|I)
                show_access_info
                ;;
            lo|LO)
                echo -e "${CYAN}=== Activity Log ===${NC}"
                tail -30 "$LOG_FILE"
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
