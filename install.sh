#!/bin/bash
set -euo pipefail

# System installs (run as root)
install -Dm755 libexec/etckeeper-pre-pacman /usr/local/bin/etckeeper-pre-pacman
install -Dm755 libexec/pacnew-notify        /usr/local/bin/pacnew-notify
install -Dm644 hooks/etckeeper-check.hook   /etc/pacman.d/hooks/etckeeper-check.hook
install -Dm644 hooks/pacnew-notify.hook     /etc/pacman.d/hooks/pacnew-notify.hook

# User symlinks (create as the invoking user, not root)
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
LOCAL_BIN="$USER_HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
ln -sf "$REPO_DIR/bin/pac"              "$LOCAL_BIN/pac"
ln -sf "$REPO_DIR/bin/etc-show-custom"  "$LOCAL_BIN/etc-show-custom"
ln -sf "$REPO_DIR/bin/etc-backup-custom" "$LOCAL_BIN/etc-backup-custom"

echo "Installed:"
echo "  /usr/local/bin/etckeeper-pre-pacman"
echo "  /usr/local/bin/pacnew-notify"
echo "  /etc/pacman.d/hooks/etckeeper-check.hook"
echo "  /etc/pacman.d/hooks/pacnew-notify.hook"
echo "  $LOCAL_BIN/pac -> $REPO_DIR/bin/pac"
echo "  $LOCAL_BIN/etc-show-custom -> $REPO_DIR/bin/etc-show-custom"
echo "  $LOCAL_BIN/etc-backup-custom -> $REPO_DIR/bin/etc-backup-custom"
