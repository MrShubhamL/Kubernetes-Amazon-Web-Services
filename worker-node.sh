#!/bin/bash

# Kubernetes Installtion of Worker Node on Amazon Linux 2 (t2.micro)

function update_package_manager() {
    sudo yum update -y
    sudo yum upgrade -y
}

function set_hostname() {
    sudo hostnamectl set-hostname worker-node-01
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
