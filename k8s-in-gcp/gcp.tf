resource "random_pet" "prefix" {}

data "google_client_config" "default" {}

provider "google" {
  credentials = "${file("../credentials/account.json")}"
  project = "${var.gcp-project}"
  region  = "europe-west3"
  zone    = "europe-west3-c"
}

resource "google_container_cluster" "primary" {
  name               = "${var.prefix}${random_pet.prefix.id}"
  location           = "europe-west3-c"
  initial_node_count = 1
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    image_type = "UBUNTU"
    preemptible = false
    machine_type = "e2-medium"
    disk_type = "pd-standard"
    service_account = "default"
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}



data "google_container_cluster" "xprimary" {
  name     = "${var.prefix}${random_pet.prefix.id}"
  location = "europe-west3-c"
}

/*
output "cluster_username" {
  value = data.google_container_cluster.xprimary.master_auth[0].username
}

output "cluster_password" {
  value = data.google_container_cluster.xprimary.master_auth[0].password
}

output "endpoint" {
  value = data.google_container_cluster.xprimary.endpoint
}

output "instance_group_urls" {
  value = data.google_container_cluster.xprimary.instance_group_urls
}

output "node_config" {
  value = data.google_container_cluster.xprimary.node_config
}

output "node_pools" {
  value = data.google_container_cluster.xprimary.node_pool
}
*
*/
