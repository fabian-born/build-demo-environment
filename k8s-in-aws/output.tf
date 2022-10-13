output "endpoint" {
  value = aws_eks_cluster.ekscluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.ekscluster.certificate_authority[0].data
}


output "kubeconfig" {
  value = "${local.kubeconfig}"
  sensitive = true
}


resource "local_file" "kubeconfig" {
  content  = "${local.kubeconfig}"
  filename = "./kubeconfig-eks-${random_pet.prefix.id}"
}