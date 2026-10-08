{ pkgs, ... }: {
  home.packages = with pkgs; [
    bash-language-server
    bat
    black
    clang-tools
    fd
    ffmpeg
    gh
    jq
    lua-language-server
    nil
    nixfmt
    prettier
    pyright
    rbw
    ripgrep
    stylua
    typescript-language-server
    yt-dlp
  ];
}
