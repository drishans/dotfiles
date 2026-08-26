{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/dOmnix.nix
    ../../modules/nixos/gnome.nix
  ];

  networking = {
    hostName = "dOmnix";
    networkmanager.enable = true;
    firewall.trustedInterfaces = ["tailscale0"];
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  swapDevices = [{device = "/swap/swapfile";}];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  programs = {
    codexDesktopLinux.enable = true;
    firefox.enable = true;
    mosh.enable = true;
  };

  services = {
    tailscale.enable = true;
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    alejandra
    bat
    btop
    chatterino7
    dust
    fastfetch
    fd
    fzf
    gcc
    ghostty
    git
    gnumake
    jq
    killall
    lsof
    ncdu
    nil
    nodejs
    obs-studio
    pciutils
    powertop
    python3
    rbw
    ripgrep
    rustup
    starship
    tmux
    tree
    usbutils
    vesktop
    vim
    vlc
    wezterm
    wget
  ];

  system.stateVersion = "26.05";
}
