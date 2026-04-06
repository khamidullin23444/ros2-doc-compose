FROM ros:jazzy-ros-base
ARG ROS_USERNAME=ros2user
ARG ROS_USER_UID=1010
ARG ROS_USER_GID=$ROS_USER_UID

# Create the user
RUN groupadd --gid $ROS_USER_GID $ROS_USERNAME
RUN useradd --uid $ROS_USER_UID --gid $ROS_USER_GID -m $ROS_USERNAME

# Add sudo support
RUN apt-get -y update
RUN apt-get install -y sudo
RUN echo $ROS_USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$ROS_USERNAME
RUN chmod 0440 /etc/sudoers.d/$ROS_USERNAME
RUN apt-get update && apt-get upgrade -y

# Install a few important dependencies
RUN apt install -y ros-jazzy-ros-core ros-jazzy-ros-base ros-jazzy-demo-nodes-cpp

RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/$ROS_USERNAME/.bashrc
ENV SHELL /bin/bash

# Set the default user
USER $$ROS_USERNAME
CMD ["/bin/bash"]