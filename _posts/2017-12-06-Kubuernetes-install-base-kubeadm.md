---
layout: post
title: Kubuernetes install base kubeadm
tags: [Kubuernetes, kubeadm]
categories:
- blog
---

## Note  
---

##### ENV: CentOS 7



USED FOR INTERNAL DEV ENVIRONMENT,NOT RECOMMEND FOR PRO.

Updated: 2017-12-6



1, OUTLINE

- BASE SETTING
- Docker
- Kubectl
- Kubelet && kubeadm

2, BASE SETTING

Images and files donwload

Link：https://pan.baidu.com/s/1eRMdwu2 Pass：nucm



host

    cat >> /etc/hosts <<EOF
    10.0.15.98 k8smaster
    10.0.15.110 k8node1
    10.0.15.115 k8node2
    EOF

secure setting

    setenfore 0
    sed -i 's;SELINUX=enforcing;SELINUX=disabled;' /etc/sysconfig/selinux 
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    iptables -F

software[optional]

    yum -y install zip unzip wget lrzsz

Master PORT

  TCP   Inbound 6443*       Kubernetes API server           
  TCP   Inbound 2379-2380   etcd server client API          
  TCP   Inbound 10250       Kubelet API                     
  TCP   Inbound 10251       kube-scheduler                  
  TCP   Inbound 10252       kube-controller-manager         
  TCP   Inbound 10255       Read-only Kubelet API (Heapster)

Node PORT

  TCP   Inbound 10250       Kubelet API                             
  TCP   Inbound 10255       Read-only Kubelet API (Heapster)        
  TCP   Inbound 30000-32767 Default port range for NodePort Services. Typically, these ports would need to be exposed to external load-balancers, or other external consumers of the application itself.

tips

Enable yum proxy

    echo "proxy=http://proxy.exyum.com:7777/" >> /etc/yum.conf

Enable docker http registry for version 12.x

    echo '{ "insecure-registries":["10.0.15.166:5555"] }' > /etc/docker/daemon.json
    systemctl restart docker

ref: https://github.com/docker/distribution/issues/1874



3, Docker

Add yum repo and install docker service.

    tee /etc/yum.repos.d/docker.repo <<-'EOF'
    [dockerrepo]
    name=Docker Repository
    baseurl=https://yum.dockerproject.org/repo/main/centos/7/
    enabled=1
    gpgcheck=1
    gpgkey=https://yum.dockerproject.org/gpg
    EOF
    
    #yum list docker-engine --showduplicates
    
    yum install docker-engine-1.12.6 docker-engine-selinux-1.12.6 -y
    systemctl enable docker ; systemctl start docker



4, kubectl

Download the kube client tool which version is 1.7.1.

kubectl cluster-info should get cluster  info failed ,it's ok.It was used to verify the tool.

    wget https://storage.googleapis.com/kubernetes-release/release/v1.7.1/bin/linux/amd64/kubectl
    mv ./kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && kubectl cluster-info



5, YUM repo for kubernetes

Add kubernetes repo base Aliyun to install kubelet and kubeadm.

Since the version of kubernetes of Aliyun support for 1.7.5 now, 2017-12-6 。

    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=0
    repo_gpgcheck=0
    gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
            http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
    EOF
    
    setenforce 0
    yum install -y kubelet kubeadm
    systemctl enable kubelet && systemctl start kubelet

show kube api-server version

    kubectl version

The server is the kube-api server version info.



Google [unused]

    # vi /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
            https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg



6, Import docker images

Operation on master to import all images.

    imageDir="images"
    for imgFile in `ls ${imageDir}`;
      do
        echo "start loading image from ${imgFile}"
        docker load < ${imageDir}/${imgFile}
        echo "finish loading image from ${imgFile}"
      done



7, kubeadm init

    kubeadm init --kubernetes-version=v1.7.1

Res:

    To start using your cluster, you need to run (as a regular user):
    
      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
      http://kubernetes.io/docs/admin/addons/
    
    You can now join any number of machines by running the following on each node
    as root:
    
      kubeadm join --token c793a8.0eea1fa391e8fa8c 10.0.15.98:6443
    

show token value：

    kubeadm token list | grep authentication,signing | awk '{print $1}'



dns network

    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f calico.yaml

dashboard frontend

    kubectl create -f kubernetes-dashboard.yaml



8, Add nodes

Import images first

    imageDir="images"
    images="kube-proxy-amd64-v1.7.1.tar node-v1.3.0.tar cni-v1.9.1.tar pause-amd64-3.0.tar kubernetes-dashboard-amd64-v1.6.1.tar"
    for imgFile in ${images}
    do
        echo "start loading image from ${imgFile}"
        docker load < ${imageDir}/${imgFile}
        echo "finish loading image from ${imgFile}"
    done

Use token to register

    kubeadm join --skip-preflight-checks --token c793a8.0eea1fa391e8fa8c 10.0.15.98:6443

9, heapster monitor

download the yaml files:https://github.com/kubernetes/heapster/tree/master/deploy/kube-config/influxdb

- grafana.yaml
- heapster.yaml
- influxdb.yaml

Modify file grafana-service.yaml the port 80 to 3000 incase conflict.

To expose the port uncomment below:

    type: NodePort

Install：

    kubectl create -f .



Scene：heapster安装成功但是没有具体视图

Los：

    E0903 07:09:35.016005 1 reflector.go:190] k8s.io/heapster/metrics/util/util.go:51: Failed to list *v1.Node: User "system:serviceaccount:kube-system:heapster" cannot list nodes at the cluster scope. (get nodes)

定义一个名为 heapster 的 ServiceAccount，然后将它和 Cluster Role view 绑定

    kubectl apply -f https://github.com/kubernetes/heapster/blob/master/deploy/kube-config/rbac/heapster-rbac.yaml



10, Error

    #1 reflector.go:201] k8s.io/kubernetes/pkg/client/informers/informers_generated/externalversions/factory.go:72: Failed to list *v1.PersistentVolumeClaim: Get https://10.0.15.98:6443/api/v1/persistentvolumeclaims?resourceVersion=0: Forbidden
     
    
    #error: failed to run Kubelet: failed to create kubelet: misconfiguration: kubelet cgroup driver: "systemd" is different from docker cgroup driver: "cgroupfs"
    
    sed -i 's;systemd;cgroupfs;'  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    systemctl daemon-reload
    systemctl restart kubelet
    
    # kubectl get nodes
    The connection to the server localhost:8080 was refused - did you specify the right host or port?
    
    kubectl --kubeconfig /etc/kubernetes/kubelet.conf get pods

11, ScreenShot
    ![success pic](https://raw.githubusercontent.com/xyzsss/xyzsss.github.io/master/assets/images/k8s-pic.png)

12, REF

- http://niuhp.com/docker/kubernetes-cluster-on-centos7-64.html

---
end
