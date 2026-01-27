terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  # AJOUTE CE BLOC ICI
  backend "gcs" {
    bucket = "tf-state-mon-projet-devops-485603"
    prefix = "terraform/state"
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

# Création du Bucket pour le Terraform State
resource "google_storage_bucket" "tf_state_bucket" {
  name          = "tf-state-mon-projet-devops-485603" # Nom unique
  location      = "US"                                # Inclus dans le Free Tier (ou EU)
  force_destroy = false
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}