terraform {
  cloud {
    organization = "Ecom_Bluelion"

    workspaces {
      name = "Ecom_Bluelion"
    }
  }
}

provider "google" {
  project = "ceri-m1-ecommerce-2022"
  region  = "europe-west1"
}

resource "google_cloud_run_service" "cerythme_backend_service" {
  name         = "cerythme_backend_service"

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

  template {
    spec {
      containers {
        image = "https://europe-west1-docker.pkg.dev/ceri-m1-ecommerce-2022/graytiger/frontend:latest"
      }
    }
  }
}