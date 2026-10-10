{ pkgs, username, ... }:
let
  ishFirmware = pkgs.requireFile {
    name = "ishC_SI_20260309.bin";
    hash = "sha256-QEEZjN31pxIwYznefsQX1GNjM48SpbOpM67VVecvArk=";
    message = ''
      The Intel Integrated Sensor Hub firmware is machine-specific and is not
      redistributed with this public configuration.

      Copy ishC_SI_20260309.bin from the private backup, then add it to the Nix
      store before rebuilding:

        nix-store --add-fixed sha256 /path/to/ishC_SI_20260309.bin
    '';
  };
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "intel_ishtp_hid"
      "hid_sensor_hub"
    ];
  };

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true;
    firmware = [
      (pkgs.runCommand "hp-ish-firmware" { } ''
        mkdir -p $out/lib/firmware/intel/ish
        cp ${ishFirmware} \
          $out/lib/firmware/intel/ish/ish_lnlm_12128606.bin
      '')
    ];
  };

  services = {
    fprintd.enable = true;
    power-profiles-daemon.enable = true;
    thermald.enable = true;

    # Allow only this user to control the speaker-mute LED, including after a
    # sound-device replug. tmpfiles also covers devices present during a rebuild.
    #
    # Ignore the firmware tablet-mode switch, which also turns on when the
    # laptop is on its side and disables the keyboard (see QUIRKS.md).
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="leds", KERNEL=="hda::mute", RUN+="${pkgs.coreutils}/bin/chown ${username} /sys%p/brightness /sys%p/trigger"
      SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="Intel HID switches", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };

  systemd.tmpfiles.rules = [
    "z /sys/class/leds/hda::mute/brightness 0644 ${username} - -"
    "z /sys/class/leds/hda::mute/trigger 0644 ${username} - -"
  ];

  systemd.user.services.mute-led = {
    description = "Follow the default audio output's mute state with the keyboard LED";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "pipewire-pulse.service" ];
    unitConfig = {
      ConditionUser = username;
      ConditionPathExists = "/sys/class/leds/hda::mute/brightness";
    };
    path = [ pkgs.pulseaudio ];
    environment.LC_ALL = "C";
    script = ''
      set -euo pipefail
      led=/sys/class/leds/hda::mute
      printf 'none\n' > "$led/trigger"

      # Skip transient failures, such as the default sink briefly vanishing
      # on unplug; a lost server connection ends the subscribe loop instead.
      update_led() {
        local mute
        mute=$(pactl get-sink-mute @DEFAULT_SINK@) || return 0
        case "$mute" in
          "Mute: yes") printf '1\n' > "$led/brightness" ;;
          "Mute: no") printf '0\n' > "$led/brightness" ;;
        esac
      }

      update_led
      pactl subscribe | while IFS= read -r event; do
        case "$event" in
          *" on sink #"*|*" on server #"*) update_led ;;
        esac
      done
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
      ExecStopPost = pkgs.writeShellScript "restore-mute-led" ''
        if [ -e /sys/class/leds/hda::mute/trigger ]; then
          printf 'audio-mute\n' > /sys/class/leds/hda::mute/trigger
        fi
      '';
    };
  };
}
