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


# deploy dockerui

docker run --restart unless-stopped -d -p 9000:9000 -v /var/run/docker.sock:/docker.sock --name dockerui abh1nav/dockerui:latest -e="/docker.sock"

# runners
docker run -d --name gitlab-runner-1 --restart always \
   -v /srv/gitlab-runner/config:/etc/gitlab-runner \
   -v /var/run/docker.sock:/var/run/docker.sock \
   gitlab/gitlab-runner:latest

docker run -d --name gitlab-runner-2 --restart always \
   -v /srv/gitlab-runner/config:/etc/gitlab-runner \
   -v /var/run/docker.sock:/var/run/docker.sock \
   gitlab/gitlab-runner:latest

docker run -d --name gitlab-runner-3 --restart always \
   -v /srv/gitlab-runner/config:/etc/gitlab-runner \
   -v /var/run/docker.sock:/var/run/docker.sock \
   gitlab/gitlab-runner:latest
