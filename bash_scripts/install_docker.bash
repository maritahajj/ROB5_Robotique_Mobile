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

log_warn If docker is already installed,
log_warn you have to run the "uninstall_docker.bash" script first
log_warn This script will only work after docker uninstall or
log_warn for a first install

# Ask if proceed
while true; do
read -p "Do you want to proceed? (y/n) " yn
case $yn in 
	[yY] ) log_polytech "Installing docker";
		break;;
	[nN] ) log_polytech "exiting...";
		exit;;
	* ) log_error "invalid response";;
esac
done

# Uninstall potentially conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Install docker via the apt repo
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version package
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Create group and add user to run docker without sudo
# https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker # Command problematic, will pause the script to join a new terminal
sudo usermod -aG docker $USER
newgrp docker


# Run test
log_polytech Docker should be installed now
log_polytech Do you want to run a test docker container to check the install?
log_polytech The script will download the test image
log_polytech then a container should run and print "Hello world"
# Ask if proceed
while true; do
read -p "Run the test? (y/n) " yn
case $yn in 
	[yY] ) log_polytech "Installing docker";
		break;;
	[nN] ) log_polytech "exiting...";
		exit;;
	* ) log_error "invalid response";;
esac
done

# Check for docker install
docker run hello-world



