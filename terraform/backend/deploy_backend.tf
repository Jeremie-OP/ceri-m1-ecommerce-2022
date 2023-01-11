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

# using google_secret_manager_secret_version ressource for read only access
data "google_secret_manager_secret" "mysql-address" {
  secret_id = "mysql-address"
}
data "google_secret_manager_secret" "mysql-database-graytiger" {
  secret_id = "mysql-database-graytiger"
}
variable "mysql-password-graytiger" {
  default = ""
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
        image = "europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/backend:0.0.21"
        env {
          name  = "MYSQL_ADDRESS"
          value_from {
            secret_key_ref {
              name = data.google_secret_manager_secret.mysql-address.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name  = "MYSQL_DATABASE"
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
          value = var.mysql-password-graytiger
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
        "run.googleapis.com/cloudsql-instances" = "ceri-m1-ecommerce-2022:europe-west1:mysql-primary"      
        "seed"                           = "9"
      }
    }
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
  location    = google_cloud_run_service.graytiger-backend.location
  project     = google_cloud_run_service.graytiger-backend.project
  service     = google_cloud_run_service.graytiger-backend.name
#  policy_data = data.google_iam_policy.noauth.policy_data
  role        = "roles/run.invoker"
  member      = "allUsers"
}

# Return service URL
output "url" {
  value = "${google_cloud_run_service.graytiger-backend.status[0].url}"
}