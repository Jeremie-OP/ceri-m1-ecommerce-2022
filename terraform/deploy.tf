provider "google" {
  version = "3.0.0"
}

resource "google_container_registry" "my_registry" {
  name = "my-registry"
}

resource "google_cloud_run_service" "my_backend_service" {
  name         = "my-backend-service"
  location     = "europe-west1"
  traffic_type = "REVISION"

  template {
    spec {
      containers {
        image = "${google_container_registry.my_registry.proxy_url}/my-backend-image:latest"
      }
    }
  }
}

resource "google_cloud_run_service" "my_frontend_service" {
  name         = "my-frontend-service"
  location     = "europe-west1"
  traffic_type = "REVISION"

  template {
    spec {
      containers {
        image = "${google_container_registry.my_registry.proxy_url}/my-frontend-image:latest"
      }
    }
  }
}