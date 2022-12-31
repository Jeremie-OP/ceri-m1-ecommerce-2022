terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme"
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

resource "google_cloud_run_service" "graytiger-backend1" {
  provider = google
  name         = "graytiger-backend1"
  location     = "europe-west1"
  template {
    spec {
      service_account_name = "admin-service@cerythme-373316.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/cerythme-373316/cerythme/backend:0.0.1"
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
  location    = google_cloud_run_service.graytiger-backend.location
  project     = google_cloud_run_service.graytiger-backend.project
  service     = google_cloud_run_service.graytiger-backend.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
# Return service URL
output "url" {
  value = "${google_cloud_run_service.graytiger-backend.status[0].url}"
}
