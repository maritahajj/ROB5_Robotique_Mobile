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
    wget \
    curl \
    bash-completion \
    net-tools \
    nano \
    terminator \
    sudo \
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

#RUN apt install -q -y chrony \
#    	ntp
# ntp -> router's rapsberry ip
# RUN with user root
RUN echo "pool 192.168.42.100 prefer iburst" >> /etc/ntp.conf

ARG C_USER
ARG C_UID
ARG C_GID

# Copy shared bashrc
COPY ./shared/.bashrc /home/$C_USER/.bashrc

RUN groupadd -g $C_GID $C_USER && \
    useradd -m -d /home/$C_USER -g $C_GID -s /bin/bash -u $C_UID $C_USER && \
    adduser $C_USER sudo

USER $C_USER
WORKDIR /home/$C_USER

CMD ["bash"]
