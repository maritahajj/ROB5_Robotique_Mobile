# This file is sourced by .bashrc and is useful for adding custom sourcing despite .bashrc losing modifs when the docker is closed

# ROS sourcing
source /opt/ros/humble/setup.bash
source /home/simulation_ws/install/setup.bash

source /home/robmob_ws/install/setup.bash
source /usr/share/gazebo/setup.sh

# ROS daemon
ros_daemon_restart() {
    ros2 daemon stop
    ros2 daemon start
}

# ROS turtle
ros_turtle() {
    # ROS SOURCE
    export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    source /opt/ros/humble/setup.bash


    #[ -t 0 ] && export ROS_SUPER_CLIENT=True || export ROS_SUPER_CLIENT=False
    export ROS_SUPER_CLIENT=True
    export ROS_DOMAIN_ID=10
    export ROS_DISCOVERY_SERVER=192.168.42.10:11811
    PS1="(humble turtle) $PS1"
}


# ROS Distant master
#export ROS_MASTER_URI=http://192.168.0.200:11311
# export ROS_IP=192.168.0.100

# Turtlebot3 model for simulation
export TURTLEBOT3_MODEL=burger