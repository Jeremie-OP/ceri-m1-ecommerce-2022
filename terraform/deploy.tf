terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "cerythme"
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
  provider = google
  name         = "cerythme_backend"
  location     = "europe-west1"
  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/backend:latest"
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
        "autoscaling.knative.dev/minScale" = "1"
      }
    }
  }
}

resource "google_cloud_run_service" "cerythme_frontend_service" {
  provider = google
  name         = "cerythme_frontend"
  location     = "europe-west1"
  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/frontend:latest"
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
        "autoscaling.knative.dev/minScale" = "1"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

output "cloud_run_instance_url" {
  value = google_cloud_run_service.cerythme_frontend.status.0.url
}