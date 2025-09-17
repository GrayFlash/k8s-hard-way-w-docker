# k8s-hard-way-w-docker

Check [docs/setup.md](docs/setup.md).

## Architecture Overview

### Dockerfile.jumpbox (Administration Container)

- **Purpose**: Lightweight container for cluster administration
- **Base**: Ubuntu/Debian with essential tools
- **Tools**: Contains kubectl, SSH, and other Kubernetes management utilities
- **Role**: Your "control center" for running tutorial commands

### Dockerfile.k8s (Kubernetes Node Container)

- **Purpose**: Full systemd-enabled container for running Kubernetes components
- **Base**: Ubuntu/Debian with systemd support
- **Features**:
  - Privileged container capability for running services
  - SSH server for inter-container communication
  - Runtime for etcd, kubelet, kube-proxy, etc.
- **Role**: Used for both control plane (server) and worker nodes (node-0, node-1)

### docker-compose.yml (Orchestration)

Creates a 4-container cluster:

```text
jumpbox (172.20.0.2)    → Administration
├─ server (172.20.0.10)   → Control plane (etcd, API server, etc.)
├─ node-0 (172.20.0.20)   → Worker (Pod subnet: 10.200.0.0/24)
└─ node-1 (172.20.0.21)   → Worker (Pod subnet: 10.200.1.0/24)
```

**Key Features:**

- **Static IPs**: Each container gets a fixed IP in 172.20.0.0/16 network
- **Persistent volumes**: Data survives container restarts
- **Privileged mode**: Allows systemd and networking operations
- **Shared workspace**: `/workspace` mounted in all containers

### machines.txt (IP Mapping)

Maps container IPs to hostnames for the tutorial:

```text
172.20.0.10 server.kubernetes.local server
172.20.0.20 node-0.kubernetes.local node-0
172.20.0.21 node-1.kubernetes.local node-1
```

### start-cluster.sh (Automation Script)

- Builds Docker images
- Starts containers via docker-compose
- Configures SSH between containers
- Sets up SSH keys for passwordless access

## How They Work Together

1. **Initialization**: `start-cluster.sh` builds images from the Dockerfiles and starts the cluster
2. **Networking**: All containers can communicate via the bridge network with static IPs
3. **Access**: You can either SSH between containers or use `docker exec` directly
4. **Data Persistence**: Kubernetes data, etcd, and kubelet data persist across restarts
5. **Tutorial Adaptation**: Replaces VMs with containers - same functionality, different access method
