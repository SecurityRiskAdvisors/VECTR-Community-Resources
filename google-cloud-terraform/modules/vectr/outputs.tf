output "vectr_url" {
  description = "URL to access VECTR (via the compute engine instance IP address)"
  value       = "https://${google_compute_instance.vectr.network_interface[0].access_config[0].nat_ip}"
}