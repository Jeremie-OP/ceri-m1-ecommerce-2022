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
  provider = google
  secret = mysql-address
}
data "google_secret_manager_secret_version" "mysql-user" {
  provider = google
  secret = mysql-user
}
data "google_secret_manager_secret_version" "mysql-password" {
  provider = google
  secret = mysql-password
}
data "google_secret_manager_secret_version" "mysql-database" {
  provider = google
  secret = mysql-database
}

output "mysql-address" {
  value = data.google_secret_manager_secret_version.mysql-address
}
output "mysql-user" {
  value = data.google_secret_manager_secret_version.mysql-user
}
output "mysql-password" {
  value = data.google_secret_manager_secret_version.mysql-password
}
output "mysql-database" {
  value = data.google_secret_manager_secret_version.mysql-database
}

variable "gcp-creds" {
  default=""
}
variable "MYSQL_ADDRESS" {
  default = output.mysql-address.value
}
variable "MYSQL_DATABASE" {
  default= output.mysql-database.value
}
variable "MYSQL_USER" {
  default= output.mysql-user.value
}
variable "MYSQL_PASSWORD" {
  default= output.mysql-password.value
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
          value = var.MYSQL_ADDRESS
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
