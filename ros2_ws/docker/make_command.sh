#!/bin/bash

command_name=$1
file_name="$command_name.sh"
COMMANDS_FILE="./command_config/ros2_commands.txt"

if [ -e "$file_name" ]
then
  echo "Файл с названием $command_name.sh уже существует!"
else
  echo "#!/bin/bash" >> $file_name
  echo "COMMAND_NAME=$command_name" >> $file_name
  echo ". ./command_config/docker_works.sh" >> $file_name
  echo "$command_name" >> "$COMMANDS_FILE"
  chmod +x $file_name

  . ./install.sh
fi