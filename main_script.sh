#!/bin/bash
exec > >(tee /var/log/user_data.log|logger -t user_data -s 2>/dev/console) 2>&1

# Exit script on any error
set -e

# Update package repositories and install git
sudo apt update -y

# Create files and directories
sudo touch file.txt
sudo mkdir docker
cd docker
sudo touch file1.txt

# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

# Clone repositories and build Docker images
sudo git clone https://github.com/Ealenn/Echo-Server.git
cd Echo-Server
sudo touch file2.txt
sudo docker build -t first_app .
sudo docker run -d -p 80:80 --name first_container first_app

cd ..
sudo git clone https://github.com/docker/docker-bench-security.git
cd docker-bench-security
sudo sh docker-bench-security.sh > log0.txt











#!/bin/bash
sudo apt update -y

sudo mkdir finbox
cd finbox
# Clone repositories and build Docker images

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

sudo groupadd docker
sudo usermod -aG docker ubuntu  # Replace 'ubuntu' with your trusted user

echo "DOCKER_CONTENT_TRUST=1" | sudo tee -a /etc/environment


sudo git clone https://github.com/Ealenn/Echo-Server.git
cd Echo-Server
sudo docker build -t first_app .

sudo docker run -d \
  --memory=512m \
  --cpu-shares=512 \
  --read-only \
  --restart=on-failure:5 \
  --pids-limit=100 \
  -p 172.31.38.92:8080:8080 \
  --security-opt label=type:container_runtime_t \
  first_app:latest

#sudo docker run -d -p 8080:8080 --name first_container first_app
cd ..

sudo git clone https://github.com/docker/docker-bench-security.git
cd docker-bench-security
sudo sh docker-bench-security.sh > log1.txt

sudo apt-get update -y
sudo apt-get install auditd -y
sudo systemctl start auditd
sudo systemctl enable auditd
sudo auditctl -w /run/containerd -p wa -k docker_run_containerd #/run/containerd
sudo auditctl -w /var/lib/docker -p wa -k docker_var_lib #/var/lib/docker
sudo auditctl -w /etc/docker -p wa -k docker_etc #/etc/docker
sudo auditctl -w /etc/systemd/system/docker.service -p wa -k docker_service #sudo auditctl -w /lib/systemd/system/docker.servic -p wa -k docker_service
sudo auditctl -w /etc/systemd/system/docker.socket -p wa -k docker_socket
sudo auditctl -w /usr/bin/dockerd -k docker #Ensure auditing is configured for the Docker daemon

sudo auditctl -w /var/run/docker.sock -p wa -k docker_socket #not working
sudo auditctl -w /etc/default/docker -p wa -k docker_default_conf #/etc/default/docker
sudo auditctl -w /etc/docker/daemon.json -p wa -k docker_daemon_json #/etc/docker/daemon.json
sudo auditctl -w /etc/containerd/config.toml -p wa -k containerd_config_toml #/etc/containerd/config.toml
sudo auditctl -w /etc/sysconfig/docker -p wa -k docker_sysconfig #/etc/sysconfig/docker


sudo auditctl -w /usr/bin/containerd -p wa -k containerd #/usr/bin/containerd
sudo auditctl -w /usr/bin/containerd-shim -p wa -k containerd_shim #/usr/bin/containerd-shim
sudo auditctl -w /usr/bin/containerd-shim-runc-v1 -p wa -k containerd_shim_runc_v1 #usr/bin/containerd-shim-runc-v1
sudo auditctl -w /usr/bin/containerd-shim-runc-v2 -p wa -k containerd_shim_runc_v2 #/usr/bin/containerd-shim-runc-v2
sudo auditctl -w /usr/bin/runc -p wa -k runc #/usr/bin/runc



# Create the Docker daemon configuration file

sudo tee /etc/docker/daemon.json <<EOF2
{
    "userns-remap": "default",
    "iptables": false,
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "no-new-privileges": true,
    "live-restore": true,
    "userland-proxy": false,
    "authorization-plugins": ["docker-remote-api-auth"]
}
EOF2

# Restart Docker daemon
sudo systemctl restart docker



sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "userns-remap": "default",
    "iptables": false,
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "no-new-privileges": true,
    "live-restore": true,
    "userland-proxy": false,
    "authorization-plugins": ["docker-remote-api-auth"]
}
EOF



# Ensure auditing is configured for the Docker daemon
sudo mkdir -p /etc/docker
sudo touch /etc/docker/daemon.json
sudo chmod 644 /etc/docker/daemon.json
sudo chown sudo chown ubuntu /etc/docker/daemon.json
sudo cat <<EOT >> /etc/docker/daemon.json
{
"log-driver": "json-file",
"log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "audit",
    "env": "os,pid,user"
}
}
EOT

sudo systemctl restart docker












#!/bin/bash
sudo apt update -y

sudo mkdir finbox
cd finbox
# Clone repositories and build Docker images

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

sudo groupadd docker
sudo usermod -aG docker ubuntu  # Replace 'ubuntu' with your trusted user


sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "userns-remap": "default",
    "iptables": false,
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "no-new-privileges": true,
    "live-restore": true,
    "userland-proxy": false,
    "authorization-plugins": []
}
EOF



# Restart Docker daemon
sudo systemctl restart docker


sudo apt-get update -y
sudo apt-get install auditd -y
sudo systemctl start auditd
sudo systemctl enable auditd
sudo auditctl -w /run/containerd -p wa -k docker_run_containerd #/run/containerd
sudo auditctl -w /var/lib/docker -p wa -k docker_var_lib #/var/lib/docker
sudo auditctl -w /etc/docker -p wa -k docker_etc #/etc/docker
sudo auditctl -w /etc/systemd/system/docker.service -p wa -k docker_service #sudo auditctl -w /lib/systemd/system/docker.servic -p wa -k docker_service
sudo auditctl -w /etc/systemd/system/docker.socket -p wa -k docker_socket
sudo auditctl -w /usr/bin/dockerd -k docker #Ensure auditing is configured for the Docker daemon
#/etc
sudo auditctl -w /var/run/docker.sock -p wa -k docker_socket #not working
sudo auditctl -w /etc/default/docker -p wa -k docker_default_conf #/etc/default/docker
sudo auditctl -w /etc/docker/daemon.json -p wa -k docker_daemon_json #/etc/docker/daemon.json
sudo auditctl -w /etc/containerd/config.toml -p wa -k containerd_config_toml #/etc/containerd/config.toml
sudo auditctl -w /etc/sysconfig/docker -p wa -k docker_sysconfig #/etc/sysconfig/docker
#/usr/
sudo auditctl -w /usr/bin/containerd -p wa -k containerd #/usr/bin/containerd
sudo auditctl -w /usr/bin/containerd-shim -p wa -k containerd_shim #/usr/bin/containerd-shim
sudo auditctl -w /usr/bin/containerd-shim-runc-v1 -p wa -k containerd_shim_runc_v1 #usr/bin/containerd-shim-runc-v1
sudo auditctl -w /usr/bin/containerd-shim-runc-v2 -p wa -k containerd_shim_runc_v2 #/usr/bin/containerd-shim-runc-v2
sudo auditctl -w /usr/bin/runc -p wa -k runc #/usr/bin/runc

sudo git clone https://github.com/kraushan1997/Echo-Server-Raushan.git
cd Echo-Server-Raushan
sudo docker build -t first_app .

sudo docker run -d \
  --memory=512m \
  --cpu-shares=512 \
  --read-only \
  --restart=on-failure:5 \
  --pids-limit=100 \
  --security-opt label=type:container_runtime_t \
  first_app:latest

#sudo docker run -d -p 8080:8080 --name first_container first_app
cd ..


sudo git clone https://github.com/docker/docker-bench-security.git
cd docker-bench-security
sudo sh docker-bench-security.sh | tee output-file.txt



sudo tee /etc/docker/daemon.json <<EOF
{
    "userns-remap": "default",
    "icc": false,
    "log-driver": "syslog",
    "disable-legacy-registry": true,
    "log-opts": {
        "syslog-address": "tcp://$host_ip:514",
        "tag": "docker"
    },
    "no-new-privileges": true,
    "live-restore": true,
    "userland-proxy": false,
    "authorization-plugins": []
}
EOF


sudo tee /etc/docker/daemon.json <<EOF
{
    "userns-remap": "ubuntu",
    "icc": false,
    "log-driver": "syslog",
    "live-restore": true,
    "userland-proxy": false,
    "no-new-privileges": true
}
EOF




{
    "icc": false,
    "userns-remap": "default",
    "log-driver": "syslog",
    "disable-legacy-registry": true,
    "live-restore": true,
    "userland-proxy": false,
    "no-new-privileges": true
}


sudo tee /etc/docker/daemon.json <<EOF
{
    "userns-remap": "default",
    "log-driver": "syslog",
    "no-new-privileges": true,
    "live-restore": true,
    "userland-proxy": false,
    "authorization-plugins": []
}
EOF
