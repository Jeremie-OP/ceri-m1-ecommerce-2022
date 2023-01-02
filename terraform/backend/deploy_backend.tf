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

resource "google_secret_manager_secret" "mysql-address" {
  secret_id = "mysql-address"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "mysql-user" {
  secret_id = "mysql-user"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "mysql-password" {
  secret_id = "mysql-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "mysql-database" {
  secret_id = "mysql-database"
  replication {
    automatic = true
  }
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
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.mysql-address.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name  = "MYSQL_DATABASE"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.mysql-database.secret_id
              key  = "latest"
            }
          }
        }   
        env {
          name  = "MYSQL_USER"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.mysql-user.secret_id
              key  = "latest"
            }
          }
        }   
        env {
          name  = "MYSQL_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.mysql-password.secret_id
              key  = "latest"
            }
          }
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
