#!/bin/bash

set -e

### --- BASE SYSTEM UPDATE AND ESSENTIAL TOOLS --- ###
echo "\n🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  build-essential \
  dkms \
  linux-headers-$(uname -r) \
  git \
  curl \
  wget \
  unzip \
  htop \
  net-tools \
  gnupg \
  ca-certificates \
  software-properties-common \
  ufw \
  apparmor \
  apparmor-utils \
  flatpak \
  snapd \
  kodi \
  docker.io \
  docker-compose \
  nginx

### --- SECURITY CONFIG --- ###
echo "\n🔐 Enabling unattended security updates..."
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

echo "\n🛡️ Configuring UFW firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable

### --- FLATPAK SETUP --- ###
echo "\n📦 Adding Flathub to Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

### --- JELLYFIN INSTALLATION --- ###
echo "\n🎞️ Installing Jellyfin..."
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/jellyfin.gpg
echo "deb [signed-by=/usr/share/keyrings/jellyfin.gpg] https://repo.jellyfin.org/debian bullseye main" | sudo tee /etc/apt/sources.list.d/jellyfin.list

sudo apt update && sudo apt install -y jellyfin

### --- NEXTCLOUD INSTALL (via Docker) --- ###
echo "\n☁️ Setting up Nextcloud container..."
sudo mkdir -p /opt/nextcloud
cd /opt/nextcloud

cat > docker-compose.yml <<EOF
version: '3'
services:
  db:
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: ncuser
      MYSQL_PASSWORD: ncpass
    volumes:
      - db:/var/lib/mysql

  app:
    image: nextcloud
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    restart: always
    environment:
      MYSQL_PASSWORD: ncpass
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: ncuser
      MYSQL_HOST: db

volumes:
  db:
  nextcloud:
EOF

sudo docker-compose up -d

### --- BITWARDEN (vaultwarden) --- ###
echo "\n🔑 Installing Vaultwarden (Bitwarden alternative)..."
sudo mkdir -p /opt/vaultwarden
cd /opt/vaultwarden

cat > docker-compose.yml <<EOF
version: '3'
services:
  vaultwarden:
    image: vaultwarden/server
    container_name: vaultwarden
    restart: always
    ports:
      - 8222:80
    volumes:
      - ./vw-data:/data
EOF

sudo docker-compose up -d

### --- PI-HOLE INSTALL --- ###
echo "\n🚫 Installing Pi-hole..."
sudo mkdir -p /opt/pihole
cd /opt/pihole

cat > docker-compose.yml <<EOF
version: "3"
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    environment:
      TZ: 'Europe/London'
      WEBPASSWORD: 'changeme'
    volumes:
      - './etc-pihole:/etc/pihole'
      - './etc-dnsmasq.d:/etc/dnsmasq.d'
    dns:
      - 127.0.0.1
      - 1.1.1.1
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "8053:80"
    restart: unless-stopped
EOF

sudo docker-compose up -d

### --- DASHY INSTALL --- ###
echo "\n📊 Setting up Dashy dashboard..."
sudo mkdir -p /opt/dashy
cd /opt/dashy

cat > docker-compose.yml <<EOF
version: '3.8'
services:
  dashy:
    image: lissy93/dashy:latest
    container_name: dashy
    ports:
      - 8081:80
    volumes:
      - ./config/conf.yml:/app/public/conf.yml
    restart: always
EOF

sudo docker-compose up -d

### --- LOCAL NGINX CONFIG --- ###
echo "\n🔁 Setting up local Nginx reverse proxy (no SSL)..."
sudo mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

cat > /etc/nginx/sites-available/selfhost <<EOF
server {
    listen 80;
    server_name localhost;

    location /jellyfin/ {
        proxy_pass http://localhost:8096/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /nextcloud/ {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /vaultwarden/ {
        proxy_pass http://localhost:8222/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/selfhost /etc/nginx/sites-enabled/selfhost
sudo nginx -t && sudo systemctl restart nginx

### --- CLEANUP --- ###
echo "\n🧹 Final cleanup..."
sudo apt autoremove -y
sudo apt clean

### --- DONE --- ###
echo "\n✅ Setup complete. Access services locally at:
- Jellyfin: http://localhost/jellyfin
- Nextcloud: http://localhost/nextcloud
- Vaultwarden: http://localhost/vaultwarden
- Pi-hole: http://localhost:8053
- Dashy: http://localhost:8081"
