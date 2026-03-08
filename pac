#!/bin/bash
#
# Wrapper to check for uncommitted /etc changes before running pacman/yay.
#
# Requires `etckeeper` installed and configured.
# Purpose is to allow manual commits with proper commit messages for manually
# changed /etc configs, to easily differentiate between auto-commits from
# etckeepers pre and post install commits.
#
# Usage:
#   pac                  — full upgrade (runs yay)
#   pac yay -S firefox   — run yay with args
#   pac pacman -Syu      — run pacman with args
#
# Recommended aliases:
#   alias pacman='pac pacman'
#   alias yay='pac yay'

set -euo pipefail

main() {
  # Default to yay (full upgrade) if no args given.
  if [[ $# -eq 0 ]]; then
    set -- yay
  fi

  # Skip check if etckeeper is not installed or /etc is not a git repo.
  if command -v etckeeper &>/dev/null \
      && sudo git -C /etc rev-parse --git-dir &>/dev/null; then
    if sudo etckeeper unclean; then
      echo "==> /etc has uncommitted changes:" >&2
      echo
      sudo git -C /etc status --short >&2
      echo

      local choice
      while true; do
        read -rp "==> (a)bort, (c)ontinue, (d)iff? " choice
        case "${choice}" in
          a|A)
            echo "Aborted. Commit your changes first:" >&2
            echo "  sudo etckeeper commit 'describe your changes'" >&2
            exit 1
            ;;
          c|C)
            echo "Continuing — etckeeper will auto-commit before install."
            break
            ;;
          d|D)
            local has_staged=false has_unstaged=false
            sudo git -C /etc diff --cached --quiet || has_staged=true
            sudo git -C /etc diff --quiet || has_unstaged=true

            if $has_staged; then
              echo "=== Staged changes ==="
              sudo git -C /etc diff --cached
              echo
            fi
            if $has_unstaged; then
              echo "=== Unstaged changes ==="
              sudo git -C /etc diff
              echo
            fi
            if ! $has_staged && ! $has_unstaged; then
              echo "(No diff — changes may be untracked files only.)" >&2
              echo
            fi
            if $has_staged && $has_unstaged; then
              echo "NOTE: You have both staged and unstaged changes." >&2
              echo "      To commit staged changes separately, choose (a)bort then:" >&2
              echo "        sudo git -C /etc commit -m 'your message'" >&2
              echo >&2
            fi
            ;;
          *)
            echo "Invalid choice." >&2
            ;;
        esac
      done
    fi
  fi

  exec "$@"
}

main "$@"
