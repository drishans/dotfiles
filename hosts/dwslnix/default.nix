# NixOS-WSL host. Generic WSL settings live in modules/wsl/base.nix; this
# file is only what's specific to this machine.
{ ... }: {
  services.sglang-qwen.enable = true;

  # Set at first install. Never change it afterwards: it pins stateful
  # defaults (data formats, paths) to the release this host started on.
  system.stateVersion = "26.05";
}
