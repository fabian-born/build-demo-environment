##### AZURE ####
variable "az_appId" {
  default = ""
}
variable "az_password" {
  default = ""
}
variable "aks_node_number" {
    default = 3
}

variable "cmd_snapshotter" {
    default = "apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.0.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml"
}

variable "az_location" {
    default = "germanywestcentral"
}

variable "az_tenantId" {
    default = ""
}

variable "az_existingRG" {
    default = ""
}

variable "az_anfaccount" {
    default = ""
}
variable "prefix" {
    default = "noprefix"
}
variable "az_anf_sl" { default = "standard" }
variable "az_anf_poolsize" { default = "4" }
variable "az_anf_poolname" { default = "unknown" }
