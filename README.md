# dotfiles

Cross-platform workstation configuration managed with [chezmoi](https://www.chezmoi.io/). The repository favors direct target mapping, auditable changes, and minimal bootstrap logic over custom deployment machinery.

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
