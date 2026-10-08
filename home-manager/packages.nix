{ pkgs, ... }: {
  home.packages = with pkgs; [
    bash-language-server
    bat
    black
    clang-tools
    eza
    fd
    ffmpeg
    fzf
    gh
    lua-language-server
    nil
    nixfmt
    prettier
    pyright
    rbw
    ripgrep
    rust-analyzer
    rustfmt
    stylua
    typescript-language-server
    yt-dlp
    zoxide
  ];
}
