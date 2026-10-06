{
  hostName,
  lib,
  pkgs,
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    ./agents.nix
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./shell.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";
  };

  dconf.settings = lib.mkIf (hostName == "dOmnix") {
    "org/gnome/mutter" = {
      auto-maximize = false;
      center-new-windows = true;
    };
  };

  programs.gnome-shell = lib.mkIf (hostName == "dOmnix") {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.gjs-osk; }
    ];
  };

  programs.home-manager.enable = true;
}
