terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme-frontend"
    }
  }
}

provider "google" {
  project = "cerythme-373316"
  region  = "europe-west1"  
  credentials = var.gcp-creds
}

variable "gcp-creds" {
  default=""
}

resource "google_cloud_run_service" "graytiger-frontend" {
  provider = google
  name         = "graytiger-frontend"
  location     = "europe-west1"
  template {
    spec {
      service_account_name = "admin-service@cerythme-373316.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/cerythme-373316/cerythme/frontend:latest"
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}


# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  location    = google_cloud_run_service.graytiger-frontend.location
  project     = google_cloud_run_service.graytiger-frontend.project
  service     = google_cloud_run_service.graytiger-frontend.name
  role = "roles/run.invoker"
  member = "allUsers"
}

# Return service URL
output "url" {
  value = "${google_cloud_run_service.graytiger-frontend.status[0].url}"
}