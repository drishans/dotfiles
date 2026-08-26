{ pkgs, ... }: {
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
        cp ${./ishC_SI_20260309.bin} \
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
