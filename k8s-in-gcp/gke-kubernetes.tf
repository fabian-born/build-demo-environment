module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id   = var.gcp-project
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "../delivery/kubeconfig-gcp-${random_pet.prefix.id}"
}


resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "kubectl ${var.cmd_snapshotter} --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = base64encode(module.gke_auth.kubeconfig_raw)
    }
  }
}
