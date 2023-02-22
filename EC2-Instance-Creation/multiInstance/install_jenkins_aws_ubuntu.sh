#! /bin/bash
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install openjdk-11-jdk -y
sudo DEBIAN_FRONTEND=noninteractive apt install jenkins -y
sudo systemctl enable jenkins 
sudo systemctl start jenkins 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#sudo service jenkins status