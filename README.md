# Cross-platform dotfiles

Configuration for Nix(OS/WSL/darwin) and Home Manager for my various computers.

## Layout

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   ├── dOmnix/             # OmniBook Ultra Flip
│   ├── dwslnix/            # 5090 PC running WSL
│   └── macbook/            # M1 Max MacBook Pro
├── modules/
│   ├── hardware/
│   ├── nixos/
│   └── wsl/
├── home-manager/           # User environment
└── config/                 # App configs linked by Home Manager
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

Native Windows is not managed automatically. Copy
[`config/windows-terminal/settings.json`](config/windows-terminal/settings.json)
to
`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.
`config/git/config` and `config/wezterm/wezterm.lua` also work on Windows.

## Maintenance

```sh
nix flake update
nix fmt
nix flake check
```

The formatter covers Nix, Lua, TOML, JSON, Markdown, and YAML. CI validates
NixOS and formatting on Linux and nix-darwin on macOS.
