#!/bin/bash
set -e
CONFIG_DIR="/opt/games/config"
SERVER_DIR="/opt/games/server"
mkdir -p "$CONFIG_DIR" /opt/games/saves
CFG_FILE="$CONFIG_DIR/DSSettings.txt"
cat > "$CFG_FILE" <<EOF
ServerName=${GNP_SERVER_NAME:-GNP_StarRupture_Server}
MaxPlayers=${GNP_MAX_PLAYERS:-4}
ServerPassword=${GNP_SERVER_PASSWORD:-}
AdminPassword=${GNP_ADMIN_PASSWORD:-changeme}
AutoSaveInterval=${GNP_AUTO_SAVE_INTERVAL:-300}
Port=${GNP_GAME_PORT:-7777}
EOF
# Copie préventive vers le chemin Unreal WindowsServer si le dossier existe ou pour l'initialiser.
mkdir -p "$SERVER_DIR/StarRupture/Saved/Config/WindowsServer" 2>/dev/null || true
cp -f "$CFG_FILE" "$SERVER_DIR/StarRupture/Saved/Config/WindowsServer/DSSettings.txt" 2>/dev/null || true
echo "✅ Configuration générée : ${CFG_FILE}"
