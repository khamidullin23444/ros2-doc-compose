#!/bin/bash

CONTAINER_NAME="ros2"

# Основная команда для работы с Docker‑контейнером

ROS2_DIR="$HOME/ros2_ws/docker"
ROS2_VAR="source /opt/ros/jazzy/setup.bash"
ROS2_FILE="$ROS2_DIR/docker-compose.yml"
DOC_COMMAND="docker compose -f $ROS2_FILE exec $CONTAINER_NAME"
DOC_COMMAND_ATTACH="docker compose -f $ROS2_FILE attach $CONTAINER_NAME"



# Функция для проверки состояния контейнера
check_container_status() {
    # Проверяем, существует ли контейнер
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then 
        echo "Ошибка: Контейнер '$CONTAINER_NAME' не существует." >&2
        echo "Убедитесь, что вы выполнили 'docker compose up -d' в директории с docker-compose.yml" >&2
        echo "Пробуем запустить контейнер..."
        eval "docker compose -f $ROS2_FILE up -d"
    fi

    # Проверяем, запущен ли контейнер
    if docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q "false"; then
        echo "Контейнер '$CONTAINER_NAME' остановлен. Запускаю..."
        if ! docker start "$CONTAINER_NAME" >/dev/null 2>&1; then
            echo "Ошибка: Не удалось запустить контейнер '$CONTAINER_NAME'" >&2
            return 1
        fi
        echo "Контейнер запущен."
    elif ! docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q "true"; then
        echo "Ошибка: Не удалось получить статус контейнера '$CONTAINER_NAME'" >&2
        return 1
    fi
    return 0
}

# Проверяем состояние контейнера перед выполнением команды
if ! check_container_status; then
    exit 1
fi



# Если аргументов нет, запускаем интерактивную оболочку
if [ $# -eq 0 ]; then
    # Добавляем /bin/bash к основной команде
    eval $DOC_COMMAND_ATTACH
else
    # Сохраняем все переданные аргументы в переменную
    ARGUMENTS="$@"
    eval "$DOC_COMMAND /bin/bash -c '$ROS2_VAR && ros2 $ARGUMENTS'"
fi




