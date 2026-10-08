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
    # Free Super+V from the notification list (Super+M still opens it) for Copyous.
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>m" ];
    };
    "org/gnome/shell/extensions/copyous" = {
      open-clipboard-dialog-shortcut = [ "<Super>v" ];
    };
  };

  programs.gnome-shell = lib.mkIf (hostName == "dOmnix") {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.gjs-osk; }
      { package = pkgs.gnomeExtensions.copyous; }
    ];
  };

  programs.home-manager.enable = true;
}
