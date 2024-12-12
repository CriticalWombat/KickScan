#!/bin/bash

# Function to log messages
log() {
    echo "[INFO] $1"
}

# Function to install Docker on Ubuntu
install_docker_ubuntu() {
    log "Detected Ubuntu-based distribution."

    # Check if OS is Kali Linux
    if grep -qi kali /etc/os-release; then
        log "Detected Kali Linux. Setting codename to bookworm."
        CODENAME="bookworm"
    else
        CODENAME=$(lsb_release -cs)
    fi

    log "Removing conflicting Docker packages."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc

    log "Updating package index."
    sudo apt-get update

    log "Installing prerequisites."
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    log "Adding Docker's official GPG key."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    log "Setting up Docker repository."
    echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $CODENAME stable\" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    log "Updating package index again."
    sudo apt-get update

    log "Installing Docker."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    log "Docker installation on Ubuntu-based distribution complete."
}

# Function to install Docker on CentOS
install_docker_centos() {
    log "Detected CentOS-based distribution."

    log "Removing conflicting Docker packages."
    sudo yum remove -y docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine

    log "Installing prerequisites."
    sudo yum install -y yum-utils

    log "Setting up Docker repository."
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    log "Installing Docker."
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    log "Starting and enabling Docker service."
    sudo systemctl start docker
    sudo systemctl enable docker

    log "Docker installation on CentOS complete."
}

# Main script logic
log "Determining operating system."
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" =~ ^(ubuntu|kali)$ ]]; then
        install_docker_ubuntu
    elif [[ "$ID" =~ ^(centos|rocky)$ ]]; then
        install_docker_centos
    else
        log "Unsupported operating system: $ID"
        exit 1
    fi
else
    log "Cannot determine operating system. /etc/os-release not found."
    exit 1
fi
