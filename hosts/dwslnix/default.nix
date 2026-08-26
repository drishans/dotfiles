# NixOS-WSL host. Generic WSL settings live in modules/wsl/base.nix; this
# file is only what's specific to this machine.
{ ... }: {
  # Set at first install. Never change after the fact - see modules/wsl/base.nix
  # and modules/nixos/common.nix for why this is a per-host override.
  system.stateVersion = "26.05";
}
