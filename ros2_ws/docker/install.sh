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
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Настройка репозитория Docker
echo "Настраиваем репозиторий Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

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

# Развёртывание контейнера из файла ros2.sh
ROS2_SCRIPT="$HOME/ros2_ws/docker/ros2.sh"

if [ ! -f "$ROS2_SCRIPT" ]; then
    echo "Ошибка: Файл $ROS2_SCRIPT не найден!" >&2
    exit 1
fi

echo "Запускаем развёртывание контейнера из $ROS2_SCRIPT..."
bash "$ROS2_SCRIPT"

# Создание alias
echo "Создаём alias 'ros2' для $ROS2_SCRIPT..."

# Определяем оболочку пользователя
if [ -n "$ZSH_VERSION" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    # По умолчанию используем .bashrc
    CONFIG_FILE="$HOME/.bashrc"
fi

# Добавляем алиас в конфигурационный файл
ALIAS_LINE="alias ros2='$ROS2_SCRIPT'"

if grep -q "alias ros2=" "$CONFIG_FILE"; then
    # Если алиас уже существует, заменяем его
    sed -i "s|alias ros2=.*|$ALIAS_LINE|" "$CONFIG_FILE"
else
    # Иначе добавляем в конец файла
    echo "$ALIAS_LINE" >> "$CONFIG_FILE"
fi

# Применяем изменения
source "$CONFIG_FILE"

echo "=== Установка завершена! ==="
echo "Перезагрузите терминал или выполните: source $CONFIG_FILE"
echo "Теперь вы можете использовать команду: ros2"
