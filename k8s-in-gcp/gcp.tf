

provider "google" {
  credentials = "${file("../credentials/account.json")}"
  project = "${var.gcp-project}"
  region  = var.region
  zone    = "europe-west3-c"
}

#  name               = "${var.prefix}${random_pet.prefix.id}"
#  location           = "europe-west3-c"

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

locals {
  cluster_type = "simple-regional"
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "${var.gcp-project}"
  name                       = "${var.prefix}${random_pet.prefix.id}"
  region                     = var.region
  create_service_account = false
  regional               = true
  # zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-medium"
#      node_locations            = "us-central1-b,us-central1-c"
      min_count                 = 1
      max_count                 = 100
      local_ssd_count           = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "UBUNTU"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "${var.gcp-sa}"
      preemptible               = false
      initial_node_count        = 4
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id   = var.gcp-project
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "./gke-kubeconfig"
}
