#!/bin/bash

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

# Ask for validation
log_warn This script will delete all docker packages \
    and all docker images and containers saved in the default directories of docker
log_warn All files in "/var/lib/docker" and "/var/lib/containerd" will be lost

# First
while true; do
read -p "Do you want to proceed? (y/n) " yn
case $yn in 
	[yY] ) log_polytech "continuing...";
		break;;
	[nN] ) log_polytech "exiting...";
		exit;;
	* ) log_error "invalid response";;
esac
done

# Second
while true; do
read -p "Are you really sure?(y/n) " yn
case $yn in 
	[yY] ) log_polytech "ok, we will proceed";
		break;;
	[nN] ) log_polytech "exiting...";
		exit;;
	* ) log_error "invalid response";;
esac
done


# From docker install tutorial
# https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine

# Uninstall packages
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Delete images and containers
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd