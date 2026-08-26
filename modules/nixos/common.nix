{
  hostName,
  pkgs,
  username,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  time.timeZone = "America/Los_Angeles";
  networking.hostName = hostName;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video"];
    shell = pkgs.zsh;
  };

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
  };
}
