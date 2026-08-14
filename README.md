# dotfiles

Cross-platform workstation configuration managed with [chezmoi](https://www.chezmoi.io/). The repository favors direct target mapping, auditable changes, and minimal bootstrap logic over custom deployment machinery.

## Bootstrap

Install chezmoi with the target system's native package manager. For example, on Windows:

```powershell
winget install --id twpayne.chezmoi --exact
```

On macOS:

```sh
brew install chezmoi
```

Initialize the repository, inspect the proposed changes, and apply them:

```sh
chezmoi init https://github.com/drishans/dotfiles.git
chezmoi diff
chezmoi apply
```

Review `chezmoi diff` before the first apply on any system.

Use `chezmoi init` rather than a manual clone for the active source directory. Chezmoi selects the appropriate platform-specific data location. A separate working clone, when desired for inspection or development, belongs in `~/code/dotfiles` on macOS or `C:\Users\drishan\code\dotfiles` on Windows.

## Development workflow

```sh
chezmoi update
chezmoi add ~/.config/example/config
chezmoi edit ~/.config/example/config
chezmoi diff
chezmoi apply
```

`chezmoi update` pulls the latest source state with an autostash/rebase and applies it. Run it before changing dotfiles on a machine that shares this repository.

## Source-state synchronization

The managed chezmoi configuration enables automatic commits and pushes for source-state changes made through chezmoi. This keeps routine `chezmoi add` and `chezmoi edit` operations synchronized with the repository.

Automatic synchronization does not replace review. Inspect `chezmoi diff` before applying changes, and use `chezmoi update` before starting work on another machine to avoid avoidable Git conflicts. Configure GitHub write authentication on each machine before making source-state changes.
