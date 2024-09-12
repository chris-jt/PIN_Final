#!/bin/bash
echo "Installing Unzip"
sudo apt install unzip
unzip -v

# Actualizar e instalar dependencias
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "Installing AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
aws --version

echo "Installing kubectl"
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.2/2024-07-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
#echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --client

echo "Installing ekctl"
# Download EKS CLI https://github.com/weaveworks/eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
export PATH=$PATH:/usr/local/bin
#echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
eksctl version

echo "Installing docker"
sudo snap install docker
sudo addgroup --system docker
sudo adduser $USER docker
sudo usermod -a -G docker ec2-user
newgrp docker
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service

echo "Installing Helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
chmod 700 get_helm.sh
./get_helm.sh
helm version

# Instalar Prometheus y Grafana (opcional, para monitoreo)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Todas las herramientas necesarias han sido instaladas."



