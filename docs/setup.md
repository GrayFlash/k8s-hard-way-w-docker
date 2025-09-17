# Local Setup Guide

This guide helps you set up the Kubernetes cluster locally using Docker containers.

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available

## Quick Start

1. **Make the startup script executable:**

   ```bash
   chmod +x start-cluster.sh
   ```

2. **Start the cluster:**

   ```bash
   ./start-cluster.sh
   ```

3. **Verify containers are running:**

   ```bash
   docker-compose ps
   ```

## Container Access

```bash
# Access jumpbox (administration container)
docker exec -it jumpbox bash

# Access control plane
docker exec -it server bash

# Access worker nodes
docker exec -it node-0 bash
docker exec -it node-1 bash
```

## Container Details

| Container | IP Address | Role | Hostname |
|-----------|------------|------|----------|
| jumpbox   | 172.20.0.2 | Administration | jumpbox |
| server    | 172.20.0.10 | Control Plane | server |
| node-0    | 172.20.0.20 | Worker Node | node-0 |
| node-1    | 172.20.0.21 | Worker Node | node-1 |
