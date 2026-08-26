{ pkgs, ... }: {
  xdg.configFile."nvim".source = ../home/dot_config/nvim;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (
        parsers: with parsers; [
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
        ]
      ))
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
}
