# Cross-platform dotfiles

This repository is the source of truth for Drishan's NixOS, NixOS-WSL,
nix-darwin, Home Manager, and native Windows configuration.

## Ownership

- NixOS and nix-darwin manage operating-system configuration.
- Home Manager manages user packages, Zsh, and Unix dotfiles.
- Chezmoi deploys the same source files on native Windows only.

Home Manager references files under `home/`, which is also Chezmoi's source
root. Shared application configuration therefore has one source without two
tools trying to own the same target on Unix.

Neovim is managed by Home Manager with plugins and language tools supplied by
the pinned Nix packages. Its Lua configuration lives under
`home/dot_config/nvim/`. Git remains installed for repository operations,
while `gh` adds GitHub authentication, pull requests, issues, releases, and
API access. Home Manager configures Git to use the authenticated GitHub CLI as
its HTTPS credential helper. Global agent instructions live under
`home/dot_codex/AGENTS.md`; Home Manager shares them with Codex and Claude,
while Chezmoi deploys them to Codex on Windows.

WezTerm selects Iosevka as its primary font and Symbols Nerd Font Mono as a
glyph fallback. Neovim and Starship inherit the terminal font.

## Layout

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   ├── dOmnix/
│   ├── dwslnix/
│   └── macbook/
├── modules/
│   ├── hardware/
│   ├── nixos/
│   └── wsl/
├── home-manager/           # Modular user environment
└── home/                   # Chezmoi source and shared config data
```

## NixOS laptop

Preview the new generation before switching:

```sh
sudo nixos-rebuild test --flake ~/github/dotfiles#dOmnix
```

Activate it after verifying GNOME, networking, audio, fingerprint support, and
screen rotation:

```sh
sudo nixos-rebuild switch --flake ~/github/dotfiles#dOmnix
```

The host preserves the current GNOME/GDM configuration, hardware configuration,
sensor firmware, services, packages, swap, and state version. Home Manager adds
the shared Zsh environment and user-scoped agent tools. Iosevka and the Nerd
Font symbols fallback are installed for terminal applications.

## NixOS-WSL

Clone this repository inside the NixOS distribution, then run:

```sh
sudo nixos-rebuild test --flake ~/github/dotfiles#dwslnix
sudo nixos-rebuild switch --flake ~/github/dotfiles#dwslnix
```

The WSL configuration retains Docker, NVIDIA CDI support, Tailscale, and the
SGLang Qwen service. Agent packages are intentionally omitted from this
model-serving host, while the portable agent configuration remains synchronized
with the other machines.

## macOS

The Mac scaffold assumes Apple Silicon. It can coexist with a Brew-first setup:
nix-darwin owns system defaults and Home Manager dotfiles, while Brew can keep
managing existing native applications and agent installations. On the MacBook:

```sh
sudo nix run nix-darwin/master#darwin-rebuild -- \
  switch --flake ~/github/dotfiles#macbook
```

After the first activation:

```sh
sudo darwin-rebuild switch --flake ~/github/dotfiles#macbook
```

Confirm the Mac's local username, home directory, architecture, and hostname
before the first activation.

## Windows with Chezmoi

Chezmoi is intentionally retained for native Windows, where Home Manager does
not apply.

```powershell
winget install --id twpayne.chezmoi --exact
chezmoi init https://github.com/drishans/dotfiles.git
chezmoi diff
chezmoi apply
```

The `.chezmoiignore` policy prevents Chezmoi from managing Unix targets.

## Updating and validation

```sh
nix flake update
nix fmt
nix flake check
```

The formatter covers Nix, Lua, TOML, JSON, Markdown, and YAML. GitHub Actions
runs formatting and configuration checks on Linux and evaluates the macOS
configuration on a native runner.

Useful shell aliases after Home Manager activation:

- `nfu` updates the lockfile.
- `nrt` tests the current NixOS host.
- `nrs` switches the current NixOS host.
- `drs` switches the nix-darwin host.

Review changes before committing. Chezmoi does not automatically commit or push
Windows changes, so Git history remains explicit on every platform.
