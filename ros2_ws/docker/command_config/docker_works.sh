CONTAINER_DIR=$(pwd)
CONTAINER_NAME="ros2"
CONTAINER_VAR="source /opt/ros/jazzy/setup.bash"
CONTAINER_FILE="$CONTAINER_DIR/docker-compose.yml"
DOCKER_COMMAND="docker compose -f $CONTAINER_FILE exec $CONTAINER_NAME"

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
    eval "$DOCKER_COMMAND /bin/bash"
else
    # Сохраняем все переданные аргументы в переменную
    ARGUMENTS="$@"
    eval "$DOC_COMMAND /bin/bash -c '$CONTAINER_VAR && $COMMAND_NAME $ARGUMENTS'"
fi