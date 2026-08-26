{
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

  programs.home-manager.enable = true;
}
