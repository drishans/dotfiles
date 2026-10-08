{
  hostName,
  isGui,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile = {
    "starship.toml".source = ../config/starship.toml;
  }
  // lib.optionalAttrs isGui {
    "wezterm/wezterm.lua".source = ../config/wezterm/wezterm.lua;
  };

  # GNOME 50 delegates "open a terminal" to xdg-terminal-exec, which is not
  # installed by default: org.gnome.desktop.default-applications.terminal is
  # already set to xdg-terminal-exec, so nothing answers it until this is on.
  xdg.terminal-exec = lib.mkIf (isGui && pkgs.stdenv.hostPlatform.isLinux) {
    enable = true;
    settings.default = [ "org.wezfurlong.wezterm.desktop" ];
  };

  # Shadow the packaged entry so each launcher window gets its own process.
  # Windows handed to an already running WezTerm by `wezterm start` slow down
  # its other windows while they run a busy TUI such as btop.
  xdg.desktopEntries."org.wezfurlong.wezterm" = lib.mkIf (isGui && pkgs.stdenv.hostPlatform.isLinux) {
    name = "WezTerm";
    comment = "Wez's Terminal Emulator";
    icon = "org.wezfurlong.wezterm";
    exec = "wezterm start --always-new-process --cwd .";
    terminal = false;
    categories = [
      "System"
      "TerminalEmulator"
      "Utility"
    ];
    settings = {
      Keywords = "shell;prompt;command;commandline;cmd;";
      StartupWMClass = "org.wezfurlong.wezterm";
      TryExec = "wezterm";
    };
  };

  programs = {
    # Per-project toolchains: a flake devShell plus `use flake` in .envrc.
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    # Also defines ls, la, lt, and lla; ll below overrides its default.
    eza.enable = true;
    # Ctrl-R history, Ctrl-T file, and Alt-C directory search.
    fzf.enable = true;
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
        nfu = "nix flake update --flake ~/github/dotfiles";
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
