#!/bin/bash
# This script install minikube and it's requirement
# Rq: As I haven't manage to activate imbricated virtualiztion option on virtualbox,
#    I choose to use the docker driver for minikube.
#    If you want to try to use a hypervisor, try commented blocks


#######################################
### INSTALL MINIKUBE & DEPENDENCIES ###
MINIKUBE_VERSION="v1.23.2"
HELM_VERSION="v3.6.3"

## INSTALL KUBECTL ------------------------------------------------------------
sudo apt-get update && \
sudo apt-get install -y apt-transport-https && \
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | 
    sudo apt-key add - && \
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | 
    sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update && \
sudo apt-get install -y kubectl && \
    echo "kubectl installed" || (echo "kubectl installation failed" ; exit 1 )

# ## INSTALL AN HYPERVISOR : VIRTUALBOX -----------------------------------------
# sudo apt-get install -y virtualbox virtualbox-qt virtualbox-dkms && \
# echo "virtualbox installed" || (echo "virtualbox installation failed" ; exit 1 )

## INSTALL HYPERVISOR ERSATZ : DOCKER -----------------------------------------
sudo apt-get remove docker docker-engine docker.io containerd runc && \
sudo apt-get update && \
sudo apt-get install -y \
    apt-transport-https ca-certificates curl gnupg lsb-release && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | 
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | 
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
sudo apt-get update && \
sudo apt-get install -y docker-ce docker-ce-cli containerd.io && \
sudo docker run hello-world && \
echo "docker installed" || (echo "docker installation failed" ; exit 1 )

## INSTALL MINIKUBE -----------------------------------------------------------
minikube_base_url="https://storage.googleapis.com/minikube/releases"
minikube_url="${minikube_base_url}/${MINIKUBE_VERSION}/minikube-linux-amd64"
curl -Lo minikube "$minikube_url" && \
chmod +x minikube && \
sudo mkdir -p /usr/local/bin/ && \
sudo install minikube /usr/local/bin && \
echo "minikube installed" || (echo "minikube installation failed" ; exit 1 )


############################
### INSTALL OTHERS TOOLS ###
## INSTALL HELM ---------------------------------------------------------------
filename="helm-$HELM_VERSION-linux-amd64.tar.gz"
sha256_string="$(wget -q  -O - https://get.helm.sh/$filename.sha256)"
sudo wget -q "https://get.helm.sh/$filename" && \
if [ "$sha256_string  $filename" = "$(sha256sum $filename)" ]; then
    sudo tar xf "$filename"
    sudo rm "$filename"
    sudo mv linux-amd64/helm /usr/local/bin
    sudo rm -r linux-amd64
else
    echo "sha256sum check failed"
    exit 1
fi && \
echo "helm installed" || (echo "helm installation failed" ; exit 1 )

## INSTALL GIT ----------------------------------------------------------------
sudo apt-get install -y git && \
echo "git installed" || (echo "git installation failed" ; exit 1 )


#####################################
### PERMIT afa TO LAUNCH MINIKUBE ###
# add afa to docker groups and logout relog to let it effective
sudo usermod -a -G docker afa && \
(echo "unlog to be really added to docker groups" ; exit 0) || \
(echo "user afa was not added to group docker" ; exit 1)
