#!/usr/bin/env bash
# ==============================================================================
# PROYECTO FINAL: INFRAESTRUCTURA DE TI - EXPRESO BRASILIA S.A.
# Universidad del Quindío - Facultad de Ingeniería de Sistemas y Computación
# Script de aprovisionamiento automatizado: Dokploy PaaS + Servicios Linux
# ==============================================================================

set -euo pipefail

echo "=========================================================="
echo " [1/7] Actualizando repositorios y paquetes del sistema... "
echo "=========================================================="
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git ufw net-tools chrony nfs-kernel-server nis cups samba smbclient

echo "=========================================================="
echo " [2/7] Instalando Dokploy PaaS (Docker Swarm + Traefik)... "
echo "=========================================================="
if ! command -v dokploy &> /dev/null; then
    curl -sSL https://dokploy.com/install.sh | sh
fi

echo "=========================================================="
echo " [3/7] Configurando Servicio NTP (Sincronización Horaria). "
echo "=========================================================="
sudo cp /etc/ntp.conf /etc/ntp.conf.bak 2>/dev/null || true
sudo cp ./ntp.conf /etc/ntp.conf 2>/dev/null || true
sudo systemctl restart chrony || sudo systemctl restart ntp
sudo systemctl enable chrony || sudo systemctl enable ntp

echo "=========================================================="
echo " [4/7] Configurando Servidor NFS (Almacenamiento Linux)... "
echo "=========================================================="
sudo mkdir -p /srv/nfs/brasilia/manuales_flota /srv/nfs/brasilia/telemetria_buses
sudo chown -R nobody:nogroup /srv/nfs/brasilia
sudo chmod -R 777 /srv/nfs/brasilia
sudo cp ./exports /etc/exports 2>/dev/null || true
sudo exportfs -ra
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server

echo "=========================================================="
echo " [5/7] Configurando Servidor de Impresión CUPS (Tiquetes). "
echo "=========================================================="
sudo cp ./cupsd.conf /etc/cups/cupsd.conf 2>/dev/null || true
sudo usermod -aG lpadmin "${USER}"
sudo systemctl restart cups
sudo systemctl enable cups

echo "=========================================================="
echo " [6/7] Configurando Servidor de Archivos Samba (Windows).. "
echo "=========================================================="
sudo mkdir -p /srv/samba/brasilia /srv/samba/publico
sudo groupadd -f sambausers
sudo usermod -aG sambausers "${USER}"
sudo chown -R "${USER}":sambausers /srv/samba/brasilia
sudo chmod -R 775 /srv/samba/brasilia
sudo chown -R nobody:nogroup /srv/samba/publico
sudo chmod -R 755 /srv/samba/publico
sudo cp ./smb.conf /etc/samba/smb.conf 2>/dev/null || true
sudo systemctl restart smbd nmbd
sudo systemctl enable smbd nmbd

echo "=========================================================="
echo " [7/7] Configurando Firewall UFW (Seguridad y Endurecimiento)"
echo "=========================================================="
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH Administracion'
sudo ufw allow 80/tcp comment 'HTTP Traefik'
sudo ufw allow 443/tcp comment 'HTTPS Traefik SSL'
sudo ufw allow 3000/tcp comment 'Dokploy Panel Web'
sudo ufw allow 123/udp comment 'NTP Tiempo'
sudo ufw allow 2049/tcp comment 'NFS Archivos'
sudo ufw allow 111/tcp comment 'RPC Portmapper'
sudo ufw allow 111/udp comment 'RPC Portmapper'
sudo ufw allow 631/tcp comment 'CUPS Impresion IPP'
sudo ufw allow 445/tcp comment 'Samba SMB'
sudo ufw allow 139/tcp comment 'Samba NetBIOS'
sudo ufw --force enable

echo "=========================================================="
echo " ¡Aprovisionamiento de Expreso Brasilia completado con éxito! "
echo " Dokploy disponible en: http://$(hostname -I | awk '{print $1}'):3000 "
echo " CUPS disponible en: https://$(hostname -I | awk '{print $1}'):631 "
echo "=========================================================="
