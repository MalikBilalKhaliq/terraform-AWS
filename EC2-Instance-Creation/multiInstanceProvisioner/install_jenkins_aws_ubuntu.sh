#! /bin/bash
sudo echo "-----------Below executing wget pkg command---------------"
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sleep 10
sudo echo "------------Below executing sh -c echo pkg command-----------------"
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo sleep 10
sudo echo "-------------Below executing apt update command-----------------"
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo sleep 60
sudo echo "-------------Below executing install openjdk-11-jdk command-----------------"
sudo DEBIAN_FRONTEND=noninteractive apt install openjdk-11-jdk -y
sudo sleep 60
sudo echo "-------------Below executing install jenkins command-----------------"
sudo DEBIAN_FRONTEND=noninteractive apt install jenkins -y
sudo sleep 60
sudo DEBIAN_FRONTEND=noninteractive systemctl enable jenkins 
sudo DEBIAN_FRONTEND=noninteractive systemctl start jenkins 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#sudo service jenkins status