{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "43171376+drishans@users.noreply.github.com";
        name = "drishans";
      };
      credential."https://github.com".helper = "!gh auth git-credential";
      windows.appendAtomically = false;
    };
  };
}
