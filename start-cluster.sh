#!/bin/bash

echo "🐳 Starting Kubernetes The Hard Way with Docker..."

# Build and start containers
echo "Building Docker images..."
docker-compose build

echo "Starting containers..."
docker-compose up -d

# Wait for containers to be ready
echo "Waiting for containers to start..."
sleep 10

# Configure SSH in each container
echo "Setting up SSH access in containers..."

containers=("server" "node-0" "node-1")
for container in "${containers[@]}"; do
    echo "Configuring $container..."

    # Start SSH service
    docker exec "$container" systemctl start ssh
    docker exec "$container" systemctl enable ssh

    # Generate SSH key if not exists
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa
    fi

    # Copy SSH key to container
    docker exec "$container" mkdir -p /root/.ssh
    docker cp ~/.ssh/id_rsa.pub "$container":/root/.ssh/authorized_keys
    docker exec "$container" chmod 600 /root/.ssh/authorized_keys
    docker exec "$container" chmod 700 /root/.ssh
done

echo "Cluster is ready!!!!!"
echo ""
echo "Next steps:"
echo "1. Connect to jumpbox: docker exec -it jumpbox bash"
echo "2. Follow the tutorial starting from lab 04 (certificates)"
echo "3. Use these container names instead of SSH:"
echo "   - server: docker exec -it server bash"
echo "   - node-0: docker exec -it node-0 bash"
echo "   - node-1: docker exec -it node-1 bash"
echo ""
echo "Container IPs:"
echo "   - jumpbox: 172.20.0.2"
echo "   - server:  172.20.0.10"
echo "   - node-0:  172.20.0.20"
echo "   - node-1:  172.20.0.21"