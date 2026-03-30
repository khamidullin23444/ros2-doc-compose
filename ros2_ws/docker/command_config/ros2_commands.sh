#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Формируем полный путь к файлу данных
DATA_FILE="$SCRIPT_DIR/command_config/ros2_commands.txt"
ROS2_COMMANDS=()
while IFS= read -r line; do
    # Пропускаем комментарии и пустые строки
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Обрезаем пробелы по краям
    line=$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

    # Добавляем только непустые строки

    if [[ -n "$line" ]]; then
      ROS2_COMMANDS+=("$line")
    fi

done < "$DATA_FILE"

export ROS2_COMMANDS