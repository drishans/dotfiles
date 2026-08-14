# dotfiles

Cross-platform workstation configuration managed with [chezmoi](https://www.chezmoi.io/). The repository favors direct target mapping, auditable changes, and minimal bootstrap logic over custom deployment machinery.

The configuration targets Windows, Linux, and macOS environments, including Nix-managed systems. It is intentionally opinionated and is best treated as a reference or starting point rather than a universal installer.

## Design

The repository uses [`.chezmoiroot`](https://www.chezmoi.io/reference/special-files/chezmoiroot/) to keep repository metadata separate from managed home-directory state:

```text
dotfiles/
├── .chezmoiroot
├── .gitattributes
├── .gitignore
├── README.md
└── home/                     # chezmoi source state
    ├── .claude/              # Claude configuration
    ├── .config/              # XDG application configuration
    ├── .pi/agent/            # Pi agent configuration
    ├── AGENTS.md             # Shared agent guidance
    ├── AppData/              # Windows application configuration
    └── dot_gitconfig         # Git configuration
```

Paths below [`home/`](home/) mirror their destinations below the user's home directory. Chezmoi applies its source-state attributes while preserving the remaining path:

```text
home/dot_gitconfig       -> ~/.gitconfig
home/AGENTS.md           -> ~/AGENTS.md
home/.claude/...         -> ~/.claude/...
home/.config/...         -> ~/.config/...
home/.pi/agent/...       -> ~/.pi/agent/...
home/AppData/...         -> ~/AppData/...
```

Most configuration is grouped under conventional home-directory namespaces. Deeper paths are retained only where an application requires a fixed destination. For example, Windows Terminal reads configuration from its package-state directory. Flattening that path would require copy scripts, reducing the usefulness of native `chezmoi diff`, drift detection, `add`, and `re-add` operations.

## Managed configuration

| Component | Source | Destination | Platforms |
| --- | --- | --- | --- |
| Git | [`home/dot_gitconfig`](home/dot_gitconfig) | `~/.gitconfig` | All |
| Agent instructions | [`home/AGENTS.md`](home/AGENTS.md) | `~/AGENTS.md` | All |
| Claude | [`home/.claude/`](home/.claude/) | `~/.claude/` | All |
| XDG configuration | [`home/.config/`](home/.config/) | `~/.config/` | Linux, macOS, supported Windows tools |
| Pi agent | [`home/.pi/agent/`](home/.pi/agent/) | `~/.pi/agent/` | All |
| Windows Terminal | [`settings.json`](home/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json) | Windows Terminal package state | Windows |

The namespace directories are committed with ignored placeholders until reviewed configuration is added. Placeholder files exist only in the Git source and are not deployed by chezmoi.

## Nix integration

Chezmoi and Home Manager solve different layers of workstation management. Chezmoi is the portability layer for files shared across Windows, Linux, and macOS. Home Manager remains the stronger option for Nix-native package installation, services, environment variables, and modules on NixOS or nix-darwin.

The recommended boundary is explicit ownership: Home Manager manages Nix-specific packages and system integration, while chezmoi manages portable application and agent configuration. A file should be owned by one system, never both.

## Bootstrap

Install chezmoi with the target system's native package manager. For example, on Windows:

```powershell
winget install --id twpayne.chezmoi --exact
```

Initialize the repository, inspect the proposed changes, and apply them:

```sh
chezmoi init https://github.com/drishans/dotfiles.git
chezmoi diff
chezmoi apply
```

Review `chezmoi diff` before the first apply on any system.

## Development workflow

```sh
chezmoi add ~/.config/example/config
chezmoi edit ~/.config/example/config
chezmoi diff
chezmoi apply
chezmoi cd
git status
```

## Security boundary

This repository contains declarative configuration only. It excludes:

- `.env` files, API keys, OAuth tokens, and SSH private keys
- Authentication state, sessions, logs, and databases
- Application caches, generated indexes, and other mutable state

Secrets belong in a dedicated secret manager or in local files outside chezmoi's source state.
