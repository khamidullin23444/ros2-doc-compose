#!/bin/bash

set -e  # Прекращать выполнение при ошибках

echo "=== Установка Docker и Docker Compose ==="

# Обновление системы
echo "Обновляем систему..."
sudo apt update && sudo apt upgrade -y

# Установка зависимостей
echo "Устанавливаем зависимости..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Добавление официального GPG‑ключа Docker
echo "Добавляем GPG‑ключ Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg

# Настройка репозитория Docker
echo "Настраиваем репозиторий Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Установка Docker Engine
echo "Устанавливаем Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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

