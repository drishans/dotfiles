{
  inputs,
  lib,
  pkgs,
  username,
  homeDirectory,
  hostName,
  isGui,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  llmAgents = inputs.llm-agents.packages.${system};
in {
  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";

    packages =
      [
        llmAgents.claude-code
        llmAgents.codex
        llmAgents.herdr
        llmAgents.pi
      ]
      ++ (with pkgs; [
        bash-language-server
        bat
        black
        clang-tools
        eza
        fd
        fzf
        git
        gh
        lua-language-server
        nil
        nixfmt
        prettier
        pyright
        ripgrep
        rust-analyzer
        rustfmt
        stylua
        typescript-language-server
        zoxide
      ]);

    file = {
      ".claude/settings.json".source = ../home/dot_claude/settings.json;
      ".gitconfig".source = ../home/dot_gitconfig;
      ".pi/agent/models.json".source = ../home/dot_pi/agent/models.json;
      ".pi/agent/settings.json".source = ../home/dot_pi/agent/settings.json;
    };
  };

  xdg.configFile =
    {
      "herdr/config.toml".source = ../home/dot_config/herdr/config.toml;
      "nvim".source = ../home/dot_config/nvim;
      "starship.toml".source = ../home/dot_config/starship.toml;
    }
    // lib.optionalAttrs isGui {
      "wezterm/wezterm.lua".source = ../home/dot_config/wezterm/wezterm.lua;
    };

  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (parsers:
          with parsers; [
            bash
            c
            cpp
            css
            glsl
            html
            javascript
            json
            lua
            markdown
            markdown_inline
            nix
            python
            rust
            toml
            tsx
            typescript
            vim
            vimdoc
            yaml
          ]))
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        nvim-lspconfig
        blink-cmp
        conform-nvim
        gitsigns-nvim
        which-key-nvim
        lualine-nvim
        oil-nvim
        gruvbox-nvim
      ];
    };
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
      shellAliases =
        {
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
