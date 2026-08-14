# dotfiles

Cross-platform personal configuration managed with [chezmoi](https://www.chezmoi.io/).

> This repository is private while its bootstrap process and privacy boundaries are being established. It is designed to become public after a full history and metadata audit.

## Configuration

| Component | Source | Destination | Platforms |
| --- | --- | --- | --- |
| Git | [`home/dot_gitconfig`](home/dot_gitconfig) | `~/.gitconfig` | All |
| Agent instructions | [`home/code/AGENTS.md`](home/code/AGENTS.md) | `~/code/AGENTS.md` | All |
| Windows Terminal | [`settings.json`](home/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json) | Windows Terminal package state | Windows |

The repository root stays presentation-focused while [`home/`](home/) contains chezmoi's source state. Paths beneath `home/` intentionally mirror their real destinations. This preserves native `chezmoi diff`, drift detection, and `chezmoi re-add` behavior without custom copy scripts.

## Device fleet

| Device | Platform |
| --- | --- |
| RTX 5090 desktop | Windows 11 |
| HP OmniBook Ultra Flip | Nix |
| M1 MacBook | macOS with nix-darwin planned |
| GPD Win Mini | CachyOS |
| ThinkPad | Debian |

## Bootstrap

Install chezmoi with the target system's native package manager. On Windows:

```powershell
winget install --id twpayne.chezmoi --exact
```

Initialize without immediately changing the machine:

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

## Security and licensing

This repository contains configuration, not credentials or redistributable copies of licensed assets. It must not contain:

- `.env` files, API keys, OAuth tokens, or SSH private keys
- Hermes `auth.json`, `.env`, sessions, logs, or databases
- Application caches, generated indexes, or other mutable state
- Commercial font binaries, including PragmataPro

Licensed fonts are referenced by family name in configuration and installed separately from their authorized distribution. Secrets remain in a secret manager or in local files outside chezmoi's source state.
