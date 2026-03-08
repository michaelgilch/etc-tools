#!/bin/bash
set -euo pipefail

install -Dm755 etckeeper-pre-pacman /usr/local/bin/etckeeper-pre-pacman
install -Dm755 pac /usr/local/bin/pac
install -Dm755 etc-show-custom /usr/local/bin/etc-show-custom
install -Dm755 pacnew-notify /usr/local/bin/pacnew-notify
install -Dm644 etckeeper-check.hook /etc/pacman.d/hooks/etckeeper-check.hook
install -Dm644 pacnew-notify.hook /etc/pacman.d/hooks/pacnew-notify.hook

echo "Installed:"
echo "  /usr/local/bin/etckeeper-pre-pacman"
echo "  /usr/local/bin/pac"
echo "  /usr/local/bin/etc-show-custom"
echo "  /usr/local/bin/pacnew-notify"
echo "  /etc/pacman.d/hooks/etckeeper-check.hook"
echo "  /etc/pacman.d/hooks/pacnew-notify.hook"
