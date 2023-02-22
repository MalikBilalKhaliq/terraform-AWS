#! /bin/bash
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo DEBIAN_FRONTEND=noninteractive curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo DEBIAN_FRONTEND=noninteractive apt-cache policy docker-ce -y
sudo DEBIAN_FRONTEND=noninteractive apt install docker-ce -y
sudo DEBIAN_FRONTEND=noninteractive docker pull orchardup/jenkins -y
sudo DEBIAN_FRONTEND=noninteractive docker run -d -p 8080:8080 orchardup/jenkins -y