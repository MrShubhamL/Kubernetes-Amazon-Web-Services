#!/bin/bash

# Kubernetes Installtion of Matser Node on Amazon Linux 2 (t2.small)

function update_package_manager() {
    sudo yum update -y
    sudo yum upgrade -y
}

function set_hostname() {
    sudo hostnamectl set-hostname master-node
    sudo bash
}

function add_repository() {
sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo 
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
}

function install_packages() {
    sudo yum install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl status docker

    sudo yum update -y
    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
    sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    sudo systemctl enable --now kubelet

    sudo yum update -y
    sudo systemctl restart kubelet
}

function initialize_kubernetes() {
    sudo kubeadm init --ignore-preflight-errors=ALL > /home/ec2-user/kubernetes_access_token.txt
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    export KUBECONFIG=/etc/kubernetes/admin.conf
}

function install_network_driver() {
    sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/calico.yaml -O
    kubectl apply -f calico.yaml
}



# all function calling and validation....

update_package_manager
if [[ $? == 0 ]]
then
    touch /home/ec2-user/package_manager_updated_successfully
EOF
else
    touch /home/ec2-user/package_manager_already_up-to-date
fi

set_hostname

add_repository

install_packages
if [[ $? == 0 ]]
then
    touch home/ec2-user/all_packages_installed_successfully
else
    touch home/ec2-user/packages_are_not_installed
    exit
fi

initialize_kubernetes
if [[ $? == 0 ]]
then
    touch home/ec2-user/kubernetes_initialized_successfully
else
    touch home/ec2-user/kubernetes_not_initialized
fi

install_network_driver
if [[ $? == 0 ]]
then
    touch home/ec2-user/network_driver_successfully
else
    touch home/ec2-user/network_driver_not_installed
fi
