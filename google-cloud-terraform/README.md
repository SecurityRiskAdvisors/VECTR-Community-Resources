# VECTR in Google Cloud

## About 
This Terraform module can be used to deploy VECTR to your Google Cloud environment. For more information about VECTR visit [vectr.io](https://vectr.io) and/or [SRA's VECTR GitHub Repository](https://github.com/SecurityRiskAdvisors/VECTR).

## TLDR
1. Install Google Cloud CLI and Terraform on your machine
2. Modify the providers.tf file with your Google Cloud Project information
3. Modify the main.tf file with appropriate parameters
4. Perform the Terraform Deployment
5. Navigate to https://{VM public IP address}
6. Log in with default credentials:
    - Username: "admin"
    - Password: "11_ThisIsTheFirstPassword_11"


## Setup
Prior to deploying this Terraform module, both Terraform and the Google Cloud CLI must be installed on your system. Refer to the links below for additional detail:

- Terraform Installation: [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)
- Google Cloud CLI: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)

Additional information on the Terraform Google Cloud Provider, including authentication configurations, can be found in the following link: [https://registry.terraform.io/providers/hashicorp/google/latest/docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs).

Alternatively, consider using Cloud Shell within the Google Cloud Console which has both the Google Cloud CLI and Terraform installed by default.

## Pre-Deployment
Prior to deploying this Terraform module modify the files described in the following sections.

### providers.tf
Modify the providers.tf file in the top level directory with your Google Cloud Project ID and default region. 

Example:
```
provider "google" {
  project     = "your-project-id"
  region      = "us-east1"
}
```

### main.tf
Specify the input variables in the main.tf file vectr module in the top level directory as shown below. Note, this is an optional step, as variables can be provided at runtime. Refer to the /modules/vectr/variables.tf file for variable descriptions, types, and allowed values.

Example:
```
module "vectr" {
  source = "./modules/vectr/"
  vectr_version = "8.8.1" // Currently 8.8.1 is the only supported VECTR version for this Terraform module
  vectr_instance_name = "vectr" // Hostname of VECTR instance
  vectr_compute_region = "us-east1" // Region to deploy VECTR infrastructure
  vectr_compute_zone = "us-east1-b" // Zone to deploy VECTR infrastructure
  vectr_subnet_cidr = "10.128.0.0/20" // VECTR VPC network internal CIDR
  vectr_source_addresses = ["1.1.1.1/32"] // CIDR ranges to allow HTTPS, SSH, and ICMP access to VECTR
}
```

## Deployment
Perform the Terraform deployment from the top level directory using `terraform init` and `terraform apply`. For additional information on Terraform commands, visit the following link: [https://developer.hashicorp.com/terraform/cli/commands](https://developer.hashicorp.com/terraform/cli/commands)

## Post-Deployment
Once the VECTR Terraform module has been deployed to Google Cloud, it may take several minutes for VECTR services to begin. Navigate to the VECTR URL which is noted in the Terraform output _vectr_url_ (in the format "https://" + _VECTR public IP address_).

Once all VECTR services are running, you will be presented a certificate warning (unless you have configured DNS and a trusted certificate). Proceed past the certificate warning to the VECTR login page. Use the default username "admin" and default password "11_ThisIsTheFirstPassword_11" (both without quotation marks) for the initial login. For user management and other VECTR configuration information, review the VECTR documentation found at [https://docs.vectr.io](https://docs.vectr.io).

## Additional Considerations
This module can be further customized to meet your organization's security requirements. Examples of security configurations you may want to implement include the following:
- Fronting VECTR with a load balancer which uses a public DNS record for your domain and a trusted TLS certificate
- Removing the public IP address and only allowing connectivity from your internal network
- Installing your organization's endpoint security tools on the VECTR Compute Engine VM
- Deploying VECTR in a VPC subnet which is protected by a network firewall