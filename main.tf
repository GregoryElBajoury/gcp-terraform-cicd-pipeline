terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "mon-projet-devops-485603"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "vm_gratuite" {
  name         = "instance-docker-gratuite"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Alloue une IP publique
    }
  }

  metadata_startup_script = <<-EOT
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
  EOT
}