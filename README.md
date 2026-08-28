# Cross-platform dotfiles

Configuration for Nix(OS/WSL/darwin) and Home Manager for my various computers.

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
├── home-manager/           # User environment
└── home/                   # Shared dotfiles and Chezmoi source
```

## NixOS

- [`dOmnix`](hosts/dOmnix/README.md): HP OmniBook Flip Ultra laptop
- [`dwslnix`](hosts/dwslnix/README.md): GPU model server under NixOS-WSL

From the repository root, test a host before switching it:

```sh
sudo nixos-rebuild test --flake .#<host>
sudo nixos-rebuild switch --flake .#<host>
```

## macOS

The [`macbook`](hosts/macbook/README.md) configuration targets Apple Silicon.

```sh
# First activation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#macbook

# Later activations
sudo darwin-rebuild switch --flake .#macbook
```

## Windows

Chezmoi deploys the shared dotfiles on native Windows:

```powershell
winget install --id twpayne.chezmoi --exact
chezmoi init https://github.com/drishans/dotfiles.git
chezmoi diff
chezmoi apply
```

## Maintenance

```sh
nix flake update
nix fmt
nix flake check
```

The formatter covers Nix, Lua, TOML, JSON, Markdown, and YAML. CI validates
NixOS and formatting on Linux and nix-darwin on macOS.
