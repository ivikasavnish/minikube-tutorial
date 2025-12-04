# 📦 Helm Packages Installation Guide

Install and manage 20 production-ready development, tracing, and analytics packages.

**Version:** 1.0.0 | **New Feature** | **Release Date:** 2025-12-03

---

## 🎯 Overview

This guide covers installation and usage of 20 essential packages organized in 4 stacks:

- **Monitoring Stack** (3 packages): Prometheus, Grafana, Thanos
- **Logging Stack** (3 packages): Loki, Elasticsearch, Kibana
- **Tracing Stack** (2 packages): Jaeger, OpenTelemetry
- **Database Stack** (6 packages): PostgreSQL, MongoDB, Redis, RabbitMQ, Kafka, MinIO
- **Infrastructure** (6 packages): Nginx Ingress, Cert-Manager, Sealed Secrets, ArgoCD, Vault

---

## ✨ Complete Package List (20 Packages)

### Monitoring & Metrics (3)
```
1. Prometheus      - Metrics collection, storage, and querying
2. Grafana         - Visualization dashboards and alerting
3. Thanos          - Long-term Prometheus metrics storage
```

### Logging (3)
```
4. Loki            - Log aggregation optimized for Kubernetes
5. Elasticsearch   - Scalable log storage and analysis
6. Kibana          - Log visualization and analysis
```

### Tracing (2)
```
7. Jaeger          - Distributed tracing and debugging
8. OpenTelemetry   - Unified telemetry collection
```

### Databases (6)
```
9. PostgreSQL      - Relational database
10. MongoDB        - NoSQL document database
11. Redis          - In-memory cache and data store
12. RabbitMQ       - Message broker and queuing
13. Kafka          - Event streaming and pub-sub
14. MinIO          - S3-compatible object storage
```

### Infrastructure & Tools (3)
```
15. Nginx Ingress  - HTTP/HTTPS routing
16. Cert-Manager   - Automatic SSL certificate management
17. Sealed Secrets - Encrypted secret management
18. ArgoCD         - GitOps continuous deployment
19. Vault          - Centralized secret management
```

---

## 🚀 Quick Start

### Install Everything (20 Packages)

```bash
./scripts/helm-packages.sh auto
```

Installs all 20 packages with one command (~30 minutes).

### Install by Stack

**Monitoring Stack:**
```bash
./scripts/helm-packages.sh
# Select: M
```

**Logging Stack:**
```bash
./scripts/helm-packages.sh
# Select: L
```

**Tracing Stack:**
```bash
./scripts/helm-packages.sh
# Select: T
```

**Database Stack:**
```bash
./scripts/helm-packages.sh
# Select: D
```

### Interactive Menu

```bash
./scripts/helm-packages.sh

# Select individual packages (1-19)
# Or use menu options for stacks
```

---

## 📊 Monitoring Stack (Prometheus + Grafana + Thanos)

### What is It?

Complete metrics monitoring and visualization solution for Kubernetes.

### Components

**Prometheus:**
- Metrics collection and storage
- Time-series database
- Real-time monitoring data
- PromQL query language

**Grafana:**
- Dashboard creation
- Metric visualization
- Alerting rules
- Multi-datasource support

**Thanos:**
- Long-term metrics storage
- Deduplication and downsampling
- Query federation
- Object storage backend (S3, MinIO)

### Installation

```bash
./scripts/helm-packages.sh
# Select: M (Monitoring Stack)
```

### Access

**Prometheus:**
```bash
kubectl port-forward -n monitoring svc/prometheus-kube-prom-prometheus 9090:9090
# Visit: http://localhost:9090
```

**Grafana:**
```bash
kubectl port-forward -n monitoring svc/grafana 3000:80
# Visit: http://localhost:3000
# Credentials: admin / admin
```

### Sample Queries

```promql
# CPU usage by pod
sum(rate(container_cpu_usage_seconds_total[5m])) by (pod_name)

# Memory usage
sum(container_memory_working_set_bytes) by (pod_name)

# Network I/O
sum(rate(container_network_receive_bytes_total[5m])) by (pod_name)

# Request latency
histogram_quantile(0.95, request_duration_seconds_bucket)
```

### Create Dashboard

1. Access Grafana (http://localhost:3000)
2. Click "+" → "Dashboard"
3. Click "Add new panel"
4. Choose Prometheus datasource
5. Enter PromQL query
6. Save dashboard

---

## 📋 Logging Stack (Loki + Elasticsearch + Kibana)

### What is It?

Complete log aggregation and analysis solution.

### Components

**Loki:**
- Lightweight log aggregation
- Kubernetes-native labels
- Efficient storage
- Compatible with Grafana

**Elasticsearch:**
- Powerful log storage
- Full-text search
- Analytics capabilities
- Scalable architecture

**Kibana:**
- Log visualization
- Discover and analyze logs
- Dashboard creation
- Alerting

### Installation

```bash
./scripts/helm-packages.sh
# Select: L (Logging Stack)
```

### Access

**Elasticsearch:**
```bash
kubectl port-forward -n logging svc/elasticsearch-master 9200:9200
# API: http://localhost:9200
```

**Kibana:**
```bash
kubectl port-forward -n logging svc/kibana 5601:5601
# Visit: http://localhost:5601
```

### View Logs in Loki (via Grafana)

1. Access Grafana (http://localhost:3000)
2. Datasources → Add Loki
3. URL: `http://loki:3100`
4. Explore → Select app label

### Sample Log Queries

```
# All logs from app namespace
{namespace="default"}

# Logs with error level
{app="myapp"} | level="error"

# Response times
{job="api"} | duration | logfmt

# Count logs by level
{app="myapp"} | level | stats count() by level
```

---

## 🔗 Tracing Stack (Jaeger + OpenTelemetry)

### What is It?

Distributed tracing for analyzing request flows across services.

### Components

**Jaeger:**
- Distributed tracing backend
- Service dependency visualization
- Trace collection and storage
- Query and visualization UI

**OpenTelemetry Collector:**
- Unified telemetry collection
- Multiple signal support (traces, metrics, logs)
- Protocol translation
- Vendor-agnostic

### Installation

```bash
./scripts/helm-packages.sh
# Select: T (Tracing Stack)
```

### Access Jaeger

```bash
kubectl port-forward -n tracing svc/jaeger-query 16686:16686
# Visit: http://localhost:16686
```

### Example: Instrument Application

**Python (with OpenTelemetry):**
```python
from opentelemetry import trace
from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

jaeger_exporter = JaegerExporter(
    agent_host_name="jaeger-agent",
    agent_port=6831,
)

trace.set_tracer_provider(TracerProvider())
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(jaeger_exporter)
)

tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("my-operation"):
    # Do work here
    pass
```

### Example: Trace a Request

1. Access Jaeger UI (http://localhost:16686)
2. Select service from dropdown
3. Click "Find Traces"
4. Click trace to view details
5. Analyze request flow

---

## 💾 Database Stack

### PostgreSQL

**What:** Enterprise relational database

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: D (Database Stack)
# Or Select: 7 (PostgreSQL only)
```

**Connect:**
```bash
kubectl port-forward -n databases svc/postgresql 5432:5432
psql -h localhost -U postgres -d postgres
```

**Create Database:**
```sql
CREATE DATABASE myapp;
CREATE USER myuser WITH PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE myapp TO myuser;
```

---

### MongoDB

**What:** NoSQL document database

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 8 (MongoDB only)
```

**Connect:**
```bash
kubectl port-forward -n databases svc/mongodb 27017:27017
mongo -u root -p rootpassword
```

**Create Database:**
```javascript
use myapp
db.createCollection("users")
db.users.insertOne({name: "John", email: "john@example.com"})
```

---

### Redis

**What:** In-memory cache and data store

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 9 (Redis only)
```

**Connect:**
```bash
kubectl port-forward -n databases svc/redis-master 6379:6379
redis-cli
```

**Example Commands:**
```bash
SET mykey "Hello"
GET mykey
EXPIRE mykey 3600
LPUSH mylist "item1"
HSET myhash field1 "value1"
```

---

### RabbitMQ

**What:** Message broker for asynchronous communication

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 10 (RabbitMQ only)
```

**Access Management UI:**
```bash
kubectl port-forward -n databases svc/rabbitmq 15672:15672
# Visit: http://localhost:15672
# Credentials: admin / rabbitmq
```

**Python Example:**
```python
import pika

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='rabbitmq', port=5672)
)
channel = connection.channel()

# Declare queue
channel.queue_declare(queue='my_queue')

# Publish message
channel.basic_publish(
    exchange='',
    routing_key='my_queue',
    body='Hello World!'
)
```

---

### Kafka

**What:** Distributed event streaming platform

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 11 (Kafka only)
```

**Create Topic:**
```bash
kubectl exec -it kafka-0 -n databases -- kafka-topics.sh \
  --create --topic mytopic \
  --bootstrap-server kafka:9092
```

**Produce Messages:**
```bash
kubectl exec -it kafka-0 -n databases -- kafka-console-producer.sh \
  --broker-list kafka:9092 \
  --topic mytopic
# Type messages and press Enter
```

---

### MinIO

**What:** S3-compatible object storage

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 12 (MinIO only)
```

**Access:**
```bash
kubectl port-forward -n databases svc/minio 9000:9000
kubectl port-forward -n databases svc/minio 9001:9001
# Visit: http://localhost:9001
# Credentials: minioadmin / minioadmin
```

**Upload File:**
```bash
aws s3 cp myfile.txt s3://mybucket/ \
  --endpoint-url http://localhost:9000 \
  --access-key minioadmin \
  --secret-key minioadmin
```

---

## 🔧 Infrastructure & Tools

### Nginx Ingress Controller

**What:** Kubernetes Ingress implementation for HTTP/HTTPS routing

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 13
```

**Example Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp
            port:
              number: 80
```

---

### Cert-Manager

**What:** Automatic SSL/TLS certificate management

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 14
```

**Create Certificate:**
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-cert
spec:
  secretName: my-cert-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
  - myapp.com
```

---

### Sealed Secrets

**What:** Encrypted Kubernetes secret management

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 15
```

**Create Secret:**
```bash
# Create a secret
echo -n mypassword | kubectl create secret generic mysecret \
  --dry-run=client --from-file=password=/dev/stdin -o yaml

# Seal it
kubeseal -f mysecret.yaml -w mysealedsecret.yaml
```

---

### ArgoCD

**What:** GitOps continuous deployment

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 16
```

**Access:**
```bash
kubectl port-forward -n management svc/argocd-server 8080:443
# Visit: https://localhost:8080
```

**Create Application:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/myuser/myapp
    targetRevision: HEAD
    path: k8s/
  destination:
    server: https://kubernetes.default.svc
    namespace: default
```

---

### Vault

**What:** Centralized secret and configuration management

**Installation:**
```bash
./scripts/helm-packages.sh
# Select: 17
```

**Initialize Vault:**
```bash
kubectl exec vault-0 -n security -- vault operator init
# Save keys and token securely!

kubectl exec vault-0 -n security -- vault operator unseal
# Unseal with key shares
```

---

## 📊 Helm Menu Structure

```
┌─ HELM PACKAGES MENU ──────────────────────┐
│                                           │
│ Individual Packages:                      │
│  1-8.   Prometheus, Grafana, Loki, etc    │
│  9-14.  PostgreSQL, MongoDB, Redis, etc   │
│  15-19. Ingress, Cert-Manager, etc        │
│                                           │
│ Quick Stacks:                             │
│  M. Monitoring Stack                      │
│  L. Logging Stack                         │
│  T. Tracing Stack                         │
│  D. Database Stack                        │
│                                           │
│ Full Installation:                        │
│  A. Install All 20 Packages               │
│                                           │
│ Utilities:                                │
│  P. List All Packages                     │
│  I. Show Access Information               │
│  L. View Activity Log                     │
│                                           │
│  0. Exit                                  │
│                                           │
└───────────────────────────────────────────┘
```

---

## 🔍 Verify Installation

**Check All Namespaces:**
```bash
kubectl get ns
# Should see: monitoring, logging, tracing, databases, management, security
```

**Check Pods in Each Namespace:**
```bash
kubectl get pods -n monitoring
kubectl get pods -n logging
kubectl get pods -n tracing
kubectl get pods -n databases
kubectl get pods -n management
kubectl get pods -n security
```

**Check Helm Releases:**
```bash
helm list --all-namespaces
```

---

## 📈 Common Workflows

### Workflow 1: Full Observability Setup

```bash
# 1. Install monitoring
./scripts/helm-packages.sh
# Select: M

# 2. Install logging
./scripts/helm-packages.sh
# Select: L

# 3. Install tracing
./scripts/helm-packages.sh
# Select: T

# 4. Access Grafana
kubectl port-forward -n monitoring svc/grafana 3000:80
# http://localhost:3000

# 5. Add Prometheus data source
# Prometheus → http://prometheus-operated:9090

# 6. Add Loki data source
# Loki → http://loki:3100

# 7. Create dashboards
# Combine metrics, logs, and traces
```

### Workflow 2: Development Database Setup

```bash
# 1. Install databases
./scripts/helm-packages.sh
# Select: D

# 2. Port-forward services
kubectl port-forward -n databases svc/postgresql 5432:5432 &
kubectl port-forward -n databases svc/mongodb 27017:27017 &
kubectl port-forward -n databases svc/redis-master 6379:6379 &

# 3. Connect and setup
psql -h localhost -U postgres
mongo localhost:27017
redis-cli

# 4. Create test databases
# PostgreSQL
CREATE DATABASE testdb;

# MongoDB
use testdb
db.createCollection("test")

# Redis
SET testkey value
```

### Workflow 3: Production-Like Deployment

```bash
# 1. Install all infrastructure
./scripts/helm-packages.sh
# Select: A (All 20 packages)

# 2. Deploy application
kubectl apply -f app-deployment.yaml

# 3. Create Ingress
kubectl apply -f app-ingress.yaml

# 4. Configure ArgoCD
# Deploy via GitOps

# 5. Monitor and log
# Access Grafana, Kibana, Jaeger

# 6. Manage secrets
# Use Vault or Sealed Secrets
```

---

## 🧹 Cleanup

**Remove Single Package:**
```bash
helm uninstall prometheus -n monitoring
```

**Remove Stack:**
```bash
helm uninstall prometheus grafana -n monitoring
```

**Remove All:**
```bash
helm uninstall -a -n monitoring
helm uninstall -a -n logging
helm uninstall -a -n tracing
helm uninstall -a -n databases
helm uninstall -a -n management
helm uninstall -a -n security
```

**Delete Namespaces:**
```bash
kubectl delete namespace monitoring logging tracing databases management security
```

---

## 📚 Default Credentials

| Package | Default User | Default Password | Notes |
|---------|---|---|---|
| Grafana | admin | admin | Change after first login |
| PostgreSQL | postgres | postgres | Random generated |
| MongoDB | root | rootpassword | See values |
| Redis | N/A | redis | Password-protected |
| RabbitMQ | admin | rabbitmq | Change in production |
| MinIO | minioadmin | minioadmin | Web UI access |

---

## 🔐 Security Notes

1. **Change Default Passwords** - Update immediately after installation
2. **Use Sealed Secrets** - Never commit plaintext secrets
3. **Enable RBAC** - Restrict namespace access
4. **Network Policies** - Implement micro-segmentation
5. **TLS/HTTPS** - Use Cert-Manager for certificates
6. **Audit Logging** - Enable Kubernetes audit logs
7. **Secret Rotation** - Implement automated rotation

---

## 📞 Support

If you encounter issues:

1. Check pod status: `kubectl get pods -n <namespace>`
2. View logs: `kubectl logs -n <namespace> <pod-name>`
3. Describe pod: `kubectl describe pod -n <namespace> <pod-name>`
4. Check Helm values: `helm get values -n <namespace> <release>`
5. Review troubleshooting in specific package sections

---

**Version:** 1.0.0
**Status:** Production Ready ✅
**Last Updated:** 2025-12-03

**📦 Complete development and analytics stack!**
