{ pkgs, ... }:
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
  };
}
