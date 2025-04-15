# 📊 Déploiement de Grafana sur Heroku avec Docker et PostgreSQL

Ce projet nous permet de déployer **Grafana** sur **Heroku**, avec **PostgreSQL comme base de données** pour la persistance, le tout via **Docker**.

## 📌 Prérequis

Avant de commencer, assurez-vous d’avoir les éléments suivants installés et configurés sur votre machine :

- Docker (bien installé et fonctionnel)
  - 📚 [Tutoriel pour Linux](https://docs.docker.com/engine/install/)
  - 📚 [Tutoriel pour Windows](https://docs.docker.com/desktop/install/windows-install/)
- Git
- Un compte Heroku avec la [CLI Heroku](https://devcenter.heroku.com/articles/heroku-cli) installée
- Accès à une base de données PostgreSQL (Heroku Postgres recommandé)

---

## 🚀 Étapes de déploiement

## 1. Cloner le projet

```bash
  git clone https://github.com/TayssirGh/heroku-grafana.git
  cd heroku-grafana
```
## 2. Connexion à Heroku

```bash
  heroku login
```
Une fenêtre s'ouvrira dans votre navigateur pour vous connecter à votre compte Heroku.



## 3. Lancer le script de déploiement
Le fichier `deploys.sh` contient toutes les instructions nécessaires pour :

 - Créer l’application Heroku si elle n'existe pas

 - Choisir le stack convenant pour cette application

 - Configurer les variables d’environnement nécessaires

 - Construire l’image Docker de Grafana

 - Déployer et ouvrir Grafana automatiquement

```bash
  chmod +x deploys.sh
  ./deploys.sh
```
### Remarque 💡 :
le script peut ne pas fonctionner sur windows, Dans ce cas, 
vous pouvez exécuter manuellement les commandes contenues dans deploys.sh, en les adaptant à votre terminal ou Git Bash.
---
## 🐳 À propos du Docker et Heroku
Heroku propose un stack spécial appelé `container` qui permet de déployer des applications en utilisant directement 
une image Docker personnalisée.

Lorsque vous utilisez ce stack, **Heroku ne cherche plus à détecter automatiquement un langage (Node, Python, etc.)**, 
mais attend que vous lui fournissiez une **image Docker prête à l’emploi**, construite **localement** via votre propre `Dockerfile`.
### Étapes importantes :
#### 1. Définir le stack à container 
```bash
  heroku stack:set container
```
Cela indique à Heroku que vous souhaitez utiliser Docker comme mode de déploiement.
#### 2. Utilisation du Dockerfile local :
```bash
  heroku container:push web
```
Heroku utilise le `Dockerfile` présent à **la racine de notre projet** pour construire une image Docker **localement**,
puis il l’envoie à son registre privé (Heroku Container Registry).
#### 3. Déploiement de l’image :
```bash
  heroku container:release web
```
Cela indique à Heroku d'utiliser l’image que nous venons de pousser pour exécuter l'application.

⚠️ Heroku utilise automatiquement la variable d’environnement `$PORT` pour lier les applications web. C’est pourquoi le 
script start-grafana.sh configure Grafana pour utiliser ce port dynamiquement.

Notre `Dockerfile` fait ceci :


- Part de l’image officielle grafana/grafana

- Ajoute un script start-grafana.sh qui adapte Grafana au port dynamique de Heroku `($PORT)`

- Configure Grafana pour démarrer proprement dans l’environnement Heroku
---
## 🗃️ Backend PostgreSQL
On a configuré Grafana pour utiliser PostgreSQL pour stocker ses données (dashboards, utilisateurs, organisations, etc.). 
Lors de la première exécution, plusieurs tables sont automatiquement créées dans le schéma public de la base de données.

📄 Vous pouvez consulter la liste complète des tables créées dans le fichier **`grafana_tables.md`**, classées par ordre alphabétique.

---
## 🧪 Pour tester manuellement le conteneur (en local) : 
vous aurez besoin d'utiliser cette commande pour :
* Faire le mapping entre le port 3000 du conteneur avec celui de votre machine.
* Créer un volume pour persister les données de  grafana une fois le conteneur s'arrête
* Créer un résaux surlequel connecte le conteneur
```bash
    docker run -d --name=grafana -p 3000:3000 --network monitoring_network -v grafana-storage:/var/lib/grafana grafana/grafana
```
Vous allez y accéder sur `localhost:3000`
### Remarque 💡 :
Ça sera un peu plus compliqué de tester grafana avec postgresql comme datasource car vous aurez besoin d'avoir 
un conteneur pour postgresql avec une configuration dans le même résau, et vous pouvez le faire avec cette commande : 
```bash
    docker run -d --name postgresql_with_grafana --network monitoring_network -e POSTGRES_DB=api_test -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgis/postgis:16-3.4
```
Cette commande vous permet de faire tourner le conteneur avec une base de donnée test `api_test` sur le port `5432`, 
le user est `postgres` et le password est `admin`
(vous pouvez les changer si cela vous pose problème) 

Vous l'ajoutez aprés comme datasource sur Grafana et tout vas marcher bien ! 

___
## 🔗 Références utiles :
* [Tutorial sur le déploiement grafana docker heroku ](https://hardnold.hashnode.dev/how-to-deploy-grafana-on-heroku-2024)
* [postgresql setup as grafana backend ](https://gist.github.com/sidward35/10d285223fe981573d755fe1c1338960)
* [heroku with docker](https://devcenter.heroku.com/articles/container-registry-and-runtime)
* [grafana with docker](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
* [persistent volume issue](https://stackoverflow.com/questions/45730213/recover-configuration-of-grafana-docker-persistent-volume)
