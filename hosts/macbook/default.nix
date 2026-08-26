{
  pkgs,
  username,
  ...
}: {
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system = {
    primaryUser = username;
    stateVersion = 6;
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
