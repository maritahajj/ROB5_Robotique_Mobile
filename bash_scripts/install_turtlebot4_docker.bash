#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

# Build dockerfile
C_USER=$(id -un)
C_UID=$(id -u)
C_GID=$(id -g)

docker build \
  --build-arg C_USER=$C_USER \
  --build-arg C_UID=$C_UID \
  --build-arg C_GID=$C_GID \
  -t turtlebot4_docker ${SCRIPT_DIR}/../

# Clean up dangling images
docker image prune -f

# Copy files to workspace folder
mkdir -p "shared/robmob_ws/src"
mkdir -p "shared/simulation_ws/src"

if [ -z "$(ls -A "shared/simulation_ws/src")" ]; then
  # clone turtlebot3 simulations repo (turtlebot4 simulation has bad performance so we prefer turtlebot3 simulation)
  git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git "./shared/simulation_ws/src/turtlebot3_simulations"
  git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git "./shared/simulation_ws/src/turtlebot3_msgs"
  git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git "./shared/simulation_ws/src/DynamixelSDK"
  git clone --depth 1 -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git "./shared/simulation_ws/src/turtlebot3"
fi
