/*
output "kubeconfig_raw" {
  value = module.gke_auth.kubeconfig_raw
}

output "kubernetes_cluster_name" {
  value       = nonsensitive(data.google_client_config.provider.access_token)
  description = "GKE Cluster Name"
}
output "kubernetes_cluster_host" {
  sensitive = true
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

*/
