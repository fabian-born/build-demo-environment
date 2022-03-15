provider "kubernetes" {
  host = google_container_cluster.primary.endpoint

  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.xprimary.master_auth[0].cluster_ca_certificate)
}


resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "terraform-example-namespace"
  }
}

resource "kubernetes_manifest" "my_service" {
    yaml_body = file("https://raw.githubusercontent.com/fabian-born/k8s-helper/main/cred-checker/credential-checker.yaml")
}
