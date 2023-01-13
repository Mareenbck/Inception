# Inception

🧠 [NOTION DU PROJET](https://elated-porpoise-8e6.notion.site/INCEPTION-7e93238133f14d189f9b46d18731975a)

> 📚 Virtualiser plusieurs images Docker en les créant dans votre nouvelle machine virtuelle personnelle.

### Mise en place : 
* Container Docker contenant NGINX avec TLSv1.2 ou TLSv1.3
* Container Docker contenant WordPress + php-fpm 
* Container Docker contenant MariaDB
* Volume contenant la base de données WordPress
* Volume contenant les fichiers du site WordPress
* Un docker-network qui fera le lien entre les containers

![Schéma](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbHh0Ey%2Fbtq7s6ma5MS%2FnCyxnIw4HjSpkesFRVBRsk%2Fimg.png)

Le projet consiste à relier plusieurs image **Docker**, et pouvoir les lancer ensemble, sans pour autant, qu’elles perdent leur indépendance. 

▶️ Utilisation de **Docker-Compose**

### To Do
* Configurer le nom de domaine afin qu'il pointe vers mbascuna.42.fr
* Utiliser les variables d'environnement, mise en place d'un fichier .env


