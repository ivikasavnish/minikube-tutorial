# 📋 Minikube Recipes - Ready-to-Deploy Application Templates

Complete collection of pre-configured Kubernetes recipes for common use cases.

**Version:** 1.0.0 | **New Feature** | **Release Date:** 2025-12-03

---

## 🎯 Overview

Minikube Recipes provides one-click deployment of 12 production-ready application templates:

- ✅ **Web Servers** - Nginx, Apache
- ✅ **Databases** - PostgreSQL, MongoDB, Redis
- ✅ **Message Queues** - RabbitMQ
- ✅ **Full-Stack Apps** - Frontend + Backend + Database
- ✅ **Logging & Tracing** - Structured logging and distributed tracing
- ✅ **Testing** - Load testing applications
- ✅ **Stateful Services** - Redis Cluster with StatefulSet
- ✅ **CI/CD** - Jenkins pipeline server
- ✅ **API Gateway** - Kong API Gateway

---

## 🚀 Quick Start

### Launch Recipes

```bash
./scripts/minikube-recipes.sh
```

### Browse and Select

```
┌─ MAIN MENU ──────────────────────────────────────┐
│                                                  │
│  1. 🌐 Web Server (Nginx)                       │
│  2. 🗄️  PostgreSQL Database                      │
│  3. 📄 MongoDB Database                          │
│  4. ⚡ Redis Cache                               │
│  5. 🏗️  Multi-Tier Application                   │
│  ... more recipes ...                           │
│                                                  │
│  L. 📋 List All Recipes                         │
│  D. 👀 Show Deployed Apps                       │
│  0. 🚪 Exit                                     │
│                                                  │
└──────────────────────────────────────────────────┘
```

### Deploy a Recipe

```
Select recipe or option: 1

╔════════════════════════════════════════════════╗
║  🌐 Simple Web Server (Nginx)                  ║
╚════════════════════════════════════════════════╝

Category: Web
Difficulty: Beginner
Time: 2 min

Description:
Deploy a basic Nginx web server

Services:
  nginx: localhost:8080 → 80/tcp

Deploy this recipe? (y/n): y

Deploying...
✓ Recipe deployed successfully!

Access Instructions:
  kubectl port-forward svc/nginx 8080:80
  Visit: http://localhost:8080
```

---

## 📚 Available Recipes

### 1️⃣ Simple Web Server (Nginx)

**Category:** Web | **Difficulty:** Beginner | **Time:** 2 min

**What it does:**
- Deploys a basic Nginx web server
- Exposes port 80
- Simple health checks included

**Access:**
```bash
kubectl port-forward svc/nginx 8080:80
# Visit: http://localhost:8080
```

**Commands:**
```bash
# View status
kubectl get pods -l app=nginx

# View logs
kubectl logs -f deployment/nginx

# Delete
kubectl delete deployment nginx
```

---

### 2️⃣ PostgreSQL Database

**Category:** Database | **Difficulty:** Intermediate | **Time:** 3 min

**What it does:**
- Deploys PostgreSQL 15
- Persistent storage configured
- Default credentials provided

**Credentials:**
- Username: `postgres`
- Password: `postgres123`

**Access:**
```bash
kubectl port-forward svc/postgres 5432:5432

# Connect with psql
psql -h localhost -U postgres
```

**Example Queries:**
```sql
-- List databases
\l

-- Create database
CREATE DATABASE myapp;

-- Connect to database
\c myapp

-- Create table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);
```

**Commands:**
```bash
# View status
kubectl get pods -l app=postgres

# View logs
kubectl logs -f deployment/postgres

# Backup database
kubectl exec -it <pod-name> -- pg_dump myapp > backup.sql
```

---

### 3️⃣ MongoDB NoSQL Database

**Category:** Database | **Difficulty:** Intermediate | **Time:** 3 min

**What it does:**
- Deploys MongoDB 6.0
- Document database for flexible schema
- Persistent storage included

**Credentials:**
- Username: `admin`
- Password: `admin123`

**Access:**
```bash
kubectl port-forward svc/mongodb 27017:27017

# Connect with mongo
mongo localhost:27017 -u admin -p admin123
```

**Example Commands:**
```javascript
// Switch to database
use myapp

// Create collection and insert
db.users.insertOne({
  name: "John Doe",
  email: "john@example.com"
})

// Find documents
db.users.find()

// Update document
db.users.updateOne(
  { name: "John Doe" },
  { $set: { email: "john.doe@example.com" } }
)
```

---

### 4️⃣ Redis Cache

**Category:** Cache | **Difficulty:** Beginner | **Time:** 2 min

**What it does:**
- Deploys Redis 7 (in-memory data store)
- Perfect for caching and sessions
- Minimal resource footprint

**Access:**
```bash
kubectl port-forward svc/redis 6379:6379

# Connect with redis-cli
redis-cli -h localhost
```

**Example Commands:**
```bash
# Set and get keys
SET mykey "Hello"
GET mykey

# Set expiration
SET session_123 "user_data" EX 3600

# Increment counter
INCR visits:user:123

# List operations
LPUSH mylist "item1"
RPUSH mylist "item2"
LRANGE mylist 0 -1
```

---

### 5️⃣ Multi-Tier Application

**Category:** Full Stack | **Difficulty:** Advanced | **Time:** 5 min

**What it does:**
- Frontend application (React/Next.js)
- Backend API server
- PostgreSQL database
- All interconnected

**Services:**
- Frontend: localhost:3000
- Backend API: localhost:5000
- Database: PostgreSQL

**Access:**
```bash
# Frontend
kubectl port-forward svc/frontend 3000:3000
# Visit: http://localhost:3000

# Backend API
kubectl port-forward svc/backend 5000:5000
# Visit: http://localhost:5000
```

**Architecture:**
```
┌─────────────────┐
│   Browser       │
└────────┬────────┘
         │ :3000
    ┌────▼────────┐
    │  Frontend   │
    │  (React)    │
    └────┬────────┘
         │ API calls
    ┌────▼────────┐
    │  Backend    │
    │  (API)      │
    └────┬────────┘
         │ SQL
    ┌────▼────────┐
    │ PostgreSQL  │
    │ Database    │
    └─────────────┘
```

---

### 6️⃣ RabbitMQ Message Queue

**Category:** Messaging | **Difficulty:** Intermediate | **Time:** 3 min

**What it does:**
- Deploys RabbitMQ message broker
- Advanced message queuing
- Management UI included

**Credentials:**
- Username: `admin`
- Password: `admin`

**Access:**
```bash
# Broker
kubectl port-forward svc/rabbitmq 5672:5672

# Management UI
kubectl port-forward svc/rabbitmq 15672:15672
# Visit: http://localhost:15672
```

**Usage Example (Python):**
```python
import pika

# Connect
connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost')
)
channel = connection.channel()

# Declare queue
channel.queue_declare(queue='hello')

# Publish
channel.basic_publish(
    exchange='',
    routing_key='hello',
    body='Hello World!'
)

# Consume
def callback(ch, method, properties, body):
    print(f"Received: {body}")

channel.basic_consume(
    queue='hello',
    on_message_callback=callback,
    auto_ack=True
)

channel.start_consuming()
```

---

### 7️⃣ Application with Logging

**Category:** Logging | **Difficulty:** Intermediate | **Time:** 3 min

**What it does:**
- Deploys application with structured logging
- JSON-formatted logs for easy parsing
- Integration with logging stacks

**Access:**
```bash
# Application
kubectl port-forward svc/app 8000:8000

# View logs
kubectl logs -f deployment/app

# Follow with grep
kubectl logs -f deployment/app | grep ERROR
```

**Logging Example:**
```bash
# View logs in JSON format
kubectl logs deployment/app -f | jq .

# Filter by level
kubectl logs deployment/app | jq 'select(.level=="ERROR")'

# Stream to file
kubectl logs deployment/app > app.log
```

---

### 8️⃣ Application with Tracing

**Category:** Tracing | **Difficulty:** Intermediate | **Time:** 3 min

**What it does:**
- Deploys application with distributed tracing
- Integration with Jaeger
- OpenTelemetry support

**Access:**
```bash
# Application
kubectl port-forward svc/app 8001:8001

# Jaeger UI (if installed)
kubectl port-forward svc/jaeger-query 16686:16686
# Visit: http://localhost:16686
```

**View Traces:**
1. Deploy the recipe
2. Make requests to the application
3. Open Jaeger UI
4. View trace waterfall diagrams
5. Analyze service latencies

---

### 9️⃣ Load Testing Application

**Category:** Testing | **Difficulty:** Intermediate | **Time:** 4 min

**What it does:**
- Deploys application with load testing tools
- Apache Bench included
- Performance measurement

**Access:**
```bash
kubectl port-forward svc/app 8002:8002

# Run load test
ab -n 1000 -c 10 http://localhost:8002

# View metrics
kubectl top pods

# Monitor in real-time
watch -n 1 'kubectl top pods'
```

**Test Examples:**
```bash
# Simple request
ab -n 100 -c 1 http://localhost:8002/

# Concurrent requests
ab -n 1000 -c 50 http://localhost:8002/

# With custom headers
ab -H "Authorization: Bearer token" \
   -n 100 -c 10 http://localhost:8002/api
```

---

### 🔟 Redis Cluster (StatefulSet)

**Category:** Stateful | **Difficulty:** Advanced | **Time:** 5 min

**What it does:**
- Deploys Redis using StatefulSet
- Persistent storage for each pod
- Network identity for cluster coordination

**Access:**
```bash
kubectl port-forward svc/redis 6379:6379

# Connect
redis-cli -h localhost
```

**Characteristics:**
```bash
# View StatefulSet
kubectl get statefulsets

# View persistent volumes
kubectl get pvc

# Scale
kubectl scale statefulset redis --replicas=5

# Monitor
kubectl logs -f statefulset/redis
```

---

### 1️⃣1️⃣ Jenkins CI/CD

**Category:** CI/CD | **Difficulty:** Advanced | **Time:** 5 min

**What it does:**
- Deploys Jenkins automation server
- CI/CD pipeline orchestration
- Kubernetes integration built-in

**Access:**
```bash
kubectl port-forward svc/jenkins 8080:8080
# Visit: http://localhost:8080
```

**Initial Setup:**
1. Visit Jenkins UI
2. Get initial admin password: `kubectl logs deployment/jenkins`
3. Follow setup wizard
4. Install recommended plugins
5. Create first user
6. Configure Kubernetes plugin

**Example Pipeline:**
```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'npm test'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to Minikube...'
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}
```

---

### 1️⃣2️⃣ Kong API Gateway

**Category:** API | **Difficulty:** Advanced | **Time:** 4 min

**What it does:**
- Deploys Kong API Gateway
- Microservice routing and management
- Admin API for configuration

**Access:**
```bash
# API Gateway
kubectl port-forward svc/kong 8000:8000

# Admin API
kubectl port-forward svc/kong 8001:8001
# Visit: http://localhost:8001
```

**Example Configuration:**
```bash
# Add upstream (backend service)
curl -X POST http://localhost:8001/upstreams \
  -d "name=myservice"

# Add service
curl -X POST http://localhost:8001/services \
  -d "name=myservice" \
  -d "host=myservice" \
  -d "port=5000"

# Add route
curl -X POST http://localhost:8001/services/myservice/routes \
  -d "hosts=localhost"

# Test route
curl -H "Host: localhost" http://localhost:8000/
```

---

## 🎯 Recipe Selection Guide

**Choose by Use Case:**

| Use Case | Recipe | Difficulty |
|----------|--------|-----------|
| Learn Kubernetes basics | Web Server | Beginner |
| Test database | PostgreSQL or MongoDB | Intermediate |
| Build full-stack app | Multi-Tier Application | Advanced |
| Message queue testing | RabbitMQ | Intermediate |
| Monitor application | Logging or Tracing | Intermediate |
| Performance testing | Load Testing | Intermediate |
| Production-like setup | Multi-service with StatefulSet | Advanced |
| CI/CD pipeline | Jenkins | Advanced |
| API management | Kong Gateway | Advanced |

**Choose by Difficulty:**

- **Beginner:** Web Server, Redis Cache
- **Intermediate:** PostgreSQL, MongoDB, RabbitMQ, Logging, Tracing, Load Testing
- **Advanced:** Multi-Tier App, Redis Cluster, Jenkins, Kong Gateway

---

## 📊 Recipe Comparison

```
┌─────────────────────┬────────────┬────────────┬──────────┐
│ Recipe              │ Category   │ Time       │ Skill    │
├─────────────────────┼────────────┼────────────┼──────────┤
│ Nginx               │ Web        │ 2 min      │ Beginner │
│ PostgreSQL          │ Database   │ 3 min      │ Intermediate │
│ MongoDB             │ Database   │ 3 min      │ Intermediate │
│ Redis               │ Cache      │ 2 min      │ Beginner │
│ Multi-Tier App      │ Full Stack │ 5 min      │ Advanced │
│ RabbitMQ            │ Messaging  │ 3 min      │ Intermediate │
│ Logging App         │ Logging    │ 3 min      │ Intermediate │
│ Tracing App         │ Tracing    │ 3 min      │ Intermediate │
│ Load Testing        │ Testing    │ 4 min      │ Intermediate │
│ Redis Cluster       │ Stateful   │ 5 min      │ Advanced │
│ Jenkins             │ CI/CD      │ 5 min      │ Advanced │
│ Kong Gateway        │ API        │ 4 min      │ Advanced │
└─────────────────────┴────────────┴────────────┴──────────┘
```

---

## 🔄 Common Workflows

### Workflow 1: Learning Path

```bash
# 1. Start with simple web server
./scripts/minikube-recipes.sh
# Select: 1

# 2. Deploy Redis cache
# Select: 4

# 3. Deploy PostgreSQL database
# Select: 2

# 4. Explore multi-tier app
# Select: 5
```

### Workflow 2: Full-Stack Development

```bash
# 1. Deploy PostgreSQL
./scripts/minikube-recipes.sh
# Select: 2

# 2. Deploy Redis for caching
# Select: 4

# 3. Deploy RabbitMQ for messaging
# Select: 6

# 4. Deploy multi-tier app
# Select: 5
```

### Workflow 3: Production Testing

```bash
# 1. Deploy multi-tier application
./scripts/minikube-recipes.sh
# Select: 5

# 2. Add logging
# Select: 7

# 3. Add tracing
# Select: 8

# 4. Run load tests
# Select: 9
```

---

## 📖 Documentation Integration

**For Each Recipe:**
- Full deployment documentation
- Access instructions
- Example commands
- Troubleshooting tips
- Integration guides

**Open Documentation:**
- Type `y` when asked "Open documentation?"
- Automatically opens in your default browser
- Or view locally in repository files

---

## 🧹 Managing Recipes

### View Deployed Applications

```bash
./scripts/minikube-recipes.sh
# Select: D (Show Deployed Apps)

# Or manually
kubectl get all -A
```

### Delete a Recipe

```bash
# Option 1: Via script
./scripts/minikube-recipes.sh
# Select recipe number
# Confirm deletion

# Option 2: Manually
kubectl delete -f examples/recipe-name.yaml
```

### Scale Application

```bash
# Scale to 3 replicas
kubectl scale deployment nginx --replicas=3

# Auto-scale based on CPU
kubectl autoscale deployment nginx --min=1 --max=5 --cpu-percent=70
```

---

## 🐛 Troubleshooting

### Recipe Deploy Fails

**Check prerequisites:**
```bash
minikube status
kubectl get nodes
```

**View error logs:**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Cannot Connect to Service

**Port forwarding issues:**
```bash
# List all services
kubectl get svc

# Forward manually
kubectl port-forward svc/servicename 8080:80
```

### Recipe Stuck in Pending

**Check resource availability:**
```bash
kubectl describe pod <pod-name>
kubectl top nodes
```

---

## 📚 Additional Resources

- **Kubernetes Docs:** https://kubernetes.io/docs/
- **Minikube Docs:** https://minikube.sigs.k8s.io/
- **Official Service Docs:**
  - Nginx: https://nginx.org/docs/
  - PostgreSQL: https://www.postgresql.org/docs/
  - MongoDB: https://docs.mongodb.com/
  - Redis: https://redis.io/documentation
  - RabbitMQ: https://www.rabbitmq.com/documentation.html

---

## 🎓 Learning Path

1. **Start:** Web Server recipe (2 min)
2. **Learn:** How to expose and access services
3. **Progress:** Deploy database recipes
4. **Build:** Multi-tier application
5. **Explore:** Advanced features (logging, tracing)
6. **Master:** Create your own recipes

---

**Version:** 1.0.0
**Status:** Production Ready ✅
**Last Updated:** 2025-12-03

**📋 Ready to deploy applications!**
