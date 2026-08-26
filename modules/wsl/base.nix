# Settings shared by every NixOS-WSL host, independent of what runs on it.
# Host-specific bits (stateVersion, per-machine services) stay in
# hosts/<name>/default.nix; anything generically useful to WSL goes here so
# a future second WSL box doesn't have to re-derive it.
{
  pkgs,
  username,
  ...
}:
{
  wsl = {
    enable = true;
    defaultUser = username;
  };

  # Large pulled images (SGLang et al.) make this worth keeping on.
  nix.settings.auto-optimise-store = true;

  users.users.${username}.extraGroups = [ "docker" ];

  # Join WSL as its own tailnet node, then use `tailscale serve` to proxy
  # localhost-only services without exposing them to the LAN.
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    docker-compose
    jq
  ];
}
