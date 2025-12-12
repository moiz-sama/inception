# inception
This project has been created as part of the 42 curriculum by saderdou.

# Description
Inception is a system administration project that uses Docker to create a small infrastructure of interconnected services. The project deploys a complete web stack using Docker Compose, featuring NGINX as a reverse proxy with SSL/TLS encryption,     WordPress with PHP-FPM for content management, and MariaDB as the database backend.

The goal is to deepen understanding of containerization, microservices architecture, and Docker networking while following security best practices and infrastructure-as-code principles.

# Instructions
### Prerequisites
- Virtual Machine running Debian or Ubuntu
- Docker and Docker Compose installed
- Minimum 4GB RAM and 20GB disk space
- Root or sudo access
### Installation
#### 1. Clone the repository:
```bash
  git clone https://github.com/moiz-sama/inception.git
   cd inception
```
#### 2. Configure environment variables:
Create a .env file in the srcs/ directory :
```bash
  cp srcs/.env.example srcs/.env
```
#### 3. add domain to hosts file:
```bash
  sudo sh -c 'echo "127.0.0.1 saderdou.42.fr" >> /etc/hosts'
```
#### 4. Build and launch:
```bash
  make
```
#### 5. Accessing Services:
- Website: https://saderdou.42.fr
- WordPress Admin: https://saderdou.42.fr/wp-admin
    - username and Password: Check your .env file
- ⚠️ Note: You may see a SSL certificate warning - this is normal for self-signed certificates. Click "Advanced" and proceed.

# Resources
### Documentation
- https://www.ibm.com/think/topics/docker
- https://docs.docker.com/compose/
- https://nginx.org/en/docs/
- https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
- https://www.sslshopper.com/article-most-common-openssl-commands.html
- https://developer.wordpress.org/cli/commands/
- https://developer.wordpress.org/advanced-administration/before-install/howto-install/
- https://mariadb.com/docs/
### Tutorials & Articles
- https://www.digitalocean.com/community/tutorials/php-fpm-nginx
- https://youtu.be/0ke77xqqyts?list=PLU7SiJjVPemcW7GXkfbstrGOPk4YDL8hP
- https://youtu.be/1P54UoBjbDs?list=PLU7SiJjVPemcW7GXkfbstrGOPk4YDL8hP
### AI Usage
- **README Structure**: Used Claude to organize sections according to 42 requirements
  
# Project Description
### Architecture Overview
This project implements a microservices architecture using Docker containers. Each service runs in isolation but communicates through a dedicated Docker network. The infrastructure consists of:
- NGINX Container: Acts as the sole entry point, handling HTTPS connections on port 443
- WordPress Container: Processes PHP requests via PHP-FPM on port 9000
- MariaDB Container: Provides database services on port 3306
Data persistence is achieved through bind-mounted volumes stored in /home/saderdou/data/
### 1. Virtual Machines vs Docker
#### Virtual Machines (VMs):
- Run complete operating systems with their own kernel
- Heavy resource consumption (GB of RAM, significant CPU)
- Slow startup times (minutes)
- Strong isolation but inefficient for microservices
- Each VM includes full OS overhead
#### Docker Containers:
- Share the host OS kernel
- Lightweight (MB of RAM)
- Fast startup (seconds)
- Efficient resource utilization
- Perfect for microservices architecture
#### My choice :
- Faster deployment and scaling
- Efficient resource usage on a single VM
- Better suited for running multiple interconnected services
- Easier to version control and reproduce environments
### 2. Secrets vs Environment Variables
#### Environment Variables (.env file):
- Suitable for non-sensitive configuration
- Examples: domain names, service names, ports
- Easy to manage and modify
#### Docker Secrets:
- Designed for sensitive data (passwords, API keys, certificates)
- Not visible in container inspection
- Stored in /run/secrets/ in containers
#### My choice : 
- .env file for general configuration (domain name, database name, usernames)
### 3. Docker Network vs Host Network
#### Host Network :
- Container uses host's network stack directly, No network isolation
- Security risk - container has full network access, No port mapping needed
#### Docker Network :
- Isolated network for containers
- Containers communicate using service names (DNS resolution)
- Port mapping controls external access
#### My choice :
Custom Docker bridge network (inception_network) because:
- Only NGINX port 443 is exposed to the host
- WordPress and MariaDB remain completely isolated from external access
### 4. Docker Volumes vs Bind Mounts
#### Docker Volumes (Managed by Docker):
- Storage location: /var/lib/docker/volumes/<volume_name>/_data
- Docker manages lifecycle and permissions
#### Bind Mounts (Host Path Specification):
- Storage location: User-specified path (e.g., /home/saderdou/data/)
- User manages lifecycle and permissions
- Easy to backup, access, and modify from host
#### my choice:
Bind mounts to /home/saderdou/data/ because :
- Project requirement: Volumes must be in /home/login/data/
- Easy verification during evaluation

# Data Flow
```bash
User Browser
    ↓
    ↓ HTTPS:443 (TLS encrypted)
    ↓
[NGINX Container]
    ↓
    ↓ FastCGI:9000 (internal network)
    ↓
[WordPress Container]
    ↓
    ↓ MySQL:3306 (internal network)
    ↓
[MariaDB Container]
    ↓
[Persistent Storage: /home/saderdou/data/]
```
# Additional Information
For more detailed information, please refer to:
- [USER_DOC.md](https://github.com/moiz-sama/inception/blob/main/USER_DOC.md) - End-user and administrator guide
- [DEV_DOC.md](https://github.com/moiz-sama/inception/blob/main/DEV_DOC.md)  - Developer setup and management guide

# License
This project is created for educational purposes as part of the 42 school curriculum.
# Author
saderdou - 42 Network Student














