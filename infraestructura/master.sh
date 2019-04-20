#!/bin/bash
apt-get update -y && apt-get upgrade -y
apt-get install -y htop
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl
# Install docker 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
 
add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
 
apt-get update
 
apt-get -y install docker-ce

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#docker swarm visua
docker run -p 9009:9009 -v /var/run/docker.sock:/var/run/docker.sock moimhossain/viswarm


#portainer 8080
curl -L https://downloads.portainer.io/portainer-agent-stack.yml -o portainer-agent-stack.yml
sudo docker stack deploy --compose-file=portainer-agent-stack.yml portainer