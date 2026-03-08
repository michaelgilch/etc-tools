# etc-tools

A collection of scripts and pacman hooks for managing `/etc` on Arch Linux with [etckeeper](https://etckeeper.branchable.com/).

While etckeeper is great at tracking changes in `/etc`, I needed a way to identify changes I made explicitly vs those made by configuration updates pushed via the package manager. The goal of this collection of scripts is to ease that use case.

## Tools

### `pac`

A wrapper around `yay`/`pacman` that checks for uncommitted `/etc` changes before running a package operation. If there are uncommitted changes, it prompts you to abort (so you can commit with a meaningful message), continue (letting etckeeper auto-commit), or view the diff.

```
pac                  # full upgrade (runs yay)
pac yay -S firefox   # run yay with args
pac pacman -Syu      # run pacman with args
```

Recommended aliases:

```bash
alias pacman='pac pacman'
alias yay='pac yay'
```

### `etc-show-custom`

Lists files that were manually modified in `/etc` by scanning the etckeeper git history and filtering out auto-generated commits (pre/post pacman runs, daily autocommits, initial commit). What remains are your intentional config changes.

```
sudo etc-show-custom
```

### `etckeeper-pre-pacman`

Script run by the `etckeeper-check.hook` pacman hook before every transaction. Warns if `/etc` has uncommitted changes and prompts to abort or continue. Unlike `pac`, this runs as root directly via pacman's hook system (no sudo needed).

### `pacnew-notify`

Script run by `pacnew-notify.hook` after every pacman transaction. Detects any `.pacnew`, `.pacsave`, or `.pacorg` files and prompts you to either continue (letting etckeeper auto-commit) or abort so you can merge the files and commit manually with a descriptive message.

## Pacman Hooks

| Hook file | Trigger | When | Action |
|---|---|---|---|
| `etckeeper-check.hook` | Any package operation | PreTransaction | Warns about uncommitted `/etc` changes |
| `pacnew-notify.hook` | Any package operation | PostTransaction | Alerts about `.pacnew`/`.pacsave` files |

Both hooks use `AbortOnFail`, so choosing to abort actually stops the transaction (or subsequent hooks like `zz-etckeeper.hook`).

## Installation

Run as root from the repo directory:

```bash
sudo ./install.sh
```

This installs:

- `/usr/local/bin/etckeeper-pre-pacman`
- `/usr/local/bin/pac`
- `/usr/local/bin/etc-show-custom`
- `/usr/local/bin/pacnew-notify`
- `/etc/pacman.d/hooks/etckeeper-check.hook`
- `/etc/pacman.d/hooks/pacnew-notify.hook`

## Requirements

- Arch Linux with pacman
- [etckeeper](https://archlinux.org/packages/extra/any/etckeeper/) installed and initialized (`sudo etckeeper init`)
- `yay` (optional, used as default by `pac`)
