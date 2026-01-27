# 🏗️ Couche Infrastructure - Application & Compute

Ce dossier contient la définition technique des ressources applicatives déployées sur Google Cloud Platform.

## Rôle
Il déploie l'environnement d'exécution pour le serveur web Nginx via Docker.

## Architecture
- **Backend GCS** : Utilise le bucket créé dans la phase `01-bootstrap` pour stocker son état.
- **Instance VM** : Une machine `f1-micro` (Free Tier) exécutant Debian 11.
- **Firewall** : Ouverture du port 80 pour autoriser le trafic HTTP entrant.

## Automation (Startup Script)
Au démarrage, la VM exécute automatiquement les actions suivantes :
1. Installation du moteur **Docker**.
2. Téléchargement et lancement de l'image **Nginx Hello-World**.

## Déploiement
Toute modification dans ce dossier déclenche automatiquement le pipeline **GitHub Actions**.
