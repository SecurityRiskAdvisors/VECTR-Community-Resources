variable "vectr_version" {
  type        = string
  description = "Version of VECTR to run (ex. 8.8.1)"
  default = "8.8.1"
  validation {
    condition     = contains(["8.8.1"], var.vectr_version)
    error_message = "Valid values for var: vectr_version are (8.8.1)."
  } 
}

variable "vectr_instance_name" {
  type        = string
  description = "Hostname of VECTR instance"
  default = "vectr"
}

variable "vectr_compute_region" {
  type        = string
  description = "Region to deploy VECTR infrastructure"
  validation {
    condition     = contains(["asia-east1","asia-east2","asia-northeast1","asia-northeast2","asia-northeast3","asia-south1","asia-south2","asia-southeast1","asia-southeast2","australia-southeast1","australia-southeast2","europe-central2","europe-north1","europe-southwest1","europe-west1","europe-west10","europe-west12","europe-west2","europe-west3","europe-west4","europe-west6","europe-west8","europe-west9","me-central1","me-west1","northamerica-northeast1","northamerica-northeast2","southamerica-east1","southamerica-west1","us-central1","us-east1","us-east4","us-east5","us-south1","us-west1","us-west2","us-west3","us-west4"], var.vectr_compute_region)
    error_message = "Valid values for var: vectr_compute_region are (asia-east1, asia-east2, asia-northeast1, asia-northeast2, asia-northeast3, asia-south1, asia-south2, asia-southeast1, asia-southeast2, australia-southeast1, australia-southeast2, europe-central2, europe-north1, europe-southwest1, europe-west1, europe-west10, europe-west12, europe-west2, europe-west3, europe-west4, europe-west6, europe-west8, europe-west9, me-central1, me-west1, northamerica-northeast1, northamerica-northeast2, southamerica-east1, southamerica-west1, us-central1, us-east1, us-east4, us-east5, us-south1, us-west1, us-west2, us-west3, us-west4)."
  } 
}

variable "vectr_compute_zone" {
  type        = string
  description = "Zone to deploy VECTR infrastructure"
  validation {
    condition     = contains(["us-east1-b","us-east1-c","us-east1-d","us-east4-c","us-east4-b","us-east4-a","us-central1-c","us-central1-a","us-central1-f","us-central1-b","us-west1-b","us-west1-c","us-west1-a","europe-west4-a","europe-west4-b","europe-west4-c","europe-west1-b","europe-west1-d","europe-west1-c","europe-west3-c","europe-west3-a","europe-west3-b","europe-west2-c","europe-west2-b","europe-west2-a","asia-east1-b","asia-east1-a","asia-east1-c","asia-southeast1-b","asia-southeast1-a","asia-southeast1-c","asia-northeast1-b","asia-northeast1-c","asia-northeast1-a","asia-south1-c","asia-south1-b","asia-south1-a","australia-southeast1-b","australia-southeast1-c","australia-southeast1-a","southamerica-east1-b","southamerica-east1-c","southamerica-east1-a","asia-east2-a","asia-east2-b","asia-east2-c","asia-northeast2-a","asia-northeast2-b","asia-northeast2-c","asia-northeast3-a","asia-northeast3-b","asia-northeast3-c","asia-south2-a","asia-south2-b","asia-south2-c","asia-southeast2-a","asia-southeast2-b","asia-southeast2-c","australia-southeast2-a","australia-southeast2-b","australia-southeast2-c","europe-central2-a","europe-central2-b","europe-central2-c","europe-north1-a","europe-north1-b","europe-north1-c","europe-southwest1-a","europe-southwest1-b","europe-southwest1-c","europe-west10-a","europe-west10-b","europe-west10-c","europe-west12-a","europe-west12-b","europe-west12-c","europe-west6-a","europe-west6-b","europe-west6-c","europe-west8-a","europe-west8-b","europe-west8-c","europe-west9-a","europe-west9-b","europe-west9-c","me-central1-a","me-central1-b","me-central1-c","me-west1-a","me-west1-b","me-west1-c","northamerica-northeast1-a","northamerica-northeast1-b","northamerica-northeast1-c","northamerica-northeast2-a","northamerica-northeast2-b","northamerica-northeast2-c","southamerica-west1-a","southamerica-west1-b","southamerica-west1-c","us-east5-a","us-east5-b","us-east5-c","us-south1-a","us-south1-b","us-south1-c","us-west2-a","us-west2-b","us-west2-c","us-west3-a","us-west3-b","us-west3-c","us-west4-a","us-west4-b","us-west4-c"], var.vectr_compute_zone)
    error_message = "Valid values for var: vectr_compute_zone are (us-east1-b, us-east1-c, us-east1-d, us-east4-c, us-east4-b, us-east4-a, us-central1-c, us-central1-a, us-central1-f, us-central1-b, us-west1-b, us-west1-c, us-west1-a, europe-west4-a, europe-west4-b, europe-west4-c, europe-west1-b, europe-west1-d, europe-west1-c, europe-west3-c, europe-west3-a, europe-west3-b, europe-west2-c, europe-west2-b, europe-west2-a, asia-east1-b, asia-east1-a, asia-east1-c, asia-southeast1-b, asia-southeast1-a, asia-southeast1-c, asia-northeast1-b, asia-northeast1-c, asia-northeast1-a, asia-south1-c, asia-south1-b, asia-south1-a, australia-southeast1-b, australia-southeast1-c, australia-southeast1-a, southamerica-east1-b, southamerica-east1-c, southamerica-east1-a, asia-east2-a, asia-east2-b, asia-east2-c, asia-northeast2-a, asia-northeast2-b, asia-northeast2-c, asia-northeast3-a, asia-northeast3-b, asia-northeast3-c, asia-south2-a, asia-south2-b, asia-south2-c, asia-southeast2-a, asia-southeast2-b, asia-southeast2-c, australia-southeast2-a, australia-southeast2-b, australia-southeast2-c, europe-central2-a, europe-central2-b, europe-central2-c, europe-north1-a, europe-north1-b, europe-north1-c, europe-southwest1-a, europe-southwest1-b, europe-southwest1-c, europe-west10-a, europe-west10-b, europe-west10-c, europe-west12-a, europe-west12-b, europe-west12-c, europe-west6-a, europe-west6-b, europe-west6-c, europe-west8-a, europe-west8-b, europe-west8-c, europe-west9-a, europe-west9-b, europe-west9-c, me-central1-a, me-central1-b, me-central1-c, me-west1-a, me-west1-b, me-west1-c, northamerica-northeast1-a, northamerica-northeast1-b, northamerica-northeast1-c, northamerica-northeast2-a, northamerica-northeast2-b, northamerica-northeast2-c, southamerica-west1-a, southamerica-west1-b, southamerica-west1-c, us-east5-a, us-east5-b, us-east5-c, us-south1-a, us-south1-b, us-south1-c, us-west2-a, us-west2-b, us-west2-c, us-west3-a, us-west3-b, us-west3-c, us-west4-a, us-west4-b, us-west4-c)."
  }
}

variable "vectr_subnet_cidr" {
  type = string
  description = "VECTR VPC network internal CIDR"
  validation {
    condition =  can(cidrnetmask(var.vectr_subnet_cidr))
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
}

variable "vectr_source_addresses" {
  type = set(string)
  description = "CIDR ranges to allow HTTPS, SSH, and ICMP access to VECTR"
  validation {
    condition = alltrue([
      for a in var.vectr_source_addresses : can(cidrnetmask(a))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
}