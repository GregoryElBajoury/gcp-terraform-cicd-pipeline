provider "google" {
  project = "mon-projet-devops-485603"
  region  = "us-central1"
}

resource "google_storage_bucket" "tf_state_bucket" {
  name          = "tf-state-mon-projet-devops-greg-485603-unique"
  location      = "US-CENTRAL1"
  force_destroy = false # Empêche la suppression accidentelle de l'état
  storage_class = "STANDARD"

  versioning {
    enabled = true # Permet de récupérer un état corrompu
  }
}