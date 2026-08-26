{
  hostName,
  pkgs,
  username,
  ...
}:
{
  time.timeZone = "America/Los_Angeles";
  networking.hostName = hostName;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
  };

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
  };
}
