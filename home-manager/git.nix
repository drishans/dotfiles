{ ... }: {
  programs.git = {
    enable = true;

    # home/dot_gitconfig is the single source: Chezmoi cannot read Nix, so that
    # file has to exist for Windows regardless. Include it rather than restating
    # the same settings here.
    includes = [ { path = ../home/dot_gitconfig; } ];
  };
}
