#!/bin/bash

set -e  # Прекращать выполнение при ошибках

echo "=== Установка Docker и Docker Compose ==="

# Обновление системы
echo "Обновляем систему..."

echo "Устанавливаем Docker Engine..."
#
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Добавление текущего пользователя в группу docker
echo "Добавляем пользователя в группу docker..."
sudo usermod -aG docker $USER


# Проверка установки
echo "Проверяем установку Docker и Docker Compose..."
docker --version

. ./command_config/install_wizard.sh

eval "docker compose up -d"

echo "=== Установка завершена! ==="
echo "Перезагрузите терминал или выполните: source $CONFIG_FILE"

