#!/bin/bash

# Ask for validation
echo This script will delete all docker packages \
    and all docker images and containers saved in the default directories of docker
echo All files in "/var/lib/docker" and "/var/lib/containerd" will be lost

# First
while true; do
read -p "Do you want to proceed? (y/n) " yn
case $yn in 
	[yY] ) echo continuing...;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac
done

# Second
while true; do
read -p "Are you really sure?(y/n) " yn
case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac
done


# From docker install tutorial
# https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine

# Uninstall packages
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Delete images and containers
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd