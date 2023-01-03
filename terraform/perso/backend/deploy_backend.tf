terraform {
  cloud {
    organization = "jeremieopigez"

    workspaces {
      name = "Cerythme-backend"
    }
  }
}

provider "google-personal" {
  project     = "cerythme-373316"
  region      = "europe-west1"
  credentials = var.gcp-creds
}

provider "google" {
  project     = "ceri-m1-ecommerce-2022"
  region      = "europe-west1"
  credentials = var.GOOGLE_APPLICATION_CREDENTIALS
}

data "google_secret_manager_secret_version" "mysql-address" {
  provider = google
  secret   = mysql-address
}

variable "gcp-creds" {
  default = ""
}
variable "GOOGLE_APPLICATION_CREDENTIALS" {
  default = ""
}
variable "MYSQL_PASSWORD" {
  default = ""
}
# using google_secret_manager_secret_version ressource for read only access
data "google_secret_manager_secret" "mysql-address" {
  provider  = google
  secret_id = "mysql-address"
}
# data "google_secret_manager_secret" "mysql-user-graytiger" {
#   secret_id = "mysql-user-graytiger"
# }
data "google_secret_manager_secret" "mysql-database-graytiger" {
  provider  = google
  secret_id = "mysql-database-graytiger"
}

resource "google_cloud_run_service" "graytiger-backend" {
  provider = google-personal
  name     = "graytiger-backend"
  location = "europe-west1"
  template {
    spec {
      service_account_name = "admin-service@cerythme-373316.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/cerythme-373316/cerythme/backend:latest"
        env {
          name = "MYSQL_ADDRESS"
          value_from {
            secret_key_ref {
              name = data.google_secret_manager_secret.mysql-address.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name = "MYSQL_DATABASE"
          value_from {
            secret_key_ref {
              name = data.google_secret_manager_secret.mysql-database-graytiger.secret_id
              key  = "latest"
            }
          }
        }
        # env {
        #   name  = "MYSQL_USER"
        #   value_from {
        #     secret_key_ref {
        #       name = data.google_secret_manager_secret.mysql-user-graytiger.secret_id
        #       key  = "latest"
        #     }
        #   }
        # }   
        env {
          name  = "MYSQL_PASSWORD"
          value = var.MYSQL_PASSWORD
          # value_from {
          #   secret_key_ref {
          #     name = data.google_secret_manager_secret.mysql-password-graytiger.secret_id
          #     key  = "latest"
          #   }
          # }
        }
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
  provider = google-personal
  location = google_cloud_run_service.graytiger-backend.location
  project  = google_cloud_run_service.graytiger-backend.project
  service  = google_cloud_run_service.graytiger-backend.name
  #  policy_data = data.google_iam_policy.noauth.policy_data
  role   = "roles/run.invoker"
  member = "allUsers"
}

# Return service URL
output "url" {
  value = google_cloud_run_service.graytiger-backend.status[0].url
}
