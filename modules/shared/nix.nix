{ ... }: {
  nixpkgs.config.allowUnfree = true;

  # Nothing prunes generations otherwise: configurationLimit only bounds the
  # boot menu, not the store. Scheduling is left to the per-platform defaults
  # (nix.gc.dates on NixOS, nix.gc.interval on nix-darwin).
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
}
