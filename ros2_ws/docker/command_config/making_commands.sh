#!/bin/bash

COMMANDS_FILE="./ros2_commands.txt"

echo "#!/bin/bash" >> $COMMAND_SCRIPT
echo "COMMAND_NAME=$command" >> $COMMAND_SCRIPT
echo ". ./command_config/docker_works.sh" >> $COMMAND_SCRIPT
chmod +x $COMMAND_SCRIPT