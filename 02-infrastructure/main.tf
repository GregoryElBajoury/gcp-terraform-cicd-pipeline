# ==========================================================================
# CONFIGURATION DU BACKEND TERRAFORM
# Utilisation de Google Cloud Storage (GCS) pour la persistence du State
# ==========================================================================
terraform {
  backend "gcs" {
    bucket = "tf-state-mon-projet-devops-greg-485603-unique"
    prefix = "terraform/state"
  }
}

# ==========================================================================
# CONFIGURATION DU PROVIDER
# Définition du projet cible et de la région par défaut
# ==========================================================================
provider "google" {
  project = "mon-projet-devops-485603"
  region  = "us-central1"
}

# ==========================================================================
# RESSOURCES RÉSEAU : PARE-FEU
# Autorisation du trafic entrant sur le port 80 (HTTP)
# ==========================================================================
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Ouverture à toutes les adresses IP (Public)
  source_ranges = ["0.0.0.0/0"]
  # Cible uniquement les instances portant ce tag réseau
  target_tags = ["http-server"]
}

# ==========================================================================
# COMPUTE ENGINE : INSTANCE VM
# Déploiement d'une instance f1-micro avec automatisation Docker
# ==========================================================================
resource "google_compute_instance" "vm_gratuite" {
  name         = "instance-docker-gratuite"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  # Tags pour l'application des règles de pare-feu
  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

# --- AJOUT DU BLOC RÉSEAU OBLIGATOIRE ---
  network_interface {
    network = "default"
    access_config {
      # Nécessaire pour obtenir une IP publique
    }
  }


  # ========================================================================
  # SCRIPT DE POST-INSTALLATION (BOOTSTRAP)
  # Installation de Docker et déploiement du conteneur applicatif
  # ========================================================================
  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    # Exécution du conteneur Nginx Hello-World sur le port 80
    docker run -d -p 80:80 nginxdemos/hello
  EOT
}