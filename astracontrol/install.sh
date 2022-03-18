#!/bin/bash

echo "Clone default config"

function install_metallb(){
    echo "Install Metallb"
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/metallb.yaml

    # k apply -f metallb-astra-poc.yaml 
}

function install_trident(){
    echo "Downloading and Extracting Trident"
    wget https://github.com/NetApp/trident/releases/download/v21.10.1/trident-installer-21.01.1.tar.gz
    tar xfvz trident-installer-21.10.1.tar.gz

    cd trident-installer
    echo "Install Trident"

    kubectl create -f deploy/crds/trident.netapp.io_tridentorchestrators_crd_post1.16.yaml                                                                                                         
    
    kubectl apply -f deploy/namespace.yaml
    kubectl create -f deploy/bundle.yaml
    
    kubectl create -f deploy/crds/tridentorchestrator_cr.yaml 
    cd ..
    echo "clean up"
    rm -rf trident-installer*
}

function install_snapshoter(){
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

    kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
}

function setup_trident_backend(){
    echo Deploy trident Storage Class
    cd manifests
    kubectl apply -f trident-backend.yaml -n trident
    kubectl apply -f trident-sc.yaml
    kubectl apply -f tridentsnap-sc.yaml
    cd ..
    
}

function install_astracc(){
    echo "++++++++++++++++++++++++++++++++++++"
    echo "+ install Astra CC                 +"
    echo "++++++++++++++++++++++++++++++++++++"
    podman login my.registry.com -u username -p password
    export  REGISTRY=my.registry.com/usernname/docker-images
     
    [ ! -d "./astra-control-center-21.12.60" ] &&  tar xfvz astra-control-center-21.12.60.tar.gz
    cd astra-control-center-21.12.60

    for astraImageFile in $(ls images/*.tar) ; do
        astraImage=$(podman load --input ${astraImageFile} | sed 's/Loaded image(s): localhost\///')  
        regImage=`echo ${REGISTRY}/${astraImage} | sed 's/ //g'`
        echo ${astraImage} ${regImage}
        
        podman tag ${astraImage} ${regImage}
        podman push ${regImage}
    done
    cd ..


    kubectl apply -f https://raw.githubusercontent.com/project-epicshit/k8s-helper/main/cred-checker/credential-checker.yaml 
    kubectl create ns netapp-acc-operator
    kubectl create ns netapp-acc
    kubectl create secret docker-registry astra-registry-cred --docker-server=my.registry.com --docker-username=username --docker-password="password" -n kube-system
    kubectl create secret docker-registry astra-registry-cred --docker-server=my.registry.com --docker-username=username --docker-password="password" -n netapp-acc-operator
    kubectl create secret docker-registry astra-registry-cred --docker-server=my.registry.com --docker-username=username --docker-password="password" -n netapp-acc
    kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "astra-registry-cred"}]}' -n netapp-acc
    kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "astra-registry-cred"}]}' -n netapp-acc-operator
    kubectl apply -f ./manifests/astra_control_center_operator_deploy.yaml
    kubectl apply -f ./manifests/astra_control_center_min.yaml -n netapp-acc

    kubectl get acc -o yaml -n netapp-acc | grep uuid

}

