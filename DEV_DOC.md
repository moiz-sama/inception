# Developer Documentation - Inception Project

## Overview
This document provides technical guidance for developers working on the Inception project. It covers environment setup, build processes, container management, and data persistence.

---
## Prerequisites

### System Requirements
- **Operating System**: Linux (Debian/Ubuntu recommended) or macOS
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: 20GB free space

### Required Software

**1. Docker Engine**
```bash
# Check if Docker is installed
docker --version

# Install Docker (Ubuntu/Debian)
sudo apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
or
curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group (to run without sudo)
sudo usermod -aG docker $USER
```

**2. Docker Compose**
```bash
# Check if Docker Compose is installed
docker compose version
```

**3. Make**
```bash
# Check if Make is installed
make --version

# Install Make
sudo apt-get install build-essential
```

**4. Additional Tools (Optional but Recommended)**
```bash
# Git
sudo apt-get install git
# Text editors
sudo apt-get install vim
```
---

## Environment Setup

### 1. Clone the Repository
```bash
git clone https://github.com/moiz-sama/inception.git
cd inception
```

### 2. Configure Domain Name

Add the domain to your `/etc/hosts` file:
```bash
sudo vim /etc/hosts
```

Add this line:
```
127.0.0.1 saderdou.42.fr
```

Or use this one-liner:
```bash
sudo sh -c 'echo "127.0.0.1 saderdou.42.fr" >> /etc/hosts'
```

### 3. Create Environment Variables File

Navigate to the srcs directory and create the `.env` file:
```bash
cd srcs
vim .env
```

**Security Notes:**
- Use strong, unique passwords for each variable
- Never commit `.env` to version control (already in `.gitignore`)

### 4. Create Data Directories

Create directories for persistent data:
```bash
mkdir -p ~/data/wordpress
mkdir -p ~/data/mariadb
```
---

## Project Structure
```
inception/
├── Makefile                    # Main build and management commands
├── README.md                   # Project overview
├── USER_DOC.md                 # User documentation
├── DEV_DOC.md                  # Developer documentation (this file)
│
└── srcs/
    ├── .env                    # Environment variables (gitignored)
    ├── docker-compose.yml      # Docker Compose configuration
    │
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile      # MariaDB container definition
        │   ├── conf/           # MariaDB configuration files
        │   └── tools/          # Setup and initialization scripts
        │
        ├── nginx/
        │   ├── Dockerfile      # NGINX container definition
        │   ├── conf/           # NGINX configuration files
        │   └── tools/          # SSL certificate generation scripts
        │
        └── wordpress/
            ├── Dockerfile      # WordPress container definition
            ├── conf/           # WordPress configuration files
            └── tools/          # WordPress setup scripts
```

---

## Building and Launching

### Using Makefile (Recommended)

The Makefile provides convenient commands for managing the project:

** Build and Start Everything:**
```bash
make
```
This command:
- Builds all Docker images from Dockerfiles
- Creates necessary networks and volumes
- Starts all containers in detached mode
- Displays container status

### Using Docker Compose Directly

**Start services:**
```bash
docker compose up -d
```

**Stop services:**
```bash
docker compose down
```

**Rebuild specific service:**
```bash
docker compose build nginx
docker compose up -d nginx
```

---

## Container Management

### Viewing Container Status

**List running containers:**
```bash
docker ps
```

**List all containers (including stopped):**
```bash
docker ps -a
```

**View container details:**
```bash
docker inspect <container_name>
```

**View container resource usage:**
```bash
docker stats
```

### Starting and Stopping Containers

**Start all containers:**
```bash
docker compose -f srcs/docker-compose.yml -p inception up -d
```

**Stop all containers:**
```bash
docker compose -f srcs/docker-compose.yml -p inception down
```

**Restart specific container:**
```bash
docker restart nginx
docker restart wordpress
docker restart mariadb
```

**Stop specific container:**
```bash
docker stop <container_name>
```

**Start specific container:**
```bash
docker start <container_name>
```

### Accessing Containers

**Execute commands in running container:**
```bash
docker exec -it nginx sh
docker exec -it wordpress bash
docker exec -it mariadb sh
```
### Viewing Logs

**View logs for specific container:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Follow logs in real-time:**
```bash
docker logs -f nginx
```

**View last N lines of logs:**
```bash
docker logs --tail 50 wordpress
```
---

## Volume Management

### Understanding Volumes

The project uses **bind mounts** to persist data at specific host locations:

- **WordPress files**: `~/data/wordpress` → `/wordpress` (in container)
- **MariaDB data**: `~/data/mariadb` → `/var/lib/mysql` (in container)

### Viewing Volume Data

**List all volumes:**
```bash
docker volume ls
```

**Inspect volume:**
```bash
docker volume inspect <volume_name>
```

**View WordPress files:**
```bash
ls -la ~/data/wordpress/
```

**View MariaDB data:**
```bash
ls -la ~/data/mariadb/
```
### Cleaning Up Volumes

**Remove all project volumes (WARNING: Deletes all data!):**
```bash
make fclean
```
---

## Data Persistence

### How Data Persists

**1. Volume Mounts in docker-compose.yml:**
```yaml
volumes:
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/${USER}/data/wordpress

  mariadb_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/${USER}/data/mariadb
```
```bash
volumes: - Defines storage volumes
  wordpress_data: - Names this volume
    driver: local - Stores on local machine
    driver_opts: - Custom configuration
      type: none - No special filesystem
      o: bind - Use bind mount (not volume mount)
      device: /home/saderdou/data/wordpress - Host directory path
```

**2. Data Flow:**
```
Container Filesystem → Bind Mount → Host Directory
/wordpress       →    volume   → ~/data/wordpress
/var/lib/mysql      →    volume   → ~/data/mariadb
```

### Verifying Persistence

**Test WordPress persistence:**
1. Create a new post in WordPress
2. Stop containers: `make down`
3. Start containers: `make`
4. Post should still exist

**Test MariaDB persistence:**
```bash
# Check database files exist
ls -la ~/data/mariadb/

```
---

## Networking

### Docker Network Architecture

The project uses a custom bridge network named `inception_network`:
```
[Host Machine]
       │
       │ Port 443 (HTTPS)
       ↓
[NGINX Container]
       │
       │ Port 9000 (FastCGI)
       ↓
[WordPress Container]
       │
       │ Port 3306 (MySQL)
       ↓
[MariaDB Container]
```

### Network Commands

**List networks:**
```bash
docker network ls
```

**Inspect network:**
```bash
docker network inspect inception_network
```
**Test connectivity between containers:**
```bash
# From NGINX to WordPress
docker exec nginx ping -c 3 wordpress

# From WordPress to MariaDB
docker exec wordpress ping -c 3 mariadb
```
apt-get install -y iputils-ping if ping not found

### Port Mapping

Only NGINX exposes ports to the host:
- **443**: HTTPS (externally accessible)

Internal communication uses container names (DNS resolution):
- WordPress connects to MariaDB via `mariadb:3306`
- NGINX connects to WordPress via `wordpress:9000`

---

## Debugging

### Common Issues and Solutions

#### Issue: Containers won't start

**Check logs:**
```bash
docker compose logs
```

#### Issue: Database connection errors

**Check MariaDB logs:**
```bash
docker logs mariadb
```

**Test database connectivity:**
```bash
docker exec mariadb mysqladmin ping -p
```
### Debugging Commands

**Enter container shell:**
```bash
docker exec -it <container_name> sh
```

**Check running processes:**
```bash
docker exec <container_name> ps aux
```

**Check listening ports:**
```bash
docker exec <container_name> netstat -tulpn
```

**Test HTTP response:**
```bash
curl -k https://saderdou.42.fr
```

### What Survives and What Doesn't

| Event | WordPress Data | MariaDB Data | Containers | Images |
|-------|----------------|--------------|------------|--------|
| `docker compose down` | ✅ Persists | ✅ Persists | ❌ Removed | ✅ Kept |
| `make clean` | ✅ Persists | ✅ Persists | ❌ Removed | ❌ Removed |
| `make fclean` | ❌ Deleted | ❌ Deleted | ❌ Removed | ❌ Removed |
| **VM Reboot** | **✅ Persists** | **✅ Persists** | ❌ Stopped | ✅ Kept |
| Container deletion | ✅ Persists | ✅ Persists | ❌ Removed | ✅ Kept |

**Key Point:** Because we use bind mounts to `~/data/`, data survives everything except `make fclean` which explicitly deletes the host directories.

---

*Last Updated: December 2024*
