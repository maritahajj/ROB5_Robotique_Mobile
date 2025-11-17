#!/bin/bash

# Build dockerfile
docker build --tag turtlebot4_docker ../
docker image prune -f

# Clone minilab git and chose correct branch
#git clone https://github.com/Enova-Robotics/Mini-Lab.git
#cd Mini-Lab/
#git checkout noetic

# Copy files to workspace folder
#cd ..
mkdir home/robmob_ws/src -p

# Delete additional files
#rm -r -f ./Mini-Lab/

mkdir home/simulation_ws/src -p

# clone turtlebot3 simulations repo (turtlebot4 simulation has bad performance so we prefer turtlebot3 simulation)
git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git ./home/simulation_ws/src/simulation/turtlebot3_simulations
git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git ./home/simulation_ws/src/simulation/turtlebot3_msgs
git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git ./home/simulation_ws/src/simulation/DynamixelSDK
git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git ./home/simulation_ws/src/simulation/turtlebot3


# git clone -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git ./home/turtlebot4_ws/src
# git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git ./home/turtlebot4_ws/src