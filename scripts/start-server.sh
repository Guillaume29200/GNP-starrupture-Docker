#!/bin/bash
set -e
export HOME=/home/gnp
export WINEPREFIX="${WINEPREFIX:-/opt/wine}"
export DISPLAY="${DISPLAY:-:99}"
export WINEDEBUG="${WINEDEBUG:--all}"
SERVER_DIR="/opt/games/server"
EXTRA_ARGS="${GNP_EXTRA_ARGS:-}"
VERBOSE="${GNP_VERBOSE_LOGGING:-false}"
FILTER_LOGS="${GNP_FILTER_WINE_LOGS:-true}"
cd "$SERVER_DIR"
EXE=""
if [ -f "StarRuptureServerEOS.exe" ]; then
    EXE="StarRuptureServerEOS.exe"
elif [ -f "StarRuptureServer.exe" ]; then
    EXE="StarRuptureServer.exe"
else
    echo "❌ Exécutable StarRupture introuvable dans ${SERVER_DIR}"
    find "$SERVER_DIR" -maxdepth 3 -iname '*.exe' -print || true
    exit 1
fi
ARGS=("$EXE" -Log "-ServerName=${GNP_SERVER_NAME:-GNP_StarRupture_Server}" "-MaxPlayers=${GNP_MAX_PLAYERS:-4}" "-Port=${GNP_GAME_PORT:-7777}" "-QueryPort=${GNP_QUERY_PORT:-27015}")
if [ -n "${GNP_SERVER_PASSWORD:-}" ]; then ARGS+=("-ServerPassword=${GNP_SERVER_PASSWORD}"); fi
if [ -n "${GNP_ADMIN_PASSWORD:-}" ]; then ARGS+=("-AdminPassword=${GNP_ADMIN_PASSWORD}"); fi
if [ -n "${GNP_IP_ADDRESS:-}" ] && [ "${GNP_IP_ADDRESS}" != "0.0.0.0" ]; then ARGS+=("-MultiHome=${GNP_IP_ADDRESS}"); fi
if [ "$VERBOSE" = "true" ]; then ARGS+=( -Verbose ); fi
if [ -n "$EXTRA_ARGS" ]; then
    # shellcheck disable=SC2206
    EXTRA_ARRAY=( $EXTRA_ARGS )
    ARGS+=( "${EXTRA_ARRAY[@]}" )
fi
echo "🚀 Lancement StarRupture Dedicated Server..."
echo "📄 Exe    : ${EXE}"
echo "🌐 Port   : ${GNP_GAME_PORT:-7777}/udp"
echo "📄 Config : /opt/games/config/DSSettings.txt"
touch /opt/games/config/server.log
if [ "$FILTER_LOGS" = "true" ]; then
    exec wine64 "${ARGS[@]}" 2>&1 | grep -vE "fixme:|winediag:|0024:fixme|warning:|WARNING: Shader|Shader .* not supported" | tee -a /opt/games/config/server.log
else
    exec wine64 "${ARGS[@]}" 2>&1 | tee -a /opt/games/config/server.log
fi
