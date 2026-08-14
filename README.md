# dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/).

This repository is private while the configuration set and bootstrap process are being established.

## Devices

- Windows 11 desktop
- HP OmniBook Ultra Flip running Nix
- Apple Silicon MacBook using nix-darwin
- GPD Win Mini running CachyOS
- ThinkPad running Debian

## Bootstrap

Install chezmoi using the native package manager for the target system. On Windows:

```powershell
winget install --id twpayne.chezmoi --exact
```

Initialize without applying changes:

```sh
chezmoi init https://github.com/drishans/dotfiles.git
chezmoi diff
chezmoi apply
```

Always review `chezmoi diff` before the first apply on a device.

## Daily workflow

```sh
chezmoi add ~/.config/example/config
chezmoi edit ~/.config/example/config
chezmoi diff
chezmoi apply
chezmoi cd
git status
```

## Phase 1 scope

Currently managed:

- Global Git identity and Windows Git behavior
- Shared `~/code/AGENTS.md` engineering instructions
- Windows Terminal settings on Windows hosts

## Security boundary

This repository contains configuration, not credentials or runtime state. Do not add:

- `.env` files, API keys, OAuth tokens, or SSH private keys
- Hermes `auth.json` or `.env`
- SQLite databases, sessions, logs, caches, or generated indexes

Secrets must remain in a secret manager or in local files outside chezmoi's source state.
