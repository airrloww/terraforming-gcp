terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("terraform-admin-key.json")
}