module "vectr" {
  source = "./modules/vectr/"
  /*vectr_version = "8.8.1" // Currently 8.8.1 is the only supported VECTR version for this Terraform module
  vectr_instance_name = "" // Hostname of VECTR instance
  vectr_compute_region = "" // Region to deploy VECTR infrastructure
  vectr_compute_zone = "" // Zone to deploy VECTR infrastructure
  vectr_subnet_cidr = "" // VECTR VPC network internal CIDR
  vectr_source_addresses = [""] // CIDR ranges to allow HTTPS, SSH, and ICMP access to VECTR*/
}