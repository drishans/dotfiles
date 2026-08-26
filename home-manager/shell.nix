{
  hostName,
  isGui,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile = {
    "starship.toml".source = ../home/dot_config/starship.toml;
  }
  // lib.optionalAttrs isGui {
    "wezterm/wezterm.lua".source = ../home/dot_config/wezterm/wezterm.lua;
  };

  # GNOME 50 delegates "open a terminal" to xdg-terminal-exec, which is not
  # installed by default: org.gnome.desktop.default-applications.terminal is
  # already set to xdg-terminal-exec, so nothing answers it until this is on.
  xdg.terminal-exec = lib.mkIf (isGui && pkgs.stdenv.hostPlatform.isLinux) {
    enable = true;
    settings.default = [ "org.wezfurlong.wezterm.desktop" ];
  };

  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cat = "bat";
        ll = "eza -la";
        ls = "eza";
        nfu = "nix flake update ~/github/dotfiles";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        nrs = "sudo nixos-rebuild switch --flake ~/github/dotfiles#${hostName}";
        nrt = "sudo nixos-rebuild test --flake ~/github/dotfiles#${hostName}";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        drs = "sudo darwin-rebuild switch --flake ~/github/dotfiles#${hostName}";
      };
    };
  };
}
