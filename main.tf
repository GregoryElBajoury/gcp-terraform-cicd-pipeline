terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project     = "mon-projet-devops-485603" # À remplacer par l'ID de ton projet GCP
  region      = "us-central1"
  zone        = "us-central1-a"
}

resource "google_compute_instance" "vm_gratuite" {
  name         = "instance-docker-gratuite"
  machine_type = "e2-micro" # Inclus dans le Free Tier

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Donne une IP publique
    }
  }

  # Script pour installer Docker automatiquement au démarrage
  metadata_startup_script = <<-EOT
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
  EOT
}