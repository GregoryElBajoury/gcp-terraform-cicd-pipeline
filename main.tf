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

# 1. On ouvre le port 80 dans le pare-feu
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# 2. On modifie ton instance existante
resource "google_compute_instance" "vm_gratuite" {
  name         = "instance-docker-gratuite"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  tags         = ["http-server"] # Indispensable pour l'ouverture du port

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Garde l'IP externe actuelle : 34.70.68.41
    }
  }

  # Script d'installation automatique
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    # Lance un petit conteneur de test pour prouver que ça marche
    docker run -d -p 80:80 nginxdemos/hello
  EOT
}