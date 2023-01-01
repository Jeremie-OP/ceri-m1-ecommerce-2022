terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme-backend"
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
variable "MYSQL_DATABASE" {
  default=""
}
variable "MYSQL_USER" {
  default=""
}
variable "MYSQL_PASSWORD" {
  default=""
}

resource "google_cloud_run_service" "graytiger-backend" {
  provider = google
  name         = "graytiger-backend"
  location     = "europe-west1"
  template {
    spec {
      service_account_name = "admin-service@cerythme-373316.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/cerythme-373316/cerythme/backend:0.0.3"
        env {
          name  = "GOOGLE_CREDS"
          value = var.gcp-creds
        }   
        env {
          name  = "MYSQL_DATABASE"
          value = var.MYSQL_DATABASE
        }   
        env {
          name  = "MYSQL_USER"
          value = var.MYSQL_USER
        }   
        env {
          name  = "MYSQL_PASSWORD"
          value = var.MYSQL_PASSWORD
        }   
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
