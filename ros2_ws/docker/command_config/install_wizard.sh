#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo $SCRIPT_DIR

. ./command_config/ros2_commands.sh


# Определяем оболочку пользователя
if [ -n "$ZSH_VERSION" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    # По умолчанию используем .bashrc
    CONFIG_FILE="$HOME/.bashrc"
fi


for command in "${ROS2_COMMANDS[@]}"; do

  COMMAND_SCRIPT="$SCRIPT_DIR/$command.sh"
  echo "$command"
  echo "$COMMAND_SCRIPT"
  ALIAS_COMMAND_LINE="alias $command='$COMMAND_SCRIPT'"
  . ./command_config/making_commands.sh
  if [ ! -f "$COMMAND_SCRIPT" ]; then
      echo "Ошибка: Файл $COMMAND_SCRIPT не найден!" >&2
      exit 1
  fi

  # Создание alias
  echo "Создаём alias 'ros2' для $COMMAND_SCRIPT..."

  if grep -q "alias $command=" "$CONFIG_FILE"; then
    sed -i "s|alias $command=.*|$ALIAS_COMMAND_LINE|" "$CONFIG_FILE"
  else
    echo "$ALIAS_COMMAND_LINE" >> "$CONFIG_FILE"
  fi

done

# Применяем изменения
source "$CONFIG_FILE"
