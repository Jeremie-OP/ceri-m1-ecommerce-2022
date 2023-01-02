terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme-backend-ceri"
    }
  }
}

provider "google" {
  project = "ceri-m1-ecommerce-2022"
  region  = "europe-west1"  
  credentials = var.gcp-creds
}

data "google_secret_manager_secret_version" "mysql-address" {
  secret = "mysql-address"
}

data "google_secret_manager_secret_version" "mysql-user" {
  secret = "mysql-user"
}

data "google_secret_manager_secret_version" "mysql-password" {
  secret = "mysql-password"
}

data "google_secret_manager_secret_version" "mysql-database" {
  secret_id = "mysql-database"
}

variable "gcp-creds" {
  default=""
}

resource "google_cloud_run_service" "graytiger-backend" {
  provider = google
  name         = "graytiger-backend"
  location     = "europe-west1"
  template {
    spec {
      service_account_name = "terraform-graytiger@ceri-m1-ecommerce-2022.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/backend:0.0.9"
        env {
          name  = "MYSQL_ADDRESS"
          value = google_secret_manager_secret_version.mysql-address.secret_data
        }
        env {
          name  = "MYSQL_DATABASE"
          value = google_secret_manager_secret_version.mysql-database.secret_data
        }   
        env {
          name  = "MYSQL_USER"
          value = google_secret_manager_secret_version.mysql-user.secret_data
        }   
        env {
          name  = "MYSQL_PASSWORD"
          value = google_secret_manager_secret_version.mysql-password.secret_data
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
