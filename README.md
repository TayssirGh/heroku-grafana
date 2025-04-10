# 📊 Déploiement de Grafana sur Heroku avec Docker et PostgreSQL

Ce projet nous permet de déployer **Grafana** sur **Heroku**, avec **PostgreSQL comme base de données** pour la persistance, le tout via **Docker**.

## 🚀 Étapes de déploiement

## 1. Cloner le projet

```bash
  git clone https://github.com/TayssirGh/heroku-grafana.git
  cd heroku-grafana
```

## 2. Lancer le script de déploiement
Le fichier `deploys.sh` contient toutes les instructions nécessaires pour :

 - Créer l’application Heroku

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

## 🐳 À propos du Dockerfile
J'ai posé la question l'autre fois : pourquoi ne pas simplement utiliser l'image officielle de Grafana ?

➡️ Heroku ne permet pas de déployer directement une image Docker publique. Il attend que nous fournissons
 un Dockerfile local, qu’il va ensuite construire et le faire pusher dans son propre registre.

Notre `Dockerfile` fait ceci :

- Part de l’image officielle grafana/grafana

- Ajoute un script start-grafana.sh qui adapte Grafana au port dynamique de Heroku `($PORT)`

- Configure Grafana pour démarrer proprement dans l’environnement Heroku

## 🗄️ À propos de `tables.sql`

Le fichier `tables.sql` contient deux tables :

- `users` : pour stocker des utilisateurs et leurs clés API
- `api_metrics` : pour enregistrer les appels d’API, leur statut, et les statistiques associées

Si vous avez besoin de créer manuellement ces tables dans la base en production, voici les commandes que j'ai préparées.


## 🧪 Pour tester manuellement le conteneur (en local) : 
vous aurez besoin d'utiliser cette commande pour :
* Faire le mapping entre le port 3000 du conteneur avec celui de votre machine.
* Créer un volume pour persister les données de  grafana une fois le conteneur s'arrête
* Créer un résaux surlequel connecte le conteneur
```bash
    docker run -d --name=grafana -p 3000:3000 --network monitoring_network -v grafana-storage:/var/lib/grafana grafana/grafana
```
### Remarque 💡 :
Ça sera un peu plus compliqué de tester grafana avec postgresql comme datasource car vous aurez besoin d'avoir 
un conteneur pour postgresql avec une configuration dans le même résau, et vous pouvez le faire avec cette commande : 
```bash
    docker run -d --name postgresql_with_grafana --network monitoring_network -e POSTGRES_DB=api_test -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin69 -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgis/postgis:16-3.4
```
Cette commande vous permet de faire tourner le conteneur avec une base de donnée test `api_test` sur le port `5432` 
(vous pouvez les changer si cela vous pose problème)

## 🔗 Références utiles :
* [Tutorial sur le déploiement grafana docker heroku ](https://hardnold.hashnode.dev/how-to-deploy-grafana-on-heroku-2024)
* [postgresql setup as grafana backend ](https://gist.github.com/sidward35/10d285223fe981573d755fe1c1338960)
* [heroku with docker](https://devcenter.heroku.com/articles/container-registry-and-runtime)
* [grafana with docker](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
* [persistent volume issue](https://stackoverflow.com/questions/45730213/recover-configuration-of-grafana-docker-persistent-volume)
