{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/dOmnix.nix
    ../../modules/nixos/gnome.nix
  ];

  home-manager.users.${username}.imports = [ ../../home-manager/gnome.nix ];

  networking = {
    networkmanager.enable = true;
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  programs = {
    codexDesktopLinux.enable = true;
    firefox.enable = true;
    mosh.enable = true;
    steam.enable = true;
    # Let Handy type on GNOME Wayland without the remote-interaction portal.
    ydotool.enable = true;
  };

  users.users.${username}.extraGroups = [
    "input"
    "ydotool"
  ];

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660"
  '';

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  # waydroid-helper installs ARM translation; its root mount daemon is D-Bus activated.
  systemd.packages = [ pkgs.waydroid-helper ];
  services.dbus.packages = [ pkgs.waydroid-helper ];

  services = {
    fwupd.enable = true;
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
    btop
    chatterino7
    dust
    fastfetch
    gcc
    ghostty
    gnumake
    handy
    killall
    lsof
    ncdu
    nodejs
    obs-studio
    pciutils
    powertop
    python3
    rustup
    inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
    tree
    transmission_4-gtk
    usbutils
    vesktop
    vlc
    waydroid-helper
    wezterm
    wget
  ];

  system.stateVersion = "26.05";
}
