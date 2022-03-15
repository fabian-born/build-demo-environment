/* 
output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  sensitive = true
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

*/
