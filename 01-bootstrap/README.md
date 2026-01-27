# 🛠️ Couche Bootstrap - Backend Terraform

Ce dossier contient la configuration initiale nécessaire pour héberger l'état (state) de l'infrastructure de manière persistante et sécurisée.

## Rôle
Il crée un bucket **Google Cloud Storage (GCS)** qui servira de backend distant pour tous les autres déploiements Terraform du projet.

## Utilisation (Manuelle)
Cette étape doit être effectuée **une seule fois** depuis un terminal local avant de pouvoir utiliser le pipeline CI/CD.

1. Authentifiez-vous localement à GCP.
2. Initialisez Terraform : `terraform init`.
3. Appliquez la configuration : `terraform apply`.

## Ressources créées
- **Bucket GCS** : Stockage du fichier `terraform.tfstate`.
- **Versioning** : Activé pour permettre la récupération d'anciennes versions de l'infrastructure en cas d'erreur.
