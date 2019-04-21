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

#portainer 9000
curl -L https://downloads.portainer.io/portainer-agent-stack.yml -o /root/portainer-agent-stack.yml
chmod 755 /root/portainer-agent-stack.yml
echo "docker stack deploy --compose-file=/root/portainer-agent-stack.yml portainer" >> /root/deploy-portainer.sh 
chmod 755 /root/deploy-portainer.sh

#Wordpress HA
cat > /root/wordpress.yml <<- "EOF"
version: '3'

services:
  db:
    image: mysql:5.7
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        max_attempts: 3
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - net
    environment:
      MYSQL_ROOT_PASSWORD: wordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
        max_attempts: 3
    volumes:
      - wordpress_data:/var/www/html
    networks:
      - net
    ports:
      - "8001:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_PASSWORD: wordpress

volumes:
 db_data:
 wordpress_data:

networks:
  net:
    external: true
EOF


echo "docker stack deploy --compose-file=/root/wordpress.yml wordpress" >> /root/deploy-wordpress.sh 
chmod 755 /root/deploy-wordpress.sh

#docker swarm visua
docker run -p 9009:9009 -v /var/run/docker.sock:/var/run/docker.sock moimhossain/viswarm







