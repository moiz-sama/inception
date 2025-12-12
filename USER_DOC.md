# User Documentation - Inception Project

## Overview
This document provides clear instructions for end users and administrators on how to use and manage the Inception infrastructure.

---

## What Services Are Provided

The Inception stack provides a complete web hosting environment with the following services:

### 1. **NGINX Web Server**
- **Purpose**: Serves as the entry point to your infrastructure
- Entry point for all web traffic
- Handles HTTPS connections on port 443
- Provides SSL/TLS encryption
- Forwards requests to WordPress

### 2. **WordPress + PHP-FPM**
- **Purpose**: Content Management System (CMS) for your website
- Content Management System for creating and managing your website
- Create posts, pages, and manage media
- Accessible at https://saderdou.42.fr

### 3. **MariaDB Database**
- **Purpose**: Stores all WordPress data
- Stores all website data (posts, pages, users, settings)
- Runs internally - not accessible from outside
- Data persists even when containers restart

### Service Communication
```
Internet → NGINX (Port 443) → WordPress (PHP-FPM) → MariaDB → Persistent Storage
```

---

## Starting and Stopping the Project

### Starting the Infrastructure

**Option 1: Using Make (Recommended)**
```bash
cd /path/to/inception
make
```

**Option 2: Using Docker Compose Directly**
```bash
cd /path/to/inception/srcs
docker compose up -d
```

**What Happens:**
- All three containers (NGINX, WordPress, MariaDB) will start
- Services will initialize in the correct order
- Your website will be accessible within 30-60 seconds

**Expected Output:**
```
Creating network "inception_network" ...
Creating mariadb ... done
Creating wordpress ... done
Creating nginx ... done
```

### Stopping the Infrastructure

**Option 1: Using Make (Recommended)**
```bash
make down
```

**Option 2: Using Docker Compose Directly**
```bash
cd /path/to/inception/srcs
docker compose down
```

**What Happens:**
- All containers stop gracefully
- Network connections are closed
- Your data remains safe in volumes

### Restarting the Infrastructure

**Complete Rebuild:**
```bash
make re
```

**Quick Restart:**
```bash
make down && make
```

---

## Accessing the Website and Administration Panel

### Accessing the Public Website

1. **Open your web browser**
2. **Navigate to**: `https://saderdou.42.fr`
3. **SSL Certificate Warning**:
   - You will see a security warning because the SSL certificate is self-signed
   - This is **normal and expected** for local development
   - Click **"Advanced"** → **"Proceed to saderdou.42.fr"** (or similar)

### Accessing WordPress Admin Panel

1. **Navigate to**: `https://saderdou.42.fr/wp-admin`
2. **Enter your credentials** (see next section)
3. **You're now in the WordPress Dashboard** where you can:
   - Create and edit posts/pages
   - Manage themes and plugins
   - Configure site settings
   - Manage users

### First-Time Access

If this is your first time accessing the site after setup:
- The WordPress installation may be complete already
- Use the administrator credentials from your `.env` file
- The non-admin user credentials are also available in `.env`

---

## Locating and Managing Credentials

### Where Credentials Are Stored

All sensitive credentials are stored in the `.env` file located at:
```
/path/to/inception/srcs/.env
```

### Viewing Your Credentials

**Method 1: Using a Text Editor**
```bash
vim srcs/.env
# or
cat srcs/.env
```

### Credential Types in .env
```bash
# Domain Configuration
DOMAIN_NAME=saderdou.42.fr

# WordPress Admin Account
SITE_TITLE="inception"
ADMIN_USER=admin_username
ADMIN_PASSWORD=secure_password_here
ADMIN_EMAIL=admin@example.com

# WordPress Regular User
WP_USER=regular_user
WP_USER_PASSWORD=user_password_here
WP_USER_EMAIL=user@example.com

# Database WordPress User
DB_NAME=wordpress
DB_USER=wp_database_user
DB_PASS=database_user_password
```

### Changing Credentials

⚠️ **Important**: Changing credentials after initial setup requires rebuilding the infrastructure.

**Steps to Change Credentials:**

1. **Stop the infrastructure:**
```bash
   make down
```

2. **Edit the .env file:**
```bash
   vim srcs/.env
```

3. **Clean existing data (if necessary):**
```bash
   make fclean  # This will delete all data!
```

4. **Rebuild and restart:**
```bash
   make
```

### Security Best Practices

- ✅ **Never commit** `.env` to Git (it's gitignored by default)
- ✅ **Backup** your `.env` file securely

---

## Checking Service Status

**Check if all containers are running:**
```bash
docker ps
```

**Expected Output:**
```
CONTAINER ID   IMAGE              STATUS         PORTS                   NAMES
abc123def456   nginx:saderdou    Up 2 minutes   0.0.0.0:443->443/tcp   nginx
def456ghi789   wordpress:saderdou Up 2 minutes   9000/tcp               wordpress
ghi789jkl012   mariadb:saderdou   Up 2 minutes   3306/tcp               mariadb
```

**All three containers should show "Up" status.**

### Detailed Service Checks

#### 1. NGINX Status

**Check if NGINX is responding:**
```bash
curl -k https://saderdou.42.fr
```

**Expected**: HTML content from WordPress

**Check NGINX logs:**
```bash
docker logs nginx
```

#### 2. WordPress Status

**Check WordPress container:**
```bash
docker exec wordpress ps aux | grep php-fpm
```

**Expected**: Multiple php-fpm processes running

**Check WordPress logs:**
```bash
docker logs wordpress
```

#### 3. MariaDB Status

**Check database connectivity:**
```bash
docker exec mariadb mysqladmin ping -p
```
**Expected Output**: `mysqld is alive`

**Check MariaDB logs:**
```bash
docker logs mariadb
```

### Testing Website Functionality

**Access Test:**
1. Open browser: `https://saderdou.42.fr`
2. Page should load within 3 seconds
3. No PHP errors should appear

**Admin Panel Test:**
1. Go to: `https://saderdou.42.fr/wp-admin`
2. Login with admin credentials
3. Dashboard should load successfully

**Database Test:**
1. Create a new post in WordPress
2. Publish it
3. View it on the frontend
4. Restart containers: `make down && make`
5. Post should still be there (persistence test)

#### Problem: Website Not Loading

**Verify domain resolution:**
```bash
ping saderdou.42.fr
```
**Should return**: `127.0.0.1`

**If not, add to /etc/hosts:**
```bash
sudo sh -c 'echo "127.0.0.1 saderdou.42.fr" >> /etc/hosts'
```

#### Problem: SSL Certificate Errors Persist

**This is normal for self-signed certificates.**
- Simply click "Advanced" and proceed

### Viewing Logs
```bash
docker logs -f nginx
docker logs -f wordpress
docker logs -f mariadb
```

Press `Ctrl+C` to exit log viewing.

### Checking Data Persistence

**View WordPress files:**
```bash
ls -la ~/data/wordpress/
```

**View database files:**
```bash
ls -la ~/data/mariadb/
```

These directories should contain data even after stopping containers.

---

## Quick Reference Commands

| Action | Command |
|--------|---------|
| Start infrastructure | `make` |
| Stop infrastructure | `make down` |
| View running containers | `docker ps` |
| Access WordPress CLI | `docker exec -it wordpress bash` |
| Access MariaDB CLI | `docker exec -it mariadb mysql ` |
| Check NGINX config | `docker exec nginx nginx -t` |
| Restart single service | `docker restart <container_name>` |
| Complete cleanup | `make fclean` |
| Rebuild everything | `make re` |

---

## Getting Help

### Access Container Shell
```bash
docker exec -it <container_name> bash
```

### View Container Resource Usage
```bash
docker stats
```

---

*Last Updated: December 2024*
