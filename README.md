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
└── home/                 # chezmoi source state
```

Paths below [`home/`](home/) mirror their destinations below the user's home directory. Chezmoi applies its source-state attributes while preserving the remaining path:

```text
home/dot_gitconfig       -> ~/.gitconfig
home/code/AGENTS.md      -> ~/code/AGENTS.md
home/AppData/...         -> ~/AppData/...
```

The nested paths are deliberate. Windows Terminal reads configuration from a fixed package-state location, and the shared `AGENTS.md` is loaded from the working directory used for development. Flattening these files into app-named directories would require copy scripts, reducing the usefulness of native `chezmoi diff`, drift detection, `add`, and `re-add` operations.

## Managed configuration

| Component | Source | Destination | Platforms |
| --- | --- | --- | --- |
| Git | [`home/dot_gitconfig`](home/dot_gitconfig) | `~/.gitconfig` | All |
| Agent instructions | [`home/code/AGENTS.md`](home/code/AGENTS.md) | `~/code/AGENTS.md` | All |
| Windows Terminal | [`settings.json`](home/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json) | Windows Terminal package state | Windows |

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
