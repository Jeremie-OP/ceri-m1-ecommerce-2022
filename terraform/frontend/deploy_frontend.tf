terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme-frontend-ceri"
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

resource "google_cloud_run_service" "graytiger-frontend" {
  provider = google
  name         = "graytiger-frontend"
  location     = "europe-west1"
  template {
    spec {
      service_account_name = "terraform-graytiger@ceri-m1-ecommerce-2022.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/frontend:0.0.10"
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

# # Create public access
# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers",
#     ]
#   }
# }

# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  location    = google_cloud_run_service.graytiger-frontend.location
  project     = google_cloud_run_service.graytiger-frontend.project
  service     = google_cloud_run_service.graytiger-frontend.name
}

# Return service URL
output "url" {
  value = "${google_cloud_run_service.graytiger-frontend.status[0].url}"
}