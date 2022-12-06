terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme"
    }
  }
}

provider "google" {
  project = "ceri-m1-ecommerce-2022"
  region  = "europe-west1"  
  credentials = var.gcp-creds
}

variable "gcp-creds" {
  default=""
}

resource "google_cloud_run_service" "cerythme_backend_service" {
  name         = "cerythme_backend"
  location     = "europe-west1"
  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/backend:latest"
      }
    }
  }
}

resource "google_cloud_run_service" "cerythme_frontend_service" {
  name         = "cerythme_frontend"
  location     = "europe-west1"
  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/frontend:latest"
      }
    }
  }
}