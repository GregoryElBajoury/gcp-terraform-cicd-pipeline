![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![GCP](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

# 🚀 Projet CI/CD Terraform & Google Cloud

Ce projet implémente une infrastructure automatisée et sécurisée sur Google Cloud Platform (GCP) en utilisant **Terraform** pour l'Infrastructure as Code (IaC) et **GitHub Actions** pour le déploiement continu.

## 🏗️ Architecture du Projet

Le projet adopte une approche modulaire en deux étapes pour garantir la persistence et la sécurité des données d'infrastructure.

### 📂 Structure des fichiers
* **`01-bootstrap/`** : Initialisation du stockage distant (Bucket GCS) pour l'état Terraform.
* **`02-infrastructure/`** : Définition des ressources Cloud (VM Compute Engine, Firewall, Docker).
* **`.github/workflows/`** : Pipeline d'automatisation CI/CD avec validation par artefact.

---

## 🛠️ Stack Technique
* **Cloud** : Google Cloud Platform (GCP).
* **IaC** : Terraform (Backend distant sur GCS).
* **CI/CD** : GitHub Actions.
* **Conteneurisation** : Docker (Nginx Hello-World).

---

## 🚀 Fonctionnement du Pipeline CI/CD

Le déploiement suit un cycle de sécurité rigoureux :
1.  **Phase d'Inspection (Plan)** : À chaque `git push`, Terraform calcule les changements nécessaires et génère un fichier `tfplan`.
2.  **Phase de Déploiement (Apply)** : Le déploiement réel ne se déclenche que par une **action manuelle** sur GitHub, après vérification du plan.

Le pipeline est optimisé pour la sécurité et le coût :
* **Déclenchement** : Uniquement sur la branche `master`.
* **Filtres** : Ignore les changements de documentation (`paths-ignore: '**.md'`).
* **Sécurité (Manual Gate)** : Le job `terraform apply` nécessite une validation manuelle.
* **Artefacts** : Le fichier `tfplan` est sauvegardé entre les jobs pour garantir que ce qui est inspecté est exactement ce qui est déployé.
---

## 📖 Guide de démarrage

### 1. Pré-requis
* Un compte GCP avec un projet actif.
* Un compte de service avec les droits `Éditeur` et sa clé JSON configurée dans les secrets GitHub (`GCP_SA_KEY`).

### 2. Initialisation du State (Bootstrap)
```bash
cd 01-bootstrap
terraform init
terraform apply
```

Cette étape crée le bucket unique pour stocker le fichier .tfstate.

### 3. Déploiement de l'Infrastructure

Il suffit de pousser le code vers la branche `master`. Le pipeline s'occupe de l'installation de Docker et du lancement de l'application Nginx sur le port 80.

### 3. Déploiement de l'Infrastructure

Une fois le déploiement terminé, l'application est accessible via l'IP publique de la VM :

`http://<IP_PUBLIQUE_VM>`

## 🔐 Sécurité et Maintenance

- Secrets : Aucune clé JSON n'est stockée dans le dépôt grâce au .gitignore et aux GitHub Secrets.

- Nettoyage : Pour éviter les coûts inutiles, utiliser terraform destroy dans le dossier 02-infrastructure pour supprimer la VM tout en gardant le bucket de state intact.

- Mise en pause : Le compte de service peut être désactivé dans la console GCP pour neutraliser les accès sans supprimer la configuration.


Gregory EL BAJOURY
DevOps Engineer


