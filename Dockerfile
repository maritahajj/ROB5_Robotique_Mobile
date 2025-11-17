FROM osrf/ros:humble-desktop-full

# install xauth for gui applications
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    xauth \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    net-tools \
    nano \
    terminator \
    && rm -rf /var/lib/apt/lists/*

# install python packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    python3-pip \
    python3-colcon-clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install opencv-python

# install ROS useful tools
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    ros-humble-robot-state-publisher \
    ros-humble-depthimage-to-laserscan \
    ros-humble-joy \
    ros-humble-teleop-twist-keyboard \
    ros-humble-rqt-image-view \
    ros-humble-turtlebot4-desktop \
    ros-humble-turtlebot4-navigation \
# ros-humble-gmapping \
# ros-humble-map-server \
# ros-humble-navigation \
# ros-humble-move-base \
# ros-humble-amcl \
# ros-humble-openni-camera \
    ros-humble-turtlebot4-simulator \
    ros-humble-irobot-create-nodes \
    ros-humble-cartographer \
    ros-humble-cartographer-ros \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-gazebo-ros \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-plugins \
    && rm -rf /var/lib/apt/lists/*

# create turtlebot4_ws
RUN mkdir -p /home/turtlebot4_ws/src

# bash
COPY ./ressources/docker_setup.bash /
RUN echo "source /docker_setup.bash">>/root/.bashrc
COPY ./ressources/custom_setup.bash /
RUN echo "source /custom_setup.bash">>/root/.bashrc

CMD ["bash"]


#RUN apt install -q -y chrony \
#    	ntp

# ntp -> router's rapsberry ip
RUN echo "pool 192.168.42.100 prefer iburst" >> /etc/ntp.conf
