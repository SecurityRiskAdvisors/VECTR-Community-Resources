terraform{
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "~> 4.78.0"
        }
    }
}

provider "google" {
  /*project     = ""
  region      = ""*/
}