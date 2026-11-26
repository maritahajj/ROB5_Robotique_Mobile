#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
SHARED_FOLDER_NAME=shared

# Util functions

log_polytech () {
	log_string=$1
  color_string="\033[38;2;0;175;240m$log_string\e[0m"
  echo -e "$color_string"
}

log_warn () {
  log_string=$1
  color_string="\e[1;33m$log_string\e[0m"
  echo -e "$color_string"
}

log_error () {
  log_string=$1
  color_string="\e[1;31m$log_string\e[0m"
  echo -e "$color_string"
}

# Print pretty logo

log_polytech "\n▄▄▄▄▄▄▄     ▄▄▄▄▄   ▄▄▄▄▄▄▄   ▄▄▄      ▄▄▄   ▄▄▄▄▄   ▄▄▄▄▄▄▄
███▀▀███▄ ▄███████▄ ███▀▀███▄ ████▄  ▄████ ▄███████▄ ███▀▀███▄
███▄▄███▀ ███   ███ ███▄▄███▀ ███▀████▀███ ███   ███ ███▄▄███▀
███▀▀██▄  ███▄▄▄███ ███  ███▄ ███  ▀▀  ███ ███▄▄▄███ ███  ███▄
███  ▀███  ▀█████▀  ████████▀ ███      ███  ▀█████▀  ████████▀\n"


# Build dockerfile
C_USER=$(id -un)
C_UID=$(id -u)
C_GID=$(id -g "$C_USER")

docker build \
  --build-arg C_USER="$C_USER" \
  --build-arg C_UID="$C_UID" \
  --build-arg C_GID="$C_GID" \
  -t turtlebot4_docker "${SCRIPT_DIR}/../" || exit 1

# Checking if shared folder already exists from previous installation
if [ -d ${SCRIPT_DIR}/../${SHARED_FOLDER_NAME} ]; then
	folder_state=$(ls -l ${SCRIPT_DIR}/../ | grep ${SHARED_FOLDER_NAME})
	permission=$(echo "$folder_state" | cut -d ' ' -f1 )
	owner=$(echo "$folder_state" | cut -d ' ' -f3 )
	# echo "Owner: ${owner}, permissions: ${permission}"
	if [ "${owner}" != "$(whoami)" ]; then
		log_warn "Error: current user has not the permissions to write in ${SHARED_FOLDER_NAME}. Do you want to change the owner to you ? (Y/n)"
		read INPUT
		if [ "${INPUT}" == "Y" ]; then
			log_polytech "Changing permission"
			sudo chown -R $(whoami):$(whoami) ${SCRIPT_DIR}/../${SHARED_FOLDER_NAME}
		else
			log_error "Cannot continue without permissions. Please check manually the state of the ${SHARED_FOLDER_NAME} folder and rerun this script"
			exit 1 
		fi
	else
		log_polytech "All good"
	fi  
fi

# Copy files to workspace folder
simulation_src="${SCRIPT_DIR}/../${SHARED_FOLDER_NAME}/simulation_ws/src"
mkdir -p "${SCRIPT_DIR}/../${SHARED_FOLDER_NAME}/robmob_ws/src" "$simulation_src" || exit 1

for repository in turtlebot3_simulations turtlebot3_msgs DynamixelSDK turtlebot3; do
  if [[ ! -e "$simulation_src/$repository" ]]; then
    git clone --depth 1 -b humble "https://github.com/ROBOTIS-GIT/$repository.git" \
      "$simulation_src/$repository" || exit 1
  fi
done
