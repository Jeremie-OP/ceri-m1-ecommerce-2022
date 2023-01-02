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
        image = "europe-west1-docker.pkg.dev/cerythme-373316/cerythme/frontend:0.0.5"
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

# Create public access
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.graytiger-frontend.location
  project     = google_cloud_run_service.graytiger-frontend.project
  service     = google_cloud_run_service.graytiger-frontend.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

# Return service URL
output "url" {
  value = "${google_cloud_run_service.graytiger-frontend.status[0].url}"
}