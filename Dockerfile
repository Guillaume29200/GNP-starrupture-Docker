FROM debian:12
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl wget tar xz-utils unzip jq procps gosu locales tzdata python3 \
        xvfb cabextract winbind p7zip-full \
        wine wine32 wine64 \
        lib32gcc-s1 lib32stdc++6 libstdc++6:i386 libgcc-s1:i386 && \
    rm -rf /var/lib/apt/lists/*
RUN curl -L --fail -o /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x /usr/local/bin/winetricks
RUN mkdir -p /opt/steam /opt/games/server /opt/games/config /opt/games/saves /opt/games/backups /opt/wine && \
    groupadd -g 1000 gnp && useradd -m -u 1000 -g 1000 -s /bin/bash gnp && \
    chown -R gnp:gnp /opt/steam /opt/games /opt/wine /home/gnp
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh
ENV GNP_TZ=Europe/Paris GNP_PUID=1000 GNP_PGID=1000
ENV GNP_STEAM_APP_ID=3809400 GNP_STEAM_USER=anonymous GNP_STEAM_PASSWORD= GNP_STEAM_AUTH= GNP_STEAM_BETA= GNP_STEAM_BETA_PASSWORD= GNP_GAME_UPDATE=true GNP_FORCE_PLATFORM_WINDOWS=true
ENV WINEPREFIX=/opt/wine WINEDEBUG=-all WINEDLLOVERRIDES=mscoree,mshtml= GNP_WINETRICKS_RUN="vcrun2022 dxvk sound=disabled" DISPLAY=:99
ENV GNP_SERVER_NAME=GNP_StarRupture_Server GNP_SERVER_PASSWORD= GNP_ADMIN_PASSWORD=changeme GNP_IP_ADDRESS=0.0.0.0 GNP_GAME_PORT=7777 GNP_QUERY_PORT=27015 GNP_MAX_PLAYERS=4 GNP_AUTO_SAVE_INTERVAL=300
ENV GNP_VERBOSE_LOGGING=false GNP_FILTER_WINE_LOGS=true GNP_EXTRA_ARGS=
WORKDIR /opt/games/server
EXPOSE 7777/udp
EXPOSE 27015/udp

HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 CMD /scripts/healthcheck.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
