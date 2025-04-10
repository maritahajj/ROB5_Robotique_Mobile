#!/bin/bash

echo If docker is already installed,
echo you have to run the "uninstall_docker.bash" script first
echo This script will only work after docker uninstall or
echo for a fisrt install

# Ask if proceed
while true; do
read -p "Do you want to proceed? (y/n) " yn
case $yn in 
	[yY] ) echo Installing docker;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
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
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker


# Run test
echo Docker should be installed now
echo Do you want to run a test docker container to check the install?
echo The script will download the test image
echo then a container should run and print "Hello world"
# Ask if proceed
while true; do
read -p "Run the test? (y/n) " yn
case $yn in 
	[yY] ) echo Installing docker;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac
done

# Check for docker install
docker run hello-world



