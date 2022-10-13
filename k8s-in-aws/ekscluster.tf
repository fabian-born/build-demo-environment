
resource "aws_eks_cluster" "ekscluster" {
  name     = "${var.prefix}-${random_pet.prefix.id}"
  role_arn = aws_iam_role.eksrole.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eksClusterPolicy,
    aws_iam_role_policy_attachment.eksVPCResourceController,
  ]
}


resource "aws_eks_node_group" "eksnodegroup" {
  cluster_name    = aws_eks_cluster.ekscluster.name
  node_group_name = "${random_pet.prefix.id}-ng"
  node_role_arn   = aws_iam_role.eksrole.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 0
    max_size     = 2
    min_size     = 0
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  timeouts {}
  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.

}



#### Build Kubeconfig ####
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.ekscluster.id
}

data "aws_eks_cluster_auth" "ephemeral" {
  name = aws_eks_cluster.ekscluster.id
}

locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "${data.aws_eks_cluster.this.id}"
    clusters = [{
      name = data.aws_eks_cluster.this.id
      cluster = {
        certificate-authority-data = data.aws_eks_cluster.this.certificate_authority[0].data
        server                     = data.aws_eks_cluster.this.endpoint
      }
    }]
    contexts = [{
      name = "${data.aws_eks_cluster.this.id}"
      context = {
        cluster = data.aws_eks_cluster.this.id
        user    = "${data.aws_eks_cluster.this.id}"
      }
    }]
    users = [{
      name = "${data.aws_eks_cluster.this.id}"
      user = {
        token = data.aws_eks_cluster_auth.ephemeral.token
      }
    }]
  })
}