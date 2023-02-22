#! /bin/bash
sudo apt update
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# sudo apt update
# sudo apt install nodejs
# sudo apt install npm
# docker-compose --version