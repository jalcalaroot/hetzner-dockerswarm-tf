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

#key
cat > /root/id_rsa <<- "EOF"
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAleXKciyq8Gqt5riyL6FKByFMSFxX6XrePr7ccgXbhP6MHbok
TrL4ZUVe7TMFmVleT32FlrJ8gIbORepwXunpuzxAFj6A5o6EFuicinwry+O5vH7Q
3X5kDxpCB3nkiWKgS8wZKoXKfWXbztyrefeKnaRXV7nlMZjZF0Bmf9nLt1xh2jDn
Wxi4BKpxhhI+9Swyh93a9yWzk7QggNH5M6PJXrPTjdaX48sTCWFPNs5vbIFHNyf7
S43bhp84JdpDe975+uu/+5AWnXFbT9dzbl64ngI0RGYVPzlAuPrqadaovtiLg5ET
RCBwrdLo3r9n+e8iENMTkPVNdyt+irJoNiEd3wIDAQABAoIBAG6sj2DlYgDIg0WK
sOVB7Op+x1fV9oLI2TbyrMjzUjVLzCBWw1/n/EaphYEU3tluhpeiUfQGLK6o2bv9
cKJjitNXlOnXlEymhRh0/r+xFpUfuo9WAtjG7RHJjV7/vKFDVJ8iPqKKzgrwHe8K
NwGCp7HlGSgIdRS9iewE/KkBIcxrI/oy1RhxGftuvs1FuggSZhem6QFuVuLrd9xk
svGgVfOue2YYqjdn6FvhLOPQFqtJYkDuVR/4iA5yBbyrle8M7xExhondxq/oimwc
ph9wPDpISkLv1BzQUZxGjrRm6kGy6cWKdjNuITPMnSiomhQXE7gNmnuOH2t5MCB2
VJmmrMECgYEAxia1+VWyCAA1hHQEdCPMxg5+UBT7HJaahwh4M4ZfElodVgrJdyGg
4MBco821exXOBDkpyHu/aAbNNPL7M7HButk3z0A0P5C/0+k/q3iXTACdfyTNO8GC
+5rWzKk69FJLYYsNI3HsfdRyVwgF1K0GevePGqn5n9n48fTa1CPWS6cCgYEAwai8
bkSvlCo/q4J8eYC+AfQb7PKXfTo/GwFPV7n9ohEyweJYOzCUDSWFX9siwrdpWtnY
PmAVAYu+sLx7ivt4fLPeGNZscxHyH/+Z3UUgAuVdEKeC417VfiAxY+6V1CoIPxwG
QWRDX2FV0G4W3Yi1D2QWm60kt52IaBfD9JJOgwkCgYEAs57DtpGIINiPqtHAd8c8
CQ16Uv2x4+hhi6aRz6Mu62Pk0+pTVjqVqya004fVyw2pAwsOZT5H8/S2cBkSvXmV
M9tUS/rXYgfE3EPEA5v9ClhEbMzffhucsJdbv4podrFiw7lY35iV2DqMq3gKUQ/H
oBBpGLKcJdthX3OmKkeSKmECgYEAgUF8MyUJA52HTZQUPIyfRXKGyQnJ7r1XrVCc
gnMTRH6yIBJQzYDI8FVgxe/fLZN5cDgCSu+aVaPOLOxAkSzy6FitHmrPi6Yosw7I
xZUDnqs0CI+lntiHKl2WWZq+yhMb2fN8gVzIUvsGac1w2YALSTCGnnVcEmnEx6VF
FxIn8PECgYA6dSMGnfeB1v9r/05S6oKfgR/vq1r6yxyqjOasKxa/FOa3dAJcbRuy
picJh4FVjoD1BuokXXS7kQDdek3VLhd932dcscjSMI4MGqL74yOeyFbnmA6W7OYJ
ird8iuoN3AWpFuWTGL5dT4rKogoP6hZHEo7uIFhjtv9XalR2rXm72A==
-----END RSA PRIVATE KEY-----
EOF

chmod 0600 /root/id_rsa


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
      replicas: 1
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

#swarm-cluster.sh
cat > /root/deploy-swarm-cluster.sh <<- "EOF"
#!/bin/bash
echo 'Introduzca la ip del nodo1:'
read ip1
echo 'Introduzca la ip del nodo2:'
read ip2
echo 'Introduzca la ip del nodo3:'
read ip3
MASTER_IP_PUBLICA=$(curl ifconfig.me)
#iniciando cluster de swarm
docker swarm init
SWARM_TOKEN=$(docker swarm join-token -q worker)
for i in $ip1 $ip2 $ip3; do echo $i ; ssh -i /root/id_rsa  $i "sudo docker swarm join --token $SWARM_TOKEN $MASTER_IP_PUBLICA:2377" ; done
#ping
#for i in $ip1 ; do echo $i ; ping $i ; done
#Avisar al usuario que se ha terminado de ejecutar el script 
EOF
chmod 755 /root/deploy-swarm-cluster.sh
echo "docker network create -d overlay net && docker stack deploy --compose-file=/root/wordpress.yml wordpress" >> /root/deploy-wordpress.sh 
chmod 755 /root/deploy-wordpress.sh
chmod 0600 /root/id_rsa

#docker swarm visua
docker run -p 9009:9009 -v /var/run/docker.sock:/var/run/docker.sock moimhossain/viswarm







