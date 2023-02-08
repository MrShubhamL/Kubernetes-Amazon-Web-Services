# Kubernetes-Amazon-Web-Services
Installation and setup of kubernetes cluster on Amazon Linux 2 using t2.small instance.

# Master-Node Installation Script
Add this given script in user data while launching the master node instance in aws

    #!/bin/bash
    sudo yum update -y
    sudo yum upgrade -y

    sudo hostnamectl set-hostname master-node
    sudo bash

    sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo 
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
    enabled=1
    gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    exclude=kubelet kubeadm kubectl
    EOF


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

    sudo kubeadm init --ignore-preflight-errors=ALL > /home/ec2-user/kubernetes_access_token.txt
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    export KUBECONFIG=/etc/kubernetes/admin.conf

    sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/calico.yaml -O
    kubectl apply -f calico.yaml
    
    if [[ $? == 0 ]]
    then
        echo "installtion Successful" > /home/ec2-user/installation_status.txt
    else
        echo "installtion Failed" > /home/ec2-user/installation_status.txt
        
        
# Worker-Node-01 Installation Script  
Add this given script in user data while launching the worker node instance in aws

    #!/bin/bash
    sudo yum update -y
    sudo yum upgrade -y

    sudo hostnamectl set-hostname worker-node-01
    sudo bash

    sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo 
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
    enabled=1
    gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    exclude=kubelet kubeadm kubectl
    EOF


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
    
    if [[ $? == 0 ]]
    then
        echo "installtion Successful" > /home/ec2-user/installation_status.txt
    else
        echo "installtion Failed" > /home/ec2-user/installation_status.txt
        
        
        
