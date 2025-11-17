# xauth : enables lanching GUI apps in host
xauth merge /dot.Xauthority

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


###### SIMULATION SETTINGS ######

# ROS sourcing
source /opt/ros/humble/setup.bash
source "$HOME/simulation_ws/install/setup.bash"
source "$HOME/robmob_ws/install/setup.bash"
source /usr/share/gazebo/setup.sh

# Turtlebot3 model for simulation
export TURTLEBOT3_MODEL=burger

function colcon_build_n_setup() {
    colcon build --symlink-install
    source install/setup.bash
    echo "Colcon build and setup complete."
}

alias cbns='colcon_build_n_setup'