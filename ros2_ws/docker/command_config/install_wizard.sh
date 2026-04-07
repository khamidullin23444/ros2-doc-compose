#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo $SCRIPT_DIR


# Определяем оболочку пользователя
if [ -n "$ZSH_VERSION" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    # По умолчанию используем .bashrc
    CONFIG_FILE="$HOME/.bashrc"
fi

command="ros2"
COMMAND_SCRIPT="docker compose -f $SCRIPT_DIR/docker-compose.yml up -d"

echo "Создаём alias 'ros2' для $COMMAND_SCRIPT..."

if grep -q "alias $command=" "$CONFIG_FILE"; then
  sed -i "s|alias $command=.*|$ALIAS_COMMAND_LINE|" "$CONFIG_FILE"
else
  echo "$ALIAS_COMMAND_LINE" >> "$CONFIG_FILE"
ALIAS_COMMAND_LINE="alias $command='$COMMAND_SCRIPT'"
# Применяем изменения
source "$CONFIG_FILE"
