#!/bin/bash

# Build dockerfile
docker build --tag turtlebot4_docker .
docker image prune -f

# Clone minilab git and chose correct branch
#git clone https://github.com/Enova-Robotics/Mini-Lab.git
#cd Mini-Lab/
#git checkout noetic

# Copy files to workspace folder
#cd ..
mkdir home/turtlebot4_ws/src -p
#cp ./Mini-Lab/minilab_workstation/src/minilab_simulation/ ./home/catkin_ws/src/minilab_simulation -r
#cp ./Mini-Lab/minilab_workstation/src/minilab_model/ ./home/catkin_ws/src/minilab_model -r

# Delete additional files
#rm -r -f ./Mini-Lab/
