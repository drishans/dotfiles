{ ... }: {
  programs.git = {
    enable = true;

    # config/git/config stays a plain gitconfig so it can also be copied to
    # Windows by hand. Include it rather than restating the same settings here.
    includes = [ { path = ../config/git/config; } ];
  };
}
