provider "google" {
}

resource "google_cloud_run_service" "cerythme_backend_service" {
  name         = "cerythme_backend_service"
  location     = "europe-west1"
  traffic_type = "REVISION"
  max_instances = 1

  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/backend:latest"
      }
    }
  }
}

resource "google_cloud_run_service" "cerythme_frontend_service" {
  name         = "cerythme_frontend_service"
  location     = "europe-west1"
  traffic_type = "REVISION"
  max_instances = 1

  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/frontend:latest"
      }
    }
  }
}