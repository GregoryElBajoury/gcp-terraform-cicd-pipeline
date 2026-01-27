# 1. Garde ton bloc terraform/backend en haut (ne change rien ici)
terraform {
  backend "gcs" {
    bucket  = "tf-state-mon-projet-devops-485603"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "ton-id-projet" # Remplace par ton ID réel
  region  = "us-central1"
}

# 2. Le pare-feu (à n'écrire qu'une seule fois)
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

# 3. L'instance (UNE SEULE FOIS)
resource "google_compute_instance" "vm_gratuite" {
  name         = "instance-docker-gratuite"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    docker run -d -p 80:80 nginxdemos/hello
  EOT
}