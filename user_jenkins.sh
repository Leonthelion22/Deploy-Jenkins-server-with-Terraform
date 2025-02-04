#!/bin/bash
# Update and upgrade the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Java (Jenkins requirement)
sudo apt-get install openjdk-11-jdk -y

# Add Jenkins repository and import GPG key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package list and install Jenkins
sudo apt-get update -y
sudo apt-get install jenkins -y

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

