{
  pkgs,
  username,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  fonts.packages = with pkgs; [
    iosevka
    nerd-fonts.symbols-only
  ];

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
