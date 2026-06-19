# 🪐 StarRupture Dedicated Server - GNP Standard

## 📌 Description

Image Docker dédiée au serveur **StarRupture**, standardisée pour l’écosystème **GameNodePanel (GNP)**.

Le serveur dédié public est distribué via SteamCMD avec l’AppID `3809400`. Le dépôt serveur est actuellement **Windows uniquement**, donc cette image utilise **Wine + Xvfb**.

---

## 🚀 Features

- Installation / mise à jour via SteamCMD
- AppID serveur dédié expérimental : `3809400`
- Forçage du dépôt Windows SteamCMD
- Exécution via Wine + Xvfb
- Génération préventive de `DSSettings.txt`
- Variables GNP unifiées (`GNP_*`)
- Volumes persistants pour SteamCMD, fichiers serveur, configuration, saves, backups et Wine
- Logs filtrés pour éviter le spam Wine
- Compatible avec l’approche Docker de GameNodePanel

---

## ⚠️ Points importants StarRupture

StarRupture n’a pas de binaire Linux natif public au moment de cette image. SteamDB indique l’outil `StarRupture Dedicated Server (Experimental)`, AppID `3809400`, avec système supporté **Windows** et exécutable `StarRuptureServerEOS.exe`.

L’image tente de lancer en priorité :

```txt
StarRuptureServerEOS.exe
```

Puis fallback si besoin :

```txt
StarRuptureServer.exe
```

Le port officiel couramment documenté est :

```txt
7777/udp -> trafic jeu
```

Le serveur peut nécessiter une initialisation de session depuis le client du jeu via le menu de gestion serveur. Donc même si le process démarre, le monde/la session peut devoir être créée côté client au premier lancement.

---

## 📁 Structure GNP

```txt
/opt/steam             -> SteamCMD
/opt/games/server      -> Fichiers serveur StarRupture
/opt/games/config      -> DSSettings.txt et configuration persistante GNP
/opt/games/saves       -> Dossier réservé GNP pour exports/backups
/opt/games/backups     -> Backups éventuels côté GNP
/opt/wine              -> Wineprefix persistant
```

---

## ⚙️ Variables d’environnement GNP

```env
GNP_STEAM_APP_ID=3809400
GNP_SERVER_NAME=GNP_StarRupture_Server
GNP_SERVER_PASSWORD=
GNP_ADMIN_PASSWORD=changeme
GNP_IP_ADDRESS=0.0.0.0
GNP_GAME_PORT=7777
GNP_MAX_PLAYERS=4
GNP_AUTO_SAVE_INTERVAL=300
```

`GNP_MAX_PLAYERS=4` est volontairement conservateur. Plusieurs guides parlent de 4 joueurs comme valeur stable, même si certains exemples testent jusqu’à 8.

---

## 🧪 Build local

```bash
docker build -t slymer29/gnp-starrupture:latest .
```

## ▶️ Lancement avec Docker Compose

```bash
docker compose up -d
```

```bash
docker logs -f gnp-starrupture
```

## 📤 Push Docker Hub

```bash
docker login
docker build -t slymer29/gnp-starrupture:latest .
docker push slymer29/gnp-starrupture:latest
```

Tag versionné :

```bash
docker tag slymer29/gnp-starrupture:latest slymer29/gnp-starrupture:0.1.0-alpha
docker push slymer29/gnp-starrupture:0.1.0-alpha
```

---

## 🧩 Exemple d’intégration GNP

```env
game_runtime_type=docker
docker_image=slymer29/gnp-starrupture:latest
default_port=7777
query_port=NULL
max_players=4
```

---

## ✅ Résumé technique

```txt
Jeu        : StarRupture
Serveur    : Dedicated Server officiel Steam expérimental
AppID      : 3809400
OS serveur : Windows uniquement côté dépôt officiel
Runtime    : Wine + Xvfb
Port jeu   : 7777/udp
Config     : /opt/games/config/DSSettings.txt
```
